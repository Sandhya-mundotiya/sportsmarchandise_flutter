import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merch/store/bloc/product_detail/product_detail_user_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("View Product"),
        ),
        body: BlocBuilder<ProductDetailUserBloc, ProductDetailUserState>(
          builder: (context, state) {
            return state.isLoading
                ? loader()
                : SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeHorizontal * 2,
                          horizontal: SizeConfig.blockSizeHorizontal * 2),
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeHorizontal * 5,
                          horizontal: SizeConfig.blockSizeHorizontal * 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: borderColor, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          backgroundBlendMode: BlendMode.colorBurn,
                          gradient:
                              LinearGradient(colors: primaryGradientColors)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<ProductDetailUserBloc,
                              ProductDetailUserState>(
                            builder: (context, state) {
                              return CarouselSlider(
                                options: CarouselOptions(
                                    // aspectRatio: 16 / 9,
                                    // viewportFraction: 0.8,
                                    height: SizeConfig.blockSizeVertical * 36,
                                    initialPage: 0,
                                    enableInfiniteScroll: false,
                                    reverse: false,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                      //_current = index;
                                      context.read<ProductDetailUserBloc>().add(
                                          UpdateCarouselIndex(
                                              carouselCurentIndex: index));
                                    }),
                                items: state.product.images.map((image) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: CachedNetworkImage(
                                                imageUrl: image,
                                                fit: BoxFit.fill,
                                                height: SizeConfig
                                                        .blockSizeVertical *
                                                    30,
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    70,
                                                placeholder: (context, url) =>
                                                    Container(
                                                      child: Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300],
                                                        highlightColor:
                                                            Colors.grey[100],
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    70,
                                                                height: SizeConfig
                                                                        .blockSizeVertical *
                                                                    30,
                                                                color: Colors
                                                                    .white,
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
                              );
                            },
                          ),
                          BlocBuilder<ProductDetailUserBloc,
                              ProductDetailUserState>(
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: state.product.images.map((image) {
                                  int index =
                                      state.product.images.indexOf(image);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: state.carouselCurentIndex == index
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal * 4),
                            child: BlocBuilder<ProductDetailUserBloc,
                                ProductDetailUserState>(
                              builder: (context, state) {
                                return Text(state.product.name,
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 4,
                                        fontWeight: FontWeight.w500,
                                        color: appBlack));
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal * 4),
                            child: BlocBuilder<ProductDetailUserBloc,
                                ProductDetailUserState>(
                              builder: (context, state) {
                                return Text("\$" + state.product.price,
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 4,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey));
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal * 2),
                            child: BlocBuilder<ProductDetailUserBloc,
                                ProductDetailUserState>(
                              builder: (context, state) {
                                return Text(state.product.description,
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal *
                                                3.5,
                                        fontWeight: FontWeight.normal,
                                        color: appBlack));
                              },
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 5,
                          ),
                          BlocBuilder<ProductDetailUserBloc,
                              ProductDetailUserState>(
                            builder: (context, state) {
                              return state.product.isEnabled
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            //  color: primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: primaryGradientColors,
                                            )),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 5),
                                        child: MaterialButton(
                                          onPressed: () {
                                            context.read<ProductDetailUserBloc>().add(BuyProduct());
                                          },
                                          child: Text(
                                            "Buy Now",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox();
                            },
                          )
                        ],
                      ),
                    ),
                  );
          },
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
