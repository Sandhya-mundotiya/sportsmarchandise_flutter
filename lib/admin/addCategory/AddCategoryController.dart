import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:merch/constants/FirestoreConstants.dart';
import 'package:merch/models/category_model.dart';

abstract class AddCategoryModel {
  var catValue = 1.obs;

  var nameController=TextEditingController();
  var descController=TextEditingController();
  var isCategory=false.obs;
  var nameFocus=FocusNode();
  var descFocus=FocusNode();

  addCategory(String schoolId);
}

class AddCategoryController extends AddCategoryModel {

  Future<void> addCat(String schoolId) {
    CollectionReference reference = FirebaseFirestore.instance.collection(SCHOOL_TABLE).doc(schoolId).collection(CATEGORY_TABLE);
    var categoryOb = Category(isEnabled: true,
        catId: "",
        description: descController.text,
        name: nameController.text,
        uId: "");
    return reference
        .add(categoryOb)
        .then((value){
      reference.doc(value.id).update({'uId':value.id});
      descController.text="";
      nameController.text="";
    })
        .catchError((error) => print("Failed to add Category: $error"));
  }

  @override
  addCategory(schoolId) {
    addCat(schoolId);
  }
}