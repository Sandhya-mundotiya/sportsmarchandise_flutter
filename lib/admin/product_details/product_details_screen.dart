import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/product_details/product_detail_cubid.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/models/product_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsScreen extends StatelessWidget {
  ProductDetailsScreen({Key key, this.product}) : super(key: key);
  Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Product"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal * 5,
            horizontal: SizeConfig.blockSizeHorizontal * 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  // aspectRatio: 16 / 9,
                  // viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlayInterval:const Duration(seconds: 3),
                    autoPlayCurve: Curves.fastOutSlowIn,
                     enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      //_current = index;
                      context
                          .read<ProductDetailCubit>()
                          .setCarouselCurentIndex(
                          carouselCurentIndex: index);
                    }),
                items: product.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CachedNetworkImage(
                                imageUrl: image,
                                fit: BoxFit.fill,
                                height: SizeConfig.blockSizeVertical * 20,
                                width: SizeConfig.blockSizeHorizontal * 70,
                                placeholder: (context, url) => Container(
                                  // padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*25,left: SizeConfig.blockSizeHorizontal*4,right: SizeConfig.blockSizeVertical*4),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: SizeConfig
                                                .blockSizeHorizontal *
                                                70,
                                            height: SizeConfig
                                                .blockSizeVertical *
                                                20,
                                            color: Colors.white,
                                          ),
                                        ]),
                                  ),
                                )),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: product.images.map((image) {
                  int index = product.images.indexOf(image);
                  return BlocBuilder<ProductDetailCubit,
                      int>(
                      builder: (context, value) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: value ==
                                index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        );
                      });
                }).toList(),
              ),
              Padding(
                padding:
                EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 4),
                child: Text(product.name,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.w500,
                        color: appBlack)),
              ),
              Padding(
                padding:
                EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 4),
                child: Text("\$" + product.price,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
              ),
              Padding(
                padding:
                EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 2),
                child: Text(product.description,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                        fontWeight: FontWeight.normal,
                        color: appBlack)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailTile({String title, String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 4,
          vertical: SizeConfig.blockSizeVertical * 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  fontWeight: FontWeight.normal,
                  color: appBlack)),
          Text(value,
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey)),
        ],
      ),
    );
  }
}
