import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merch/admin/addCategory/AddCategoryController.dart';
import 'package:merch/admin/addCategory/AddCategoryScreen.dart';
import 'package:merch/common/CommonWidgets.dart';
import 'package:merch/main.dart';

const List<String> list=["Softuvo Solutions"
  ,"Mohali Tower","Asia","India","Softuvo Solutions","Mohali Tower","Asia","India"
];
class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key key,this.schoolId}) : super(key: key);
  String schoolId;
  List<String> imageList=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            formTextField(controller: TextEditingController(),focus: FocusNode(),hint: "Name"),
            formTextField(controller: TextEditingController(),focus: FocusNode(),hint: "Price"),
            spinnerField((){
              bottomSheet(context,"Category",list,TextEditingController());
            },hint: "Category"),
            spinnerField((){
              bottomSheet(context,"Subcategory",list,TextEditingController());
            },hint: "Subcategory"),
            formTextField(controller: TextEditingController(),focus: FocusNode(),hint: "Description"),
            Row(
              children: [
                Expanded(
                  child: appButton((){
                    getIt.registerSingleton<AddCategoryModel>(AddCategoryController());
                    Navigator.push(context,MaterialPageRoute(builder: (context) => AddCategoryScreen(schoolId: schoolId)));
                  },text: "Add Category",isExpanded: true),
                ),
                Expanded(
                  child: appButton((){
                    getIt.registerSingleton<AddCategoryModel>(AddCategoryController());
                    Navigator.push(context,MaterialPageRoute(builder: (context) => AddCategoryScreen(schoolId: schoolId)));
                  },text: "Add SubCategory",isExpanded: true),
                )
              ],
            ),
            appButton((){},text: "Add Product",isExpanded: true)
          ],
        ),
      ),
    );
  }
}
