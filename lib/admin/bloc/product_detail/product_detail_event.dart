part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();
}

class LoadProductDetail extends ProductDetailEvent{

  @override
  // TODO: implement props
  List<Object> get props => [];

}

class UpdateCarouselIndex extends ProductDetailEvent{
  final int carouselCurentIndex;

  UpdateCarouselIndex({this.carouselCurentIndex});

  @override
  // TODO: implement props
  List<Object> get props => [carouselCurentIndex];

}