import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/repositories/category/category_repository.dart';

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

    var categoryOb = Category(
      isEnabled: true,
      isSubCategory: catValue==2 && categoryController.text.isNotEmpty ?? false,
      catId: catValue==2 && categoryController.text.isNotEmpty?selectedCategory.uId:"",
      description: descController.text,
      name: nameController.text,
    );

    CategoryRepository categoryRepo = CategoryRepository();
     categoryRepo.addCategories(schoolId: schoolId,categoryOb: categoryOb,controller: this);

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

