import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/add_category/add_category_controller.dart';
import 'package:merch/admin/add_category/category_cupid.dart';
import 'package:merch/bloc/category/category_bloc.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/main.dart';
import 'package:merch/models/category_model.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({Key key,this.schoolId,this.ifSubcategory}) : super(key: key);
  String schoolId;
  bool ifSubcategory;
  var controller=getIt<AddCategoryModel>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        getIt.unregister<AddCategoryModel>();
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
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
                      leading:  BlocBuilder<CategoryCubit, int>(
                        builder: (context, category) => Radio(
                          value: 1,
                          groupValue: category,
                          onChanged: (int value) {
                            context.read<CategoryCubit>().one();
                          },
                        ),
                      ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                      title: const Text('SubCategory'),
                      leading: BlocBuilder<CategoryCubit, int>(
                        builder: (context, category) => Radio(
                          value: 2,
                          groupValue: category,
                          onChanged: (int value) {
                            context.read<CategoryCubit>().two();
                          },
                        ),
                      ),
                  ),
                ),
              ]),
              BlocBuilder<CategoryCubit, int>(
                builder: (context, category) => category==2?spinnerField(() {
                categoryList(context,"Category",  controller.categoryController);
                  }, hint: "Category",controller: controller.categoryController) : const SizedBox(),
              ),

              formTextField(controller: controller.nameController,
                  focus: controller.nameFocus,
                  hint: "Name"),
              formTextField(controller: controller.descController,
                  focus: controller.descFocus,
                  hint: "Description"),
                  appButton(() {
                    if(controller.catValue==2 && controller.categoryController.text.isEmpty){
                      snac("Please select one category",error: true);
                    }
                    else if(controller.nameController.text.isEmpty){
                      snac("Please type name",error: true);
                    }
                    else if(controller.descController.text.isEmpty) {
                      snac("Please type description",error: true);
                    }
                    else{
                      controller.addCategory(schoolId);
                    }
                  }, text: controller.catValue == 2 ? "Add SubCategory" : "Add Category")
            ],
          ),
        ),
      ),
    );
  }
  categoryList(BuildContext context,String title, TextEditingController controller){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
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
                      return ListView(
                        children: state.categories.where((element) => element.catId=="")
                            .map((category) => categoryListItem(context,category))
                            .toList(),
                      );
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
 Widget categoryListItem(context, Category category){
    return InkWell(
      onTap: (){
        controller.selectedCategory=category;
        controller.categoryController.text=category.name;
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
