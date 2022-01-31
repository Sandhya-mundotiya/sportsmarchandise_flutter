import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/store/bloc/zoom_product_detail/zoom_product_detail_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class ZoomProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZoomProductDetailBloc, ZoomProductDetailState>(
      builder: (context, state) {
        return state.isLoading ? CircularProgressIndicator() : Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [


              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: SizeConfig.blockSizeHorizontal*10,
                        width: SizeConfig.blockSizeHorizontal*10,
                        decoration: BoxDecoration(
                          color: borderColor,
                          shape: BoxShape.circle
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.close,
                            size: SizeConfig.blockSizeHorizontal*5,
                            color: appBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Flexible(
                fit: FlexFit.loose,
                flex: 6,
                child: Container(
                    child: PhotoViewGallery.builder(
                      backgroundDecoration: BoxDecoration(color: Colors.white),
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: CachedNetworkImageProvider(
                            state.images[state.carouselCurentIndex],
                          ),
                          initialScale: PhotoViewComputedScale.contained * 0.5,
                          minScale: PhotoViewComputedScale.contained * 1,
                          maxScale: PhotoViewComputedScale.covered * 3,
                          //heroAttributes: PhotoViewHeroAttributes(tag: productImages[index]),
                        );
                      },
                      itemCount: state.images.length,
                      loadingBuilder: (context, event) =>
                          Center(
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                              ),
                            ),
                          ),
                      // backgroundDecoration: widget.backgroundDecoration,
                      // pageController: widget.pageController,
                      onPageChanged: (page){
                        context.read<ZoomProductDetailBloc>().add(
                            UpdatePageIndex(
                                carouselCurentIndex: page));
                      },
                    )
                ),
              ),
              if (state.images != null && state.images.length > 0)
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 5),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(state.images.length, (index) {
                        String image = state.images[index];
                        return GestureDetector(
                          onTap: (){
                            context.read<ZoomProductDetailBloc>().add(
                                UpdatePageIndex(
                                    carouselCurentIndex: index));
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.black,
                                  margin: const EdgeInsets.all(15),
                                  padding: const EdgeInsets.all(3),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: CachedNetworkImage(
                                        imageUrl: image,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            Container(
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey[300],
                                                highlightColor: Colors.grey[100],
                                                child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            )),
                                  ),
                                ),
                              ),

                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: state.carouselCurentIndex == index ? darkWoodColor : Colors.grey.withOpacity(0.2),
                                    shape: BoxShape.circle
                                ),
                              ),

                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              SizedBox(height: 5,)
            ],
          ),
        );
      },
    );
  }
}
