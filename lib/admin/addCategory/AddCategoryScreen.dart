import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merch/admin/addCategory/AddCategoryController.dart';
import 'package:merch/admin/addItem/AddProduct.dart';
import 'package:merch/common/CommonWidgets.dart';
import 'package:merch/main.dart';
class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({Key key,this.schoolId,this.ifSubcategory}) : super(key: key);
  String schoolId;
  bool ifSubcategory;
  var controller=getIt<AddCategoryModel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category/SubCategory'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: ListTile(
                  title: const Text('Category'),
                  leading:  Obx(()=>Radio(
                    value: 1,
                    groupValue: controller.catValue.value,
                    onChanged: (int value) {
                      controller.catValue.value=value;
                      controller.catValue.refresh();
                    },
                  ))
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('SubCategory'),
                  leading: Obx(()=>Radio(
                    value: 2,
                    groupValue: controller.catValue.value,
                    onChanged: (int value) {
                      controller.catValue.value=value;
                      controller.catValue.refresh();
                    },
                  ))
                ),
              ),
            ],),
           Obx(()=>getIt<AddCategoryModel>().catValue.value==2?spinnerField((){
             bottomSheet(context,"Category",list,TextEditingController());
           },hint: "Category"):const SizedBox()),
            formTextField(controller: controller.nameController,focus: FocusNode(),hint: "Name"),
            formTextField(controller: controller.descController,focus: FocusNode(),hint: "Description"),
            Obx(()=>appButton((){
              controller.addCategory(schoolId);
            },text:controller.catValue.value==2?"Add SubCategory":"Add Category"))
            ],
        ),
      ),
    );
  }
}
