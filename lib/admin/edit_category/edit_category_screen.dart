import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/bloc/edit_category/edit_category_bloc.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/constants/utils/navigation_service.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/models/category_model.dart';

class EditCategoryScreen extends StatelessWidget {
  EditCategoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var main = WillPopScope(
      onWillPop: () {
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
              SizedBox(
                height: 20,
              ),

              BlocBuilder<EditCategoryBloc, EditCategoryState>(
                builder: (context, state) {
                  List<Category> categoryList = [Category(name: SELECT_VALUE)];

                  if (state.categoryList != null) {
                    categoryList.addAll(state.categoryList);
                  }

                  return categorySearchFiled((category) {
                    context.read<EditCategoryBloc>().add(
                        LoadSelectedCategoryDetail(
                            selctedCatOrSubCat: category));
                  },
                      selectedCategory: state.selectedCatOrSubCat,
                      categoryList: categoryList,
                      title: "Select Category / Sub Category");
                },
              ),

              SizedBox(height: 10,),
              Divider(height: 5,),
              SizedBox(height: 15,),

              BlocBuilder<EditCategoryBloc, EditCategoryState>(
                builder: (context, state) {
                  List<Category> categoryList = [Category(name: SELECT_VALUE)];

                  if (state.categoryList != null) {
                    categoryList.addAll(state.categoryList
                        .where((x) => x.catId == "")
                        .toList());
                  }

                  return state.selectedCatOrSubCat.name != SELECT_VALUE &&
                          state.selectedCatOrSubCat.catId != ""
                      ? spinnerField((category) {
                          context.read<EditCategoryBloc>().add(
                              SelectCategoryForSubCategory(
                                  selectedCategory: category));
                        },
                          selectedCategory: state.selectedCategory,
                          categoryList: categoryList,
                          title: "Select Category")
                      : SizedBox();
                },
              ),
              BlocBuilder<EditCategoryBloc, EditCategoryState>(
                builder: (context, state) {
                  return formTextField(
                      controller: state.nameController,
                      focus: state.nameFocus,
                      hint: "Name");
                },
              ),
              BlocBuilder<EditCategoryBloc, EditCategoryState>(
                builder: (context, state) {
                  return formTextField(
                      controller: state.descController,
                      focus: state.descFocus,
                      hint: "Description");
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: BlocBuilder<EditCategoryBloc, EditCategoryState>(
                      builder: (context, state) {
                        return appButton(() {
                          // var currentState = context.read<EditCategoryBloc>();

                          if (state.selectedCatOrSubCat ==
                              Category(name: SELECT_VALUE)) {
                            snac("Please select any category or sub category",
                                error: true);
                          } else if (state.selectedCatOrSubCat.catId != null &&
                              state.selectedCatOrSubCat.catId != "" &&
                              state.selectedCategory ==
                                  Category(name: SELECT_VALUE)) {
                            snac("Please select one category", error: true);
                          } else if (state.nameController.text.isEmpty) {
                            snac("Please type name", error: true);
                          } else if (state.descController.text.isEmpty) {
                            snac("Please type description", error: true);
                          } else {
                            context
                                .read<EditCategoryBloc>()
                                .add(UpdateParticularCatOrSubCat());
                          }
                        },
                            text: "Update",
                            isExpanded:
                                state.selectedCatOrSubCat.name != SELECT_VALUE
                                    ? true
                                    : false);
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<EditCategoryBloc, EditCategoryState>(
                      builder: (context, state) {
                        return state.selectedCatOrSubCat.name != SELECT_VALUE
                            ? appButton(() {
                                context.read<EditCategoryBloc>().add(
                                    EnableOrDisableCategory(
                                        isEnable: !state.isEnable));
                              },
                                text: state.isEnable ? "Disable" : "Enable",
                                isExpanded: true)
                            : SizedBox();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    widgetList.add(main);
    widgetList.add(BlocBuilder<EditCategoryBloc, EditCategoryState>(
        builder: (context, state) =>
            state.isLoading ? loader() : const SizedBox()));
    return Stack(children: widgetList);
  }


  Widget formTextField(
      {String hint,
      TextEditingController controller,
      FocusNode focus,
      FocusNode focusNext,
      String validation,
      int minLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 2 + 2,
              top: SizeConfig.blockSizeVertical * 1),
          child: Text(hint),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2,
              vertical: SizeConfig.blockSizeVertical * 0.5),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.black38, width: 1),
              color: iconBGGrey),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            focusNode: focus,
            minLines: minLines ?? 1,
            maxLines: minLines != null ? minLines + 3 : 1,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: InputBorder.none,
            ),
            onSaved: (String value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String value) {
              return validation != null
                  ? value.contains('')
                      ? validation
                      : null
                  : null;
            },
          ),
        ),
      ],
    );
  }

  snac(String message, {bool error, bool success}) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext)
        .showSnackBar(SnackBar(
            content: Text(
      message,
      style: TextStyle(
          color: error != null && error
              ? Colors.red
              : success != null && success
                  ? Colors.green
                  : Colors.white),
    )));
  }

  Widget categorySearchFiled(Function onClick(Category value),{Category selectedCategory, List<Category> categoryList, String title}){
    return Container(

      margin:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          color: primaryColor),
      child: Row(
        children: [
          Text(
            "Category: ",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
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
          ))
        ],
      ),
    );
  }

  Widget spinnerField(Function onClick(Category value),
      {Category selectedCategory, List<Category> categoryList, String title}) {
    return BlocBuilder<EditCategoryBloc, EditCategoryState>(
      builder: (context, state) {
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
      },
    );
  }
}
