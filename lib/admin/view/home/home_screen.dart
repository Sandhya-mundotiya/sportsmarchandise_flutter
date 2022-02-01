import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:merch/admin/bloc/history_list/history_list_admin_bloc.dart';
import 'package:merch/admin/bloc/product_detail/product_detail_bloc.dart';
import 'package:merch/admin/view/add_item/add_product.dart';
import 'package:merch/admin/view/edit_product/edit_product_screen.dart';
import 'package:merch/admin/bloc/add_product/add_product_bloc.dart';
import 'package:merch/admin/bloc/category/category_bloc.dart';
import 'package:merch/admin/bloc/edit_product/edit_product_bloc.dart';
import 'package:merch/admin/view/history_list/history_list_admin_screen.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/admin/view/product_detail/product_details_screen.dart';
import 'package:merch/admin/bloc/product/product_bloc.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/history/history_repository.dart';
import 'package:merch/repositories/product/product_repository.dart'
    as product_repo;
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key, this.schoolId}) : super(key: key);
  String schoolId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        context.read<ProductBloc>().add(ClearFilters());
        return;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
            onPressed: () {
              context.read<ProductBloc>().add(ClearFilters());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => AddProductBloc(
                                categoryBloc: context.read<CategoryBloc>(),
                                productRepository:
                                    product_repo.ProductRepository()),
                            child: AddProductScreen(schoolId: schoolId),
                          )));
            },
            child: const Icon(Icons.add, color: Colors.white)),
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            InkWell(
              onTap: () {
                context.read<ProductBloc>().add(ClearFilters());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoryListAdminScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.history_toggle_off,
                  color: Colors.black,
                  size: SizeConfig.blockSizeHorizontal * 7.5,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                return filterBottomSheet(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.filter_alt,
                  color: Colors.black,
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
                  if (state.isLoading) {
                    return loaderAdmin();
                  }

                  if (!state.isLoading) {
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
                    create: (context) => ProductDetailBloc(productRepository: product_repo.ProductRepository(),productId: product.uid),
                    child: ProductDetailsScreen())));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal * 1.8,
            horizontal: SizeConfig.blockSizeHorizontal * 1.8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                  color: Colors.grey,
                  width: 1.0
              ),

            ),
            width: SizeConfig.blockSizeHorizontal * 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                  width: SizeConfig.blockSizeHorizontal * 50,
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 3,
                    right: SizeConfig.blockSizeHorizontal * 3,
                    bottom: SizeConfig.blockSizeHorizontal * 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeHorizontal * 4),
                              child: Text(product.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                                      fontWeight: FontWeight.w500,
                                      color: appBlack)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (context) => EditProductBloc(
                                                categoryBloc: BlocProvider.of<
                                                    CategoryBloc>(context),
                                                productRepository: product_repo
                                                    .ProductRepository(),
                                                selectedProduct:
                                                    product.copyWith()),
                                            child: EditProductScreen(),
                                          )));
                            },
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeHorizontal * 2),
                                child: Icon(
                                  Icons.edit,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeHorizontal * 2),
                        child: Text("₹" + product.price,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  filterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Column(
            children: [
              AppBar(
                centerTitle: true,
                backgroundColor: primaryColor,
                title: Text("Filter by",
                    style: const TextStyle(color: appWhite)),
                automaticallyImplyLeading: false,
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.read<ProductBloc>().add(ClearFilters());
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close, color: appWhite, size: 25),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                     

                      //Category
                      const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Text(
                          "Category",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          height: 40,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          // margin: const EdgeInsets.symmetric(
                          //     horizontal: 20, vertical: 20),
                          margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,vertical: SizeConfig.blockSizeVertical*0.5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.black38,width: 1),
                              color: iconBGGrey
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

                              if ((!state.isLoading)) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<Category>(
                                    value: state.category,
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

                      //Sub Category
                      const Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Text(
                          "Sub Category",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          height: 40,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,vertical: SizeConfig.blockSizeVertical*0.5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.black38,width: 1),
                              color: iconBGGrey
                          ),
                          child: BlocBuilder<ProductBloc, ProductState>(
                            builder: (context, state) {
                              List<Category> subCategories = [];

                              if (state.categories != null) {
                                subCategories.add(Category(name: SELECT_VALUE));
                                subCategories.addAll(state.categories
                                    .where((x) =>
                                        (state.category.catId != null &&
                                            x.catId == state.category.uId))
                                    .toList());
                              } else {
                                subCategories = [Category(name: SELECT_VALUE)];
                              }

                              if ((!state.isLoading)) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<Category>(
                                    value: state.subCategory,
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
                                    value: const Category(name: SELECT_VALUE),
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
                      const Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Text(
                          " Created Date",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),

                      Container(
                        height: 40,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,vertical: SizeConfig.blockSizeVertical*0.5),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.black38,width: 1),
                            color: iconBGGrey
                        ),
                        child: BlocBuilder<ProductBloc, ProductState>(
                          builder: (_, state) {
                            return TextField(
                                controller: state.createdDateController,
                                onTap: () {
                                  _selectDate(context,state.createdDate);
                                },
                                readOnly: true,
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(bottom: 10, top: 10),
                                    border: InputBorder.none,
                                    hintText: 'Select'));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                              ),

                              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 5),
                              child: MaterialButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  context.read<ProductBloc>().add(UpdateFilters());
                                },
                                child: Text("Done",style: TextStyle(color: Colors.white,fontSize: 16),),
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> _selectDate(BuildContext context,String selectedDate) async {
    var currentDate = DateTime.now();
    var initialDate = DateTime.now();
    if(selectedDate != "") initialDate = DateFormat('dd-MM-yyyy').parse(selectedDate);

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
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
