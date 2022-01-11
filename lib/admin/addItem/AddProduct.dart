import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/addCategory/AddCategoryController.dart';
import 'package:merch/admin/addCategory/AddCategoryScreen.dart';
import 'package:merch/bloc/category/category_bloc.dart';
import 'package:merch/common/CommonWidgets.dart';
import 'package:get/get.dart';
import 'package:merch/constants/AppColor.dart';
import 'package:merch/constants/utils/SizeConfig.dart';
import 'package:merch/main.dart';
import 'package:merch/models/category_model.dart';

import 'AddProductController.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key key,this.schoolId}) : super(key: key);
  String schoolId;
  List<String> imageList=[];
  var controller=getIt<AddProductModel>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        getIt.unregister<AddProductModel>();
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              formTextField(controller: TextEditingController(),focus: FocusNode(),hint: "Name"),
              formTextField(controller: TextEditingController(),focus: FocusNode(),hint: "Price"),
          spinnerField(() {
                categoryList(context,"Category",  controller.categoryController);
              }, hint: "Category",controller: controller.categoryController),
             Obx(()=>controller.selectedCategory.value.uId!=null?spinnerField(() {
               categoryList(context,"Subcategory",  controller.subCategoryController,catId: controller.selectedCategory.value.uId);
             }, hint: "Subcategory",controller: controller.subCategoryController):const SizedBox()) ,

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
                      getIt.registerSingleton<AddCategoryModel>(AddCategoryController(isSubcategory: true));
                      Navigator.push(context,MaterialPageRoute(builder: (context) => AddCategoryScreen(schoolId: schoolId)));
                    },text: "Add SubCategory",isExpanded: true),
                  )
                ],
              ),
              appButton((){},text: "Add Product",isExpanded: true)
            ],
          ),
        ),
      ),
    );
  }
  categoryList(BuildContext context,String title, TextEditingController controller,{String catId}){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration:const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              AppBar(
                centerTitle: true,
                title: Text(title,style:const TextStyle(color: appWhite)),
                automaticallyImplyLeading: false,
                actions: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding:EdgeInsets.all(8.0),
                      child: Icon(Icons.close,color: appWhite,size: 25),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is CategoryLoaded) {
                      return state.categories.where((element) => element.catId==(catId ?? "") && element.isEnabled==true).isNotEmpty?ListView(
                        children: state.categories.where((element) => element.catId==(catId ?? "") && element.isEnabled==true)
                            .map((category) => categoryListItem(context,category,catId!=null?true:false))
                            .toList(),
                      ):const Center(child: Text('No SubCategories Found',style: TextStyle(color: Colors.black),));
                    } else {
                      return const Text('Something went wrong.');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget categoryListItem(context, Category category,bool isSubCat){
    return InkWell(
      onTap: (){
        if(isSubCat){
          controller.selectedSubCategory.value=category;
          controller.subCategoryController.text=category.name;
          controller.selectedCategory.refresh();
        }
        else{
          if( controller.selectedCategory.value!=null && controller.selectedCategory.value.uId!=category.uId){
            controller.selectedCategory.value=category;
            controller.categoryController.text=category.name;
            controller.selectedCategory.refresh();

            controller.selectedSubCategory.value=const Category();
            controller.subCategoryController.text="";
            controller.selectedSubCategory.refresh();
          }
        }

        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical*1.5,
            horizontal: SizeConfig.blockSizeHorizontal*2),
        child: Center(child: Text(category.name,style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3.5,fontWeight: FontWeight.w500,color: appBlack))),
      ),
    );
  }
}
