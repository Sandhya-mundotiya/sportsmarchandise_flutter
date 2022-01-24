import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:merch/admin/add_item/add_product_controller.dart';
import 'package:merch/admin/add_item/assets_cupid.dart';
import 'package:merch/admin/add_item/loader_cupid.dart';
import 'package:merch/bloc/edit_product/edit_product_bloc.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/base_product_repository.dart';

GetIt getIt = GetIt.instance;

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getAllProducts({String catId = "",int createdDate = 0}) {
    if(catId != ""){
      return _firebaseFirestore
          .collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(PRODUCT_TABLE).where('category',isEqualTo: catId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }else if(createdDate != 0){
      return _firebaseFirestore
          .collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(PRODUCT_TABLE).where('createdDate',isEqualTo: createdDate)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }else if(catId != "" && createdDate != 0){
      return _firebaseFirestore
          .collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(PRODUCT_TABLE)
          .where('category',isEqualTo: catId)
          .where('createdDate',isEqualTo: createdDate)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      });
    }

    return _firebaseFirestore
        .collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(PRODUCT_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }


  @override
  addProduct({Product productObj,BuildContext context}) {
    CollectionReference reference = _firebaseFirestore.collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(PRODUCT_TABLE);
    reference.add(productObj.toJson()).then((value)  {
      context.read<LoaderCubit>().hideLoader();
      context.read<AssetCubit>().clear();
      getIt.unregister<AddProductModel>();
      snac("Product Uploaded Successfully",success: true);
      Navigator.pop(context);
    });
  }

  @override
  updateProduct({Product productObj,BuildContext context}) {
    _firebaseFirestore.collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(PRODUCT_TABLE).doc(productObj.uid).update(
      {
        'description': productObj.description,
      },
    )
        .then((value){
          context.read<EditProductBloc>().add(StopLoading());
          Navigator.pop(context);
      snac("Product Updated Successfully",success: true);

    })
        .catchError((error) => print("Failed to update category: $error"));


  }
}
