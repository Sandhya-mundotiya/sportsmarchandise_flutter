part of 'zoom_product_detail_bloc.dart';

class ZoomProductDetailState extends Equatable {
  final int carouselCurentIndex;
  final bool isLoading;
  final List<String> images;

  ZoomProductDetailState({this.carouselCurentIndex = 0,this.isLoading = true,this.images});

  factory ZoomProductDetailState.initial() {
    return ZoomProductDetailState(
      images: []
    );
  }

  ZoomProductDetailState copyWith({
    int carouselCurentIndex,
    bool isLoading,
    List<String> images
  }) {

    return ZoomProductDetailState(
      carouselCurentIndex: carouselCurentIndex,
      isLoading: isLoading,
      images: images
    );
  }

  ZoomProductDetailState update({
    int carouselCurentIndex,
    bool isLoading,
    List<String> images
  }) {
    return copyWith(
      carouselCurentIndex: carouselCurentIndex ?? this.carouselCurentIndex,
      isLoading: isLoading ?? this.isLoading,
      images: images ?? this.images
    );
  }


  @override
  List<Object> get props => [carouselCurentIndex,isLoading,images];
}

