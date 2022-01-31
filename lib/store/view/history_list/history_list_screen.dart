import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/repositories/product/product_repository.dart';
import 'package:merch/store/bloc/history_list/history_list_bloc.dart';
import 'package:merch/store/bloc/product_detail/product_detail_user_bloc.dart';
import 'package:merch/store/view/product_detail_user/product_detail_user_screen.dart';
import 'package:shimmer/shimmer.dart';

class HistoryListScreen extends StatelessWidget {
  const HistoryListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History',),
        ),
        body: Container(
          decoration: BoxDecoration(

              backgroundBlendMode: BlendMode.colorBurn,
              gradient:
              LinearGradient(colors: primaryGradientColors)),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<HistoryListBloc, HistoryListState>(
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
                        child: ListView.builder(
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

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.images != null && product.images.length > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockSizeHorizontal * 1.8,
                        horizontal: SizeConfig.blockSizeHorizontal * 1.8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: SizeConfig.blockSizeHorizontal*30,

                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: backgroundLightColor.withOpacity(0.2), width: 1.0),
                        ),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                                imageUrl: product.images[0],
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Container(
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
                                            SizeConfig.blockSizeHorizontal*30,
                                            height:
                                            SizeConfig.blockSizeHorizontal*30,
                                            color: Colors.white,
                                          ),
                                        ]),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 50,
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 5,
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
                                  maxLines: 3,
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

}
