import 'package:flutter/cupertino.dart';
import 'package:merch/models/category_model.dart';

abstract class AddProductModel {
  AddProductModel(){
    init();
  }
  var catValue = 1;
  var selectedCategory=Category();
  var selectedSubCategory=Category();
  var nameController=TextEditingController();
  var descController=TextEditingController();
  var priceController=TextEditingController();
  var categoryController=TextEditingController();
  var subCategoryController=TextEditingController();

  var isCategory=false;

  var nameFocus=FocusNode();
  var descFocus=FocusNode();
  var priceFocus=FocusNode();
  init();
  addProduct(String schoolId);
}

class AddProductController extends AddProductModel {
  @override
  addProduct(String schoolId) {

  }

  @override
  init() {

  }

}