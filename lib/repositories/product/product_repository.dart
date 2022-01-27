import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:merch/admin/bloc/add_product/add_product_bloc.dart'
    as add_product_bloc;
import 'package:merch/admin/bloc/edit_product/edit_product_bloc.dart'
    as edit_product_bloc;
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/base_product_repository.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

GetIt getIt = GetIt.instance;

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

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
    // var path = await MultipartFile.fromFile('assets/${_image.name}', filename: _image.name);
    var path = await FlutterAbsolutePath.getAbsolutePath(_image.identifier);

    print("path : " + path);
    String fileName = path.split('/').last;
    var ref = FirebaseStorage.instance.ref('/$PRODUCT_IMAGES/$fileName');
    await ref.putFile(File(path));
    return await ref.getDownloadURL();
  }

  @override
  Stream<List<Product>> getAllProductsUser({String catId = "", String price = "", int purchaseDate = 0}) {
    if (catId != "" && price != "") {
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

    return _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(PRODUCT_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }
}
