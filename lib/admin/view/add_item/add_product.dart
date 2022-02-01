import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/view/add_category/add_category_screen.dart';
import 'package:merch/admin/view/edit_category/edit_category_screen.dart';
import 'package:merch/admin/bloc/add_category/add_category_bloc.dart';
import 'package:merch/admin/bloc/add_product/add_product_bloc.dart';
import 'package:merch/admin/bloc/category/category_bloc.dart';
import 'package:merch/admin/bloc/edit_category/edit_category_bloc.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/main.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/repositories/category/category_repository.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key key, this.schoolId}) : super(key: key);
  String schoolId;
  // var controller = getIt<AddProductModel>();

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
          title: const Text('Add Product'),
        ),
        body: Column(
          children: [
            productImagesView(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<AddProductBloc, AddProductState>(
                      builder: (context, state) {
                        return appButton(() async {
                          try {
                            await MultiImagePicker.pickImages(
                              maxImages: 5,
                              enableCamera: true,
                              selectedAssets: state.images,
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
                              context
                                  .read<AddProductBloc>()
                                  .add(AddImagesToModel(images: value));
                            });
                          } on Exception catch (e) {
                            // error = e.toString();
                          }
                        }, text: "Add/Change Images", isExpanded: true);
                      },
                    ),
                    BlocBuilder<AddProductBloc, AddProductState>(
                      builder: (context, state) {
                        return formTextField(
                            controller: state.nameController,
                            focus: state.nameFocus,
                            hint: "Name",
                            focusNext: state.priceFocus);
                      },
                    ),
                    BlocBuilder<AddProductBloc, AddProductState>(
                      builder: (context, state) {
                        return formTextField(
                            controller: state.priceController,
                            focus: state.priceFocus,
                            hint: "Price",
                            focusNext: state.descFocus);
                      },
                    ),
                    BlocBuilder<AddProductBloc, AddProductState>(
                      builder: (innerContext, state) {
                        return spinnerField(() {
                          categoryList(innerContext, context, "Category",
                              state.categoryController);
                        },
                            hint: "Category",
                            controller: state.categoryController);
                      },
                    ),
                    BlocBuilder<AddProductBloc, AddProductState>(
                      builder: (innerContext, state) {
                        return spinnerField(() {
                          categoryList(innerContext, context, "Subcategory",
                              state.subCategoryController,
                              catId: state.selectedCategory.uId);
                        },
                            hint: "Subcategory",
                            controller: state.subCategoryController);
                      },
                    ),
                    BlocBuilder<AddProductBloc, AddProductState>(
                      builder: (context, state) {
                        return formTextField(
                            controller: state.descController,
                            focus: state.descFocus,
                            hint: "Description");
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: appButton(() {
                            // getIt.registerSingleton<AddCategoryModel>(
                            //     AddCategoryController());
                            //  context.read<CategoryCubit>().one();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                          create: (context) => AddCategoryBloc(
                                              categoryBloc:
                                                  context.read<CategoryBloc>(),
                                              categoryRepository:
                                                  CategoryRepository(),
                                              catValue: 1),
                                          child: AddCategoryScreen(),
                                        )));
                          }, text: "Add Category", isExpanded: true),
                        ),
                        Expanded(
                          child: appButton(() {
                            // getIt.registerSingleton<AddCategoryModel>(
                            //     AddCategoryController(isSubcategory: true));
                            //  context.read<CategoryCubit>().two();
                             Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                          create: (context) => AddCategoryBloc(
                                              categoryBloc:
                                                  context.read<CategoryBloc>(),
                                              categoryRepository:
                                                  CategoryRepository(),
                                              catValue: 2),
                                          child: AddCategoryScreen(),
                                        )));
                          }, text: "Add SubCategory", isExpanded: true),
                        )
                      ],
                    ),
                    appButton(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                    create: (_) => EditCategoryBloc(
                                        categoryBloc:
                                            BlocProvider.of<CategoryBloc>(
                                                context),
                                        categoryRepository:
                                            CategoryRepository()),
                                    child: EditCategoryScreen(),
                                  )));
                    }, text: EDIT_CATEGORY, isExpanded: true),
                    BlocBuilder<AddProductBloc, AddProductState>(
                      builder: (innerContext, state) {
                        return appButton(() {
                          if (state.images.isEmpty) {
                            snac("Please upload at least one product image",
                                error: true);
                          } else if (state.nameController.text.isEmpty) {
                            snac("Please type name", error: true);
                          } else if (state.priceController.text.isEmpty) {
                            snac("Please add product price", error: true);
                          } else if (state.categoryController.text.isEmpty) {
                            snac("Please select category", error: true);
                          }
                          // else if(controller.subCategoryController.text.isEmpty){
                          //   snac("Please select Subcategory",error: true);
                          // }
                          else if (state.descController.text.isEmpty) {
                            snac("Please type description", error: true);
                          } else {
                            context
                                .read<AddProductBloc>()
                                .add(AddProduct(context: context));
                          }
                        }, text: "Add Product", isExpanded: true);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    widgetList.add(main);
    widgetList.add(BlocBuilder<AddProductBloc, AddProductState>(
        builder: (context, state) =>
            state.isLoading ? loaderAdmin() : const SizedBox()));
    return Stack(children: widgetList);
  }

  categoryList(BuildContext context, BuildContext globalContext, String title,
      TextEditingController controller,
      {String catId}) {
    showModalBottomSheet(
      context: globalContext,
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
                title: Text(title, style: const TextStyle(color: appWhite)),
                automaticallyImplyLeading: false,
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(globalContext);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close, color: appWhite, size: 25),
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
                      if (title == "Category") {
                        return state.categories
                                .where((element) =>
                                    element.catId == "" &&
                                    element.isEnabled == true)
                                .isNotEmpty
                            ? ListView(
                                children: state.categories
                                    .where((element) =>
                                        element.catId == "" &&
                                        element.isEnabled == true)
                                    .map((category) => categoryListItem(
                                        context,
                                        globalContext,
                                        category,
                                        catId != null ? true : false))
                                    .toList(),
                              )
                            : Center(
                                child: Text(
                                'No $title Found',
                                style: TextStyle(color: Colors.black),
                              ));
                      } else {
                        return state.categories
                                .where((element) =>
                                    element.catId == catId &&
                                    element.isEnabled == true)
                                .isNotEmpty
                            ? ListView(
                                children: state.categories
                                    .where((element) =>
                                        element.catId == catId &&
                                        element.isEnabled == true)
                                    .map((category) => categoryListItem(
                                        context,
                                        globalContext,
                                        category,
                                        catId != null ? true : false))
                                    .toList(),
                              )
                            : Center(
                                child: Text(
                                'No $title Found',
                                style: TextStyle(color: Colors.black),
                              ));
                      }
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

  Widget categoryListItem(
      context, BuildContext globalContext, Category category, bool isSubCat) {
    return InkWell(
      onTap: () {
        if (isSubCat) {
          globalContext
              .read<AddProductBloc>()
              .add(AddSelectedSubCategoryModel(selectedSubCategory: category));
        } else {
          globalContext
              .read<AddProductBloc>()
              .add(AddSelectedCategoryModel(selectedCategory: category));
        }
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical * 1.5,
            horizontal: SizeConfig.blockSizeHorizontal * 2),
        child: Center(
            child: Text(category.name,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                    fontWeight: FontWeight.w500,
                    color: appBlack))),
      ),
    );
  }

  Widget productImagesView() {
    return BlocBuilder<AddProductBloc, AddProductState>(
        builder: (context, state) => state.images != null &&
                state.images.isNotEmpty
            ? Container(
                height: 170,
                margin: const EdgeInsets.only(top: 5),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(state.images.length, (index) {
                    Asset asset = state.images[index];
                    return Stack(
                      children: [
                        Container(
                          color: Colors.black,
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(3),
                          child: AssetThumb(
                            asset: asset,
                            height: 170,
                            width:
                                (SizeConfig.blockSizeHorizontal * 40).toInt(),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              context.read<AddProductBloc>().add(
                                  DeleteAssetImage(deleteImageAsset: asset));
                            },
                            child: Icon(
                              Icons.cancel,
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    );
                  }).toList(),
                ),
              )
            : const SizedBox());
  }
}
