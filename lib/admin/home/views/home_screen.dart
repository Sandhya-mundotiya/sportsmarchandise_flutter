import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:merch/admin/add_item/add_product.dart';
import 'package:merch/admin/add_item/add_product_controller.dart';
import 'package:merch/admin/home/cubid/product_detail_cubid.dart';
import 'package:merch/admin/home/views/product_details_screen.dart';
import 'package:merch/bloc/product/product_bloc.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/main.dart';
import 'package:merch/models/product_model.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {

  HomeScreen({Key key,this.schoolId}) : super(key: key);
  String schoolId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed:(){
        getIt.registerSingleton<AddProductModel>(AddProductController());
        Navigator.push(context,MaterialPageRoute(builder: (context) => AddProductScreen(schoolId: schoolId)));
      },child: const Icon(Icons.add,color: Colors.white)),
      appBar: AppBar(
        title: const Text('Home'),
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
                  return state.products.isNotEmpty? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockSizeHorizontal*1.8,
                        horizontal: SizeConfig.blockSizeHorizontal*1.8),
                    child: AlignedGridView.count(
                      crossAxisCount: 2,
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return productListItem(context,state.products[index]);
                      },
                    ),
                  ):const Center(child: Text('No Product Found',style: TextStyle(color: Colors.black),));
                } else {
                  return const Text('Something went wrong.');
                }
              },
            ),
          )
        ],
      ),
    );
  }


  Widget productListItem(context, Product product){
    return InkWell(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => BlocProvider(
            create: (_) => ProductDetailCubit(),
            child: ProductDetailsScreen(product: product,))));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal*1.8,
            horizontal: SizeConfig.blockSizeHorizontal*1.8),
        child: Container(
          width: SizeConfig.blockSizeHorizontal*50,

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


              if(product.images != null && product.images.length > 0) Center(
                child: CachedNetworkImage(
                    imageUrl: product.images[0],
                    fit: BoxFit.fill,
                    height: SizeConfig.blockSizeVertical*20,
                    width : SizeConfig.blockSizeHorizontal*50,
                    placeholder:
                        (context, url) =>
                        Container(
                          // padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*25,left: SizeConfig.blockSizeHorizontal*4,right: SizeConfig.blockSizeVertical*4),
                          child: Shimmer
                              .fromColors(
                            baseColor: Colors
                                .grey[300],
                            highlightColor:
                            Colors
                                .grey[100],
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Container(
                                    width: SizeConfig.blockSizeHorizontal*50,
                                    height:
                                    SizeConfig.blockSizeVertical*20,
                                    color: Colors
                                        .white,
                                  ),
                                ]),
                          ),
                        )
                ),
              ),

              Container(
                color: iconBGGrey,
                width: SizeConfig.blockSizeHorizontal*50,
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal*3,
                    right: SizeConfig.blockSizeHorizontal*3,
                    bottom: SizeConfig.blockSizeHorizontal*5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 4),
                      child: Text(product.name,style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4,fontWeight: FontWeight.w500,color: appBlack)),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top:  SizeConfig.blockSizeHorizontal * 2),
                      child: Text("₹" + product.price,style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3.5,fontWeight: FontWeight.bold,color: Colors.grey)),
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
}
