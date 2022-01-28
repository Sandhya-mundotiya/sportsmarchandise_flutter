import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/repositories/product/product_repository.dart';
import 'package:merch/store/bloc/product_detail/product_detail_user_bloc.dart';
import 'package:merch/store/bloc/product_list/product_user_bloc.dart';
import 'package:merch/store/view/product_detail_user/product_detail_user_screen.dart';
import 'package:shimmer/shimmer.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<ProductUserBloc>().add(ClearFilters());
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home',),
          actions: [
            InkWell(
              onTap: () {
                return filterBottomSheet(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: const EdgeInsets.only(right: 5,left: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: primaryGradientColors
                  )
                ),
                child: Icon(
                  Icons.filter_alt,
                  color: Colors.black,
                  size: SizeConfig.blockSizeHorizontal * 6.5,
                ),
              ),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(

              backgroundBlendMode: BlendMode.colorBurn,
              gradient:
              LinearGradient(colors: primaryGradientColors)),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ProductUserBloc, ProductUserState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
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
                    create: (context) =>
                        ProductDetailUserBloc(productId: product.uid,productRepository: ProductRepository()),
                    child: ProductDetailUserScreen())));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal * 1.8,
            horizontal: SizeConfig.blockSizeHorizontal * 1.8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 50,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: borderColor, width: 1.0),
            ),

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 50,
                                        height:
                                            SizeConfig.blockSizeVertical * 20,
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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      fontWeight: FontWeight.w500,
                                      color: appBlack)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeHorizontal * 2),
                        child: Text("₹" + product.price,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(25.0),
              //   topRight: Radius.circular(25.0),
              // ),
            ),
            child: Column(
              children: [
                // AppBar(
                //   centerTitle: true,
                //   backgroundColor: primaryColor,
                //   title: Text("Filter by",
                //       style: const TextStyle(color: appWhite)),
                //   automaticallyImplyLeading: false,
                //   actions: [
                //     InkWell(
                //       onTap: () {
                //         Navigator.pop(context);
                //         context.read<ProductUserBloc>().add(ClearFilters());
                //       },
                //       child: const Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Icon(Icons.close, color: appWhite, size: 25),
                //       ),
                //     ),
                //   ],
                // ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: primaryGradientColors
                    )
                  ),
                  height: SizeConfig.blockSizeVertical*8,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("Filter by",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: appBlack,fontSize: 18,fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          context.read<ProductUserBloc>().add(ClearFilters());
                        },
                        child: Icon(Icons.close, color: appBlack, size: 25),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Catagory
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: Text(
                            "Category",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 2,
                                vertical: SizeConfig.blockSizeVertical * 0.5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                                color: iconBGGrey),
                            child:
                                BlocBuilder<ProductUserBloc, ProductUserState>(
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
                                      items:
                                          categories.map((Category category) {
                                        return DropdownMenuItem<Category>(
                                          value: category,
                                          child: Text(category.name),
                                        );
                                      }).toList(),
                                      onChanged: (Category item) {
                                        context.read<ProductUserBloc>().add(
                                            CategoryFilterUpdated(
                                                category: item));
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
                        const Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Text(
                            "Sub Catagory",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 2,
                                vertical: SizeConfig.blockSizeVertical * 0.5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                                color: iconBGGrey),
                            child:
                                BlocBuilder<ProductUserBloc, ProductUserState>(
                              builder: (context, state) {
                                List<Category> subCategories = [];

                                if (state.categories != null) {
                                  subCategories
                                      .add(Category(name: SELECT_VALUE));
                                  subCategories.addAll(state.categories
                                      .where((x) =>
                                          (state.category.catId != null &&
                                              x.catId == state.category.uId))
                                      .toList());
                                } else {
                                  subCategories = [
                                    Category(name: SELECT_VALUE)
                                  ];
                                }

                                if ((!state.isLoading)) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<Category>(
                                      value: state.subCategory,
                                      items: subCategories
                                          .map((Category category) {
                                        return DropdownMenuItem<Category>(
                                          value: category,
                                          child: Text(category.name),
                                        );
                                      }).toList(),
                                      onChanged: (Category item) {
                                        context.read<ProductUserBloc>().add(
                                            SubCategoryFilterUpdated(
                                                subCategory: item));
                                      },
                                    ),
                                  );
                                } else {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<Category>(
                                      value: const Category(name: SELECT_VALUE),
                                      items: [
                                        const Category(name: SELECT_VALUE)
                                      ].map((Category category) {
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

                        //Price
                        const Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Text(
                            "Price",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),

                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 2,
                              vertical: SizeConfig.blockSizeVertical * 0.5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black38, width: 1),
                              color: iconBGGrey),
                          child: BlocBuilder<ProductUserBloc, ProductUserState>(
                            builder: (_, state) {
                              return TextField(
                                  controller: state.priceController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onSubmitted: (value) {
                                    context
                                        .read<ProductUserBloc>()
                                        .add(PriceFilterUpdated(price: value));
                                  },
                                  // readOnly: true,
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(bottom: 10, top: 10),
                                      border: InputBorder.none,
                                      hintText: 'Price'));
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
                                    // color: primaryColor,
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: primaryGradientColors,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                ),

                                padding: EdgeInsets.symmetric(vertical: 6,horizontal: 5),
                                child: MaterialButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    context
                                        .read<ProductUserBloc>()
                                        .add(UpdateFilters());
                                  },
                                  child: Text("Done",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
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
      ),
    );
  }

}
