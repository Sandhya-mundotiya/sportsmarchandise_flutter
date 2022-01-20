import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

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
  List<Asset> images = <Asset>[];
  var nameFocus=FocusNode();
  var descFocus=FocusNode();
  var priceFocus=FocusNode();
  init();
  addProduct(String schoolId,BuildContext context);
}

class AddProductController extends AddProductModel {

  @override
  addProduct(String schoolId,BuildContext context) {

    uploadFiles(images).then((value){
      addProductToFirestore(value,context);
    });
  }

  @override
  init() {

  }
addProductToFirestore(List<String> images,BuildContext context){


    var currentDate = DateTime.now();
  DateTime formattedDate = new DateTime(currentDate.year, currentDate.month, currentDate.day);

    var productObj=Product(
        name: nameController.text,
        catId: subCategoryController.text.isNotEmpty?selectedSubCategory.uId:selectedCategory.uId,
        description: descController.text,
        createdDate: formattedDate.microsecondsSinceEpoch,
        images: images,
        price: priceController.text,
    );

    ProductRepository productRepository= ProductRepository();
    productRepository.addProduct(productObj: productObj,context: context);


}
  Future<List<String>> uploadFiles(List<Asset> _images) async {
    var imageUrls = await Future.wait(_images.map((_image) => uploadFile(_image)));
    return imageUrls;
  }

  Future<String> uploadFile(Asset _image) async {

     // var path = await MultipartFile.fromFile('assets/${_image.name}', filename: _image.name);
     var path = await FlutterAbsolutePath.getAbsolutePath(_image.identifier);

     print("path : " + path);
    String fileName = path.split('/').last;
    var ref =  FirebaseStorage.instance.ref('/$PRODUCT_IMAGES/$fileName');
    await ref.putFile(File(path));
    return await ref.getDownloadURL();
  }
}