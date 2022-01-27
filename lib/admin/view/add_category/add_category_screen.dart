import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/bloc/add_category/add_category_bloc.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/models/category_model.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetList = [];
    var main = WillPopScope(
      onWillPop: (){
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
                    leading:  BlocBuilder<AddCategoryBloc, AddCategoryState>(
                      builder: (context, state) => Radio(
                        value: 1,
                        groupValue: state.catValue,
                        onChanged: (int value) {
                          context.read<AddCategoryBloc>().add(UpdateCatValue(catValue: value));
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('SubCategory'),
                    leading: BlocBuilder<AddCategoryBloc, AddCategoryState>(
                      builder: (context, state) => Radio(
                        value: 2,
                        groupValue: state.catValue,
                        onChanged: (int value) {
                          context.read<AddCategoryBloc>().add(UpdateCatValue(catValue: value));
                        },
                      ),
                    ),
                  ),
                ),
              ]),
              BlocBuilder<AddCategoryBloc, AddCategoryState>(
                builder: (context, state) {
                  List<Category> categoryList = [Category(name: SELECT_VALUE)];

                  if (state.categoryList != null) {
                    categoryList.addAll(state.categoryList
                        .where((x) => x.catId == "")
                        .toList());
                  }

                  return state.catValue == 2
                      ? spinnerField((category) {
                    context.read<AddCategoryBloc>().add(
                        SelectCategoryForSubCategory(
                            selectedCategory: category));
                  },
                      selectedCategory: state.selectedCategory,
                      categoryList: categoryList,
                      title: "Category")
                      : SizedBox();
                },
              ),

              BlocBuilder<AddCategoryBloc, AddCategoryState>(
                builder: (context, state) {
                  return formTextField(controller: state.nameController,
                      focus: state.nameFocus,
                      hint: "Name");
                },
              ),
              BlocBuilder<AddCategoryBloc, AddCategoryState>(
                builder: (context, state) {
                  return formTextField(controller: state.descController,
                      focus: state.descFocus,
                      hint: "Description");
                },
              ),
              BlocBuilder<AddCategoryBloc, AddCategoryState>(
                builder: (_, state) {
                  return appButton(() {
                    if(state.catValue==2 && state.selectedCategory == SELECT_VALUE){
                      snac("Please select one category",error: true);
                    }
                    else if(state.nameController.text.isEmpty){
                      snac("Please type name",error: true);
                    }
                    else if(state.descController.text.isEmpty) {
                      snac("Please type description",error: true);
                    }
                    else{
                        context.read<AddCategoryBloc>().add(AddNewCategory(context: context));
                    }
                  }, text: state.catValue == 2 ? "Add SubCategory" : "Add Category");
                },
              )
            ],
          ),
        ),
      ),
    );
    widgetList.add(main);
    widgetList.add(BlocBuilder<AddCategoryBloc, AddCategoryState>(
        builder: (context, state) =>
        state.isLoading ? loader() : const SizedBox()));
    return Stack(children: widgetList);

  }

  Widget spinnerField(Function onClick(Category value),
      {Category selectedCategory, List<Category> categoryList, String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 2 + 2,
              top: SizeConfig.blockSizeVertical * 1),
          child: Text(title),
        ),
        Container(
          height: 42,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2,
              vertical: SizeConfig.blockSizeVertical * 0.5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.black38, width: 1),
              color: iconBGGrey),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Category>(
              value: selectedCategory,
              items: categoryList.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (Category item) {
                onClick(item);
              },
            ),
          ),
        ),
      ],
    );
  }
  
}
