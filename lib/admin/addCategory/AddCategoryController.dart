import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:merch/common/CommonWidgets.dart';
import 'package:merch/constants/FirestoreConstants.dart';
import 'package:merch/models/category_model.dart';

abstract class AddCategoryModel {
  AddCategoryModel(){
    init();
  }
  var catValue = 1;
  var selectedCategory=const Category();
  var nameController=TextEditingController();
  var descController=TextEditingController();
  var categoryController=TextEditingController();
  var isCategory=false;
  var nameFocus=FocusNode();
  var descFocus=FocusNode();

  init();
  addCategory(String schoolId);
}

class AddCategoryController extends AddCategoryModel {
  bool isSubcategory;
  AddCategoryController({this.isSubcategory});
  Future<void> addCat(String schoolId) {
    CollectionReference reference = FirebaseFirestore.instance.collection(SCHOOL_TABLE).doc(schoolId).collection(CATEGORY_TABLE);

    var categoryOb = Category(
      isEnabled: true,
      isSubCategory: catValue==2 && categoryController.text.isNotEmpty ?? false,
        catId: catValue==2 && categoryController.text.isNotEmpty?selectedCategory.uId:"",
        description: descController.text,
        name: nameController.text,
    );
    return reference
        .add(categoryOb.toJson())
        .then((value){
      descController.text="";
      nameController.text="";
      snac("Category Created",success: true);
    })
        .catchError((error) => print("Failed to add Category: $error"));
  }

  @override
  addCategory(schoolId) {
    addCat(schoolId);
  }

  @override
  init() {
    if(isSubcategory!=null && isSubcategory) {
      catValue=2;
    }
  }
}

