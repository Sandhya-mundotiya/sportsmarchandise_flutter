
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/addCategory/AddCategoryController.dart';
import 'package:merch/admin/addCategory/AddCategoryScreen.dart';
import 'package:merch/admin/addCategory/CategoryCupid.dart';
import 'package:merch/admin/addItem/AssetsCupid.dart';
import 'package:merch/admin/addItem/LoaderCupid.dart';
import 'package:merch/bloc/category/category_bloc.dart';
import 'package:merch/common/CommonWidgets.dart';
import 'package:merch/constants/AppColor.dart';
import 'package:merch/constants/utils/SizeConfig.dart';
import 'package:merch/main.dart';
import 'package:merch/models/category_model.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import 'AddProductController.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key key,this.schoolId}) : super(key: key);
  String schoolId;
  var controller=getIt<AddProductModel>();

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var main= WillPopScope(
      onWillPop: (){
        getIt.unregister<AddProductModel>();
        context.read<AssetCubit>().clear();
        context.read<LoaderCubit>().hideLoader();
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: Column(
          children: [
            productImagesView(),
            Expanded(
              child: Column(
                children: [
                  appButton(() async {
                    try {
                      await MultiImagePicker.pickImages(
                        maxImages: 5,
                        enableCamera: true,
                        selectedAssets: controller.images,
                        cupertinoOptions: const CupertinoOptions(
                          takePhotoIcon: "Camera",
                          doneButtonTitle: "Done",
                        ),
                        materialOptions: const MaterialOptions(
                          actionBarTitle: "Sports",
                          allViewTitle: "All Photos",
                          useDetailsView: false,
                          selectCircleStrokeColor: "#000000",
                        ),
                      ).then((value) {
                        controller.images=value;
                        context.read<AssetCubit>().refresh();
                      });
                    } on Exception catch (e) {
                     // error = e.toString();
                    }
                  },text: "Add/Change Images",isExpanded: true),

                  formTextField(controller: controller.nameController,focus: controller.nameFocus,hint: "Name",focusNext: controller.priceFocus),
                  formTextField(controller: controller.priceController,focus: controller.priceFocus,hint: "Price",focusNext: controller.descFocus),

                  spinnerField(() {
                    categoryList(context,"Category",  controller.categoryController);
                  }, hint: "Category",controller: controller.categoryController),

                 spinnerField(() {
                   categoryList(context,"Subcategory",  controller.subCategoryController,catId: controller.selectedCategory.uId);
                 }, hint: "Subcategory",controller: controller.subCategoryController),

                  formTextField(controller: controller.descController,focus: controller.descFocus,hint: "Description"),
                  Row(
                    children: [
                      Expanded(
                        child: appButton((){
                          getIt.registerSingleton<AddCategoryModel>(AddCategoryController());
                          context.read<CategoryCubit>().one();
                          Navigator.push(context,MaterialPageRoute(builder: (context) => AddCategoryScreen(schoolId: schoolId)));
                        },text: "Add Category",isExpanded: true),
                      ),
                      Expanded(
                        child: appButton((){
                          getIt.registerSingleton<AddCategoryModel>(AddCategoryController(isSubcategory: true));
                          context.read<CategoryCubit>().two();
                          Navigator.push(context,MaterialPageRoute(builder: (context) => AddCategoryScreen(schoolId: schoolId)));
                        },text: "Add SubCategory",isExpanded: true),
                      )
                    ],
                  ),
                  appButton(()
                  {
                    if(controller.images.isEmpty){
                      snac("Please upload at least one product image",error: true);
                    }
                    else if(controller.nameController.text.isEmpty){
                      snac("Please type name",error: true);
                    }
                    else if(controller.priceController.text.isEmpty){
                      snac("Please add product price",error: true);
                    }
                    else if(controller.categoryController.text.isEmpty){
                      snac("Please select category",error: true);
                    }
                    else if(controller.subCategoryController.text.isEmpty){
                      snac("Please select Subcategory",error: true);
                    }
                    else if(controller.descController.text.isEmpty) {
                      snac("Please type description",error: true);
                    }
                    else {
                      context.read<LoaderCubit>().showLoader();
                      controller.addProduct(schoolId,context);
                    }
                  },text: "Add Product",isExpanded: true)
                ],
              ),
            ),
          ],
        ),
      ),
    );
    widgetList.add(main);
    widgetList.add(
        BlocBuilder<LoaderCubit, bool>(
            builder: (context, bool) => bool?loader(): const SizedBox()
        ));
    return Stack(children: widgetList);
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
          controller.selectedSubCategory=category;
          controller.subCategoryController.text=category.name;
        }
        else{
          if(controller.selectedCategory!=null && controller.selectedCategory.uId!=category.uId){
            controller.selectedCategory=category;
            controller.categoryController.text=category.name;

            controller.selectedSubCategory=const Category();
            controller.subCategoryController.text="";
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

  Widget productImagesView() {
    return BlocBuilder<AssetCubit, List<Asset>>(
        builder: (context, assets) => assets!=null && assets.isNotEmpty?Container(
          height: 170,
          margin: const EdgeInsets.only(top: 5),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(assets.length, (index) {
              Asset asset = assets[index];
              return Container(
                color: Colors.black,
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(3),
                child: AssetThumb(
                  asset: asset,
                  width: 100,
                  height: 100,
                ),
              );
            }).toList(),
          ),
        ): const SizedBox()
    );
  }
}
