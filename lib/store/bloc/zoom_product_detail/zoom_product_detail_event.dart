part of 'zoom_product_detail_bloc.dart';

abstract class ZoomProductDetailEvent extends Equatable {
  const ZoomProductDetailEvent();
}

class ShowProductImages extends ZoomProductDetailEvent{
  final List<String> images;

  ShowProductImages({this.images});

  @override
  // TODO: implement props
  List<Object> get props => [images];

}

class UpdatePageIndex extends ZoomProductDetailEvent{
  final int carouselCurentIndex;

  UpdatePageIndex({this.carouselCurentIndex});

  @override
  // TODO: implement props
  List<Object> get props => [carouselCurentIndex];

}
