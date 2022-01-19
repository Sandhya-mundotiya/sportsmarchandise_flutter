import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:file_picker/file_picker.dart';

abstract class FiltersProductModel {

  var catagoryValue;

  FiltersProductModel(){
    catagoryValue = selectValue;
    init();
  }

  init();

  setCatagoryValue({String value});

}

class FiltersProductController extends FiltersProductModel {


  @override
  setCatagoryValue({String value}){
    super.catagoryValue = value;
  }

  @override
  init() {

  }


}