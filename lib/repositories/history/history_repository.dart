import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/constants/utils/navigation_service.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/models/product_history_model.dart';
import 'package:merch/repositories/history/base_history_repository.dart';
import 'package:merch/store/bloc/history_list/history_list_bloc.dart';
import 'package:merch/store/bloc/product_detail/product_detail_user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/store/view/history_list/history_list_screen.dart';



class HistoryRepository extends BaseHistoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  HistoryRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  addHistoryProduct({ProductHistoryModel productObj,BuildContext context}) {
    CollectionReference reference = _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(HISTORY_TABLE);
    reference.add(productObj.toJson()).then((value) {
      context
          .read<ProductDetailUserBloc>()
          .add(StopLoading());
       showAlertDialog(
           message: 'Product has been purchased successfully',
         isShowBtn1: true,
         onTapBtn2: (){
             Navigator.pop(context);
         },
           button1Name: "Go to History",
         onTapBtn1: (){
           Navigator.of(context).popUntil((route){
             return route.settings.name == 'ProductListScreen';
           });
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => BlocProvider(
                       create: (context) =>
                           HistoryListBloc(historyRepository: HistoryRepository()),
                       child: HistoryListScreen())));
         }
       );

       return "Success";
    });
  }

  @override
  Stream<List<ProductHistoryModel>> getAllHistoryProducts({String catId = "", int date = 0}) {


    if (catId != "" && date != 0) {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(HISTORY_TABLE)
          .where('catId', isEqualTo: catId)
          .where('createdAt', isEqualTo: date)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => ProductHistoryModel.fromSnapshot(doc)).toList();
      });
    }
    else if (catId != "") {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(HISTORY_TABLE)
          .where('catId', isEqualTo: catId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => ProductHistoryModel.fromSnapshot(doc)).toList();
      });
    }
    else if (date != 0) {
      return _firebaseFirestore
          .collection(SCHOOL_TABLE)
          .doc(SchoolData.schoolId)
          .collection(HISTORY_TABLE)
          .where('createdAt', isEqualTo: date)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => ProductHistoryModel.fromSnapshot(doc)).toList();
      });
    }

    return _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(HISTORY_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProductHistoryModel.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<List<ProductHistoryModel>> getAllHistoryProductsUser() {
    return _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .doc(SchoolData.schoolId)
        .collection(HISTORY_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProductHistoryModel.fromSnapshot(doc)).toList();
    });
  }



}
