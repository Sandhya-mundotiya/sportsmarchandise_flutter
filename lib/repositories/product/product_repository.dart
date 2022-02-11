import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:merch/admin/bloc/add_product/add_product_bloc.dart'
    as add_product_bloc;
import 'package:merch/admin/bloc/edit_product/edit_product_bloc.dart'
    as edit_product_bloc;
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/constants/utils/navigation_service.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/models/product_history_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/history/history_repository.dart';
import 'package:merch/repositories/product/base_product_repository.dart';
import 'package:merch/store/bloc/product_detail/product_detail_user_bloc.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

GetIt getIt = GetIt.instance;

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;
  Map<String, dynamic> paymentIntentData;


  ProductRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getAllProducts(
      {String catId = "", int createdDate = 0}) {
    if (catId != "" && createdDate != 0) {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('category', isEqualTo: catId)
          .where('createdDate', isEqualTo: createdDate)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }
    else if (catId != "") {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('category', isEqualTo: catId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }
    else if (createdDate != 0) {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('createdDate', isEqualTo: createdDate)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }

    return _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(PRODUCT_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }



  @override
  addProduct(
      {Product productObj, BuildContext context, List<Asset> assetImages}) {
    uploadFiles(assetImages).then((value) {
      addProductToFireStore(
          productObj: productObj, context: context, images: value);
    });
  }

  @override
  updateProduct(
      {Product productObj, BuildContext context, List<Asset> assetImages}) {
    if (assetImages != null && assetImages.length > 0) {
      uploadFiles(assetImages).then((value) {
        uploadProductToFireStore(
            context: context, images: value, productObj: productObj);
      });
    } else {
      uploadProductToFireStore(
          context: context, images: [], productObj: productObj);
    }
  }

  @override
  deleteImage({String image, BuildContext context, String uid}) async {
    var photoRef =
        await FirebaseStorage.instance.ref().storage.refFromURL(image);
    try {
      await photoRef.delete();
    } catch (e) {}
    _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(PRODUCT_TABLE)
        .doc(uid)
        .update(
      {
        'images': FieldValue.arrayRemove([image])
      },
    ).then((value) {
      context.read<edit_product_bloc.EditProductBloc>().add(
          edit_product_bloc.SuccessfulyDeletedImage(deletedImageUrl: image));
      // Navigator.pop(context);
      snac("Image deleted Successfully", success: true);
    }).catchError((error) => print("Failed to delete image: $error"));
  }

  addProductToFireStore(
      {Product productObj, BuildContext context, List<String> images}) {
    Product newProduct = productObj.copyWith(images: images);

    CollectionReference reference = _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(PRODUCT_TABLE);
    reference.add(newProduct.toJson()).then((value) {
      context
          .read<add_product_bloc.AddProductBloc>()
          .add(add_product_bloc.StopLoading());
      Navigator.pop(context);
      snac("Product Added Successfully", success: true);
    });
  }

  uploadProductToFireStore(
      {Product productObj, BuildContext context, List<String> images}) {
    _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(PRODUCT_TABLE)
        .doc(productObj.uid)
        .update(
      {
        'description': productObj.description,
        'name': productObj.name,
        'price': productObj.price,
        'category': productObj.catId,
        if (images != null && images.length > 0)
          'images': FieldValue.arrayUnion(images)
      },
    ).then((value) {
      context
          .read<edit_product_bloc.EditProductBloc>()
          .add(edit_product_bloc.StopLoading());
      Navigator.pop(context);
      snac("Product Updated Successfully", success: true);
    }).catchError((error) => print("Failed to update category: $error"));
  }

  Future<List<String>> uploadFiles(List<Asset> _images) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => uploadFile(_image)));
    return imageUrls;
  }

  Future<String> uploadFile(Asset _image) async {


    var path = "";

    if(Platform.isIOS){
      final temp = await Directory.systemTemp.create();

      final data = await _image.getByteData();
      File file =  await File('${temp.path}/img${_image.name}').writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

      path = file.path;

    }else {
      path = await FlutterAbsolutePath.getAbsolutePath(_image.identifier);
    }




    print("path : " + path);
    String fileName = path.split('/').last;
    var ref = FirebaseStorage.instance.ref('/$PRODUCT_IMAGES/$fileName');
    await ref.putFile(File(path));
    return await ref.getDownloadURL();
  }


  Future<String> uploadHistoryImage(String path) async {
    print("path : " + path);
    String fileName = path.split('/').last;
    var ref = FirebaseStorage.instance.ref('/$PRODUCT_IMAGES/$fileName');
    await ref.putFile(File(path));
    return await ref.getDownloadURL();
  }

  @override
  Stream<List<Product>> getAllProductsUser({String catId = "", String price = "", int purchaseDate = 0}) {
    if (catId != "" && price != "" && purchaseDate != 0) {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('category', isEqualTo: catId)
          .where('price', isEqualTo: price)
          .where('lastBought', isEqualTo: purchaseDate)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }
    else if (catId != "" && price != "") {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('category', isEqualTo: catId)
          .where('price', isEqualTo: price)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }
    else if (catId != "" && purchaseDate != 0) {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('category', isEqualTo: catId)
          .where('lastBought', isEqualTo: purchaseDate)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }
    else if (price != "" && purchaseDate != 0) {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('price', isEqualTo: price)
          .where('lastBought', isEqualTo: purchaseDate)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }
    else if (catId != "") {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('category', isEqualTo: catId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }
    else if (price != "") {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('price', isEqualTo: price)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }
    else if (purchaseDate != 0) {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(PRODUCT_TABLE)
          .where('lastBought', isEqualTo: purchaseDate)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }

    return _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(PRODUCT_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<Product> getProductByProductId({String productId = ""}) {
    var docSnapshot = _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(PRODUCT_TABLE).doc(productId).snapshots();

    return docSnapshot.map((doc){

      if(doc.exists) return Product.fromSnapshot(doc);
      else return null;
    });
  }

  @override
  enableDisableProduct({String uid, BuildContext context, bool isEnable}) {
    _firebaseFirestore.collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(PRODUCT_TABLE).doc(uid).update(
      {
        'isEnabled': isEnable,
      },
    )
        .then((value){
      context.read<edit_product_bloc.EditProductBloc>().add(edit_product_bloc.EnableDisableProductSuccessfully(isEnabled: isEnable));
      if(isEnable) snac("Producr Enabled Successfully",success: true);
      else snac("Product Disabled Successfully",success: true);
    })
        .catchError((error) => print("Failed to update category: $error"));
  }


  //Stripe.................................................................................



  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {

    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
            'Bearer sk_test_RVgGtTjKKo2Q56LR6Wn4ELal',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100 ;
    return a.toString();
  }

  displayPaymentSheet({Product product,BuildContext context,}) async {

    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData['client_secret'],
            confirmPayment: true,
          )).then((newValue){

         updatePurchaseDate(product: product,
            paymentId: paymentIntentData['id'].toString(),
          clientSecretId: paymentIntentData['client_secret'].toString(),
          amount: paymentIntentData['amount'].toString(),
          context: context
        );
        paymentIntentData = null;

      }).onError((error, stackTrace){
        // context
        //     .read<ProductDetailUserBloc>()
        //     .add(StopLoading());

      });


    } on StripeException catch (e) {
      // context
      //     .read<ProductDetailUserBloc>()
      //     .add(StopLoading());
    } catch (e) {
    }
  }

  updatePurchaseDate({Product product,String paymentId, String clientSecretId, String amount,BuildContext context,}) {

    var currentDate = DateTime.now();
    DateTime formattedDate = new DateTime(currentDate.year, currentDate.month, currentDate.day);

    _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(PRODUCT_TABLE)
        .doc(product.uid)
        .update(
      {
       'lastBought': formattedDate.microsecondsSinceEpoch,
        'sold' : (product.sold != null && product.sold != 0 && product.sold != "") ? product.sold+1 : 1
      },
    ).then((value) {
      saveHistoryEntry(product: product,
          paymentId: paymentId,
          clientSecretId: clientSecretId,
          amount: amount,context: context
      );

    }).catchError((error) => print("Failed to update category: $error"));
  }

  saveHistoryEntry({Product product,String paymentId, String clientSecretId, String amount,BuildContext context,}) async{


    final temp = await Directory.systemTemp.create();

    var imageName = Random().nextInt(100000).toString();
    final ByteData imageData = await NetworkAssetBundle(Uri.parse(product.images[0])).load("");
    File file =  await File('${temp.path}/img${imageName}').writeAsBytes(
        imageData.buffer.asUint8List(imageData.offsetInBytes, imageData.lengthInBytes));
    var path = file.path;



    uploadHistoryImage(path).then((value) {
      saveHistoryToFirebase(product: product,paymentId: paymentId,clientSecretId: clientSecretId,amount: amount,context: context,image: value);
    });

  }


  saveHistoryToFirebase({Product product,String paymentId, String clientSecretId, String amount,BuildContext context,String image}) async{
    var currentDate = DateTime.now();
    DateTime formattedDate = new DateTime(currentDate.year, currentDate.month, currentDate.day);


    double amt = (int.parse(amount))/100;
    String amtString = amt.toString();
    ProductHistoryModel historyProduct = ProductHistoryModel(
      productId: product.uid,
      name: product.name,
      price: product.price,
      description: product.description,
      image: image,
      stripePaymentId: paymentId,
      stripeClientSecretId: clientSecretId,
      createdAt: formattedDate.microsecondsSinceEpoch,
      stripeAmount: amtString,
      catId: product.catId,
      adminId: "",
      uid: "",
      userId: "",
    );

    HistoryRepository historyRep = HistoryRepository();
    await historyRep.addHistoryProduct(productObj: historyProduct,context: context);
  }

  @override
  buyProduct({Product product,BuildContext context,}) async{
    try {

      var price = product.price.replaceAll(RegExp('[^0-9]'), '');

      paymentIntentData = await createPaymentIntent(price, 'USD');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData['client_secret'],
              applePay: true,
              googlePay: true,
              testEnv: true,
              style: ThemeMode.light,
              merchantCountryCode: 'US',
              merchantDisplayName: 'ANNIE')).then((value){
      });

      await displayPaymentSheet(product: product,context: context);

    } catch (e, s) {
      // context
      //     .read<ProductDetailUserBloc>()
      //     .add(StopLoading());
      print('exception:$e$s');
    }
  }


}
