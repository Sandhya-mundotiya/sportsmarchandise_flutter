import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:merch/admin/add_item/add_product.dart';
import 'package:merch/admin/add_item/add_product_controller.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/admin/product_details/product_detail_cubid.dart';
import 'package:merch/admin/product_details/product_details_screen.dart';
import 'package:merch/bloc/product/product_bloc.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/main.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key, this.schoolId}) : super(key: key);
  String schoolId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              getIt.registerSingleton<AddProductModel>(AddProductController());
              context
                  .read<ProductBloc>()
                  .add(ClearFilters());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddProductScreen(schoolId: schoolId)));
            },
            child: const Icon(Icons.add, color: Colors.white)),
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            InkWell(
              onTap: () {
                return filterBottomSheet(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                  size: SizeConfig.blockSizeHorizontal * 7.5,
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ProductLoaded) {
                    return state.products.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.blockSizeHorizontal * 1.8,
                                horizontal:
                                    SizeConfig.blockSizeHorizontal * 1.8),
                            child: AlignedGridView.count(
                              crossAxisCount: 2,
                              itemCount: state.products.length,
                              itemBuilder: (context, index) {
                                return productListItem(
                                    context, state.products[index]);
                              },
                            ),
                          )
                        : const Center(
                            child: Text(
                            'No Product Found',
                            style: TextStyle(color: Colors.black),
                          ));
                  } else {
                    return const Text('Something went wrong.');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget productListItem(context, Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (_) => ProductDetailCubit(),
                    child: ProductDetailsScreen(
                      product: product,
                    ))));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal * 1.8,
            horizontal: SizeConfig.blockSizeHorizontal * 1.8),
        child: Container(
          width: SizeConfig.blockSizeHorizontal * 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if(product.images != null && product.images.length > 0) Center(
              //   child: Image.network(
              //       product.images[0],
              //     fit: BoxFit.fill,
              //     height: SizeConfig.blockSizeVertical*20,
              //       width : SizeConfig.blockSizeHorizontal*50
              //   ),
              // ),

              if (product.images != null && product.images.length > 0)
                Center(
                  child: CachedNetworkImage(
                      imageUrl: product.images[0],
                      fit: BoxFit.fill,
                      height: SizeConfig.blockSizeVertical * 20,
                      width: SizeConfig.blockSizeHorizontal * 50,
                      placeholder: (context, url) => Container(
                            // padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*25,left: SizeConfig.blockSizeHorizontal*4,right: SizeConfig.blockSizeVertical*4),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 50,
                                      height: SizeConfig.blockSizeVertical * 20,
                                      color: Colors.white,
                                    ),
                                  ]),
                            ),
                          )),
                ),

              Container(
                color: iconBGGrey,
                width: SizeConfig.blockSizeHorizontal * 50,
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 3,
                  right: SizeConfig.blockSizeHorizontal * 3,
                  bottom: SizeConfig.blockSizeHorizontal * 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeHorizontal * 4),
                      child: Text(product.name,
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              fontWeight: FontWeight.w500,
                              color: appBlack)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeHorizontal * 2),
                      child: Text("₹" + product.price,
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  filterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          // height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  centerTitle: true,
                  title: Text("Filter by",
                      style: const TextStyle(color: appWhite)),
                  automaticallyImplyLeading: false,
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        context
                            .read<ProductBloc>()
                            .add(ClearFilters());
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close, color: appWhite, size: 25),
                      ),
                    ),
                  ],
                ),

                //Catagory
                const Padding(
                  padding:  EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Text("Catagory",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                 Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration:const ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    child: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        List<Category> categories = [];

                        if (state.categories != null) {
                          categories.add(Category(name: SELECT_VALUE));
                          categories.addAll(state.categories
                              .where((x) => x.catId == "")
                              .toList());
                        } else {
                          categories = [Category(name: SELECT_VALUE)];
                        }

                        if ((state is ProductLoaded && state.filter != null)) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<Category>(
                              value: state.filter.category,
                              disabledHint: Text(SELECT_VALUE),
                              items: categories.map((Category category) {
                                return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (Category item) {
                                context
                                    .read<ProductBloc>()
                                    .add(CategoryFilterUpdated(category: item));
                              },
                            ),
                          );
                        } else {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<Category>(
                              value: Category(name: SELECT_VALUE),
                              items: [Category(name: SELECT_VALUE)]
                                  .map((Category category) {
                                return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (var item) {},
                            ),
                          );
                        }
                      },
                    )),

                //Sub Catagory
               const  Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    "Sub Catagory",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration:const  ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    child: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        List<Category> subCategories = [];

                        if (state.categories != null) {
                          subCategories.add(Category(name: SELECT_VALUE));
                          subCategories.addAll(state.categories
                              .where((x) =>
                                  (state.filter.category.catId != null &&
                                      x.catId == state.filter.category.uId))
                              .toList());
                        } else {
                          subCategories = [Category(name: SELECT_VALUE)];
                        }

                        if ((state is ProductLoaded && state.filter != null)) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<Category>(
                              value: state.filter.subCategory,
                              items: subCategories.map((Category category) {
                                return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (Category item) {
                                context.read<ProductBloc>().add(
                                    SubCategoryFilterUpdated(
                                        subCategory: item));
                              },
                            ),
                          );
                        } else {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<Category>(
                              value:const Category(name: SELECT_VALUE),
                              items: [const Category(name: SELECT_VALUE)]
                                  .map((Category category) {
                                return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (var item) {},
                            ),
                          );
                        }
                      },
                    )),

                //Created Date
                const  Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    " Created Date",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration:const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      return TextField(
                          controller: state
                              .filter
                              .createdDateController,
                          onTap: () {
                            _selectDate(context);
                          },
                          readOnly: true,
                          decoration:const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 10, top: 10),
                              border: InputBorder.none,
                              hintText: 'Select'));
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Done",
                          style: TextStyle(
                              color: appWhite,
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<ProductBloc>().add(UpdateFilters());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 1,
                            horizontal: SizeConfig.blockSizeHorizontal * 10),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    var currentDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(currentDate.year - 200),
        lastDate: currentDate);
    if (picked != null /*&& picked != selectedDate*/) {
      var selectedDate = DateFormat('dd-MM-yyyy').format(picked);

      context
          .read<ProductBloc>()
          .add(CreatedDateFilterUpdated(createdDate: "${selectedDate}"));
    }
  }
}
