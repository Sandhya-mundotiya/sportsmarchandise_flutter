import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:merch/models/category_model.dart';
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
  addProduct(String schoolId);
  loadAssets();
  uploadFiles(List<File> _images);
}

class AddProductController extends AddProductModel {
  @override
  addProduct(String schoolId) {

  }

  @override
  init() {

  }
  Future<List<String>> uploadFiles(List<File> _images) async {
    var imageUrls = await Future.wait(_images.map((_image) => uploadFile(_image)));
    return imageUrls;
  }

  Future<String> uploadFile(File _image) async {
    String fileName = _image.path.split('/').last;
    // Upload file
    var ref =  FirebaseStorage.instance.ref('/uploads/$fileName');
    await ref.putFile(_image);
    // Get URL from Storage reference
    return await ref.getDownloadURL();
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      images = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "Camera",
          doneButtonTitle: "Done",
        ),
        materialOptions: const MaterialOptions(
         // actionBarColor: "#abcdef",
          actionBarTitle: "Sports",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }
}