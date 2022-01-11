import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:merch/models/category_model.dart';

abstract class AddProductModel {
  AddProductModel(){
    init();
  }
  var catValue = 1.obs;
  var selectedCategory=Category().obs;
  var selectedSubCategory=Category().obs;
  var nameController=TextEditingController();
  var descController=TextEditingController();
  var categoryController=TextEditingController();
  var subCategoryController=TextEditingController();

  var isCategory=false.obs;
  var nameFocus=FocusNode();
  var descFocus=FocusNode();

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