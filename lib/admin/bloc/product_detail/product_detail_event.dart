part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();
}

class LoadProductDetail extends ProductDetailEvent{

  @override
  // TODO: implement props
  List<Object> get props => [];

}

class ShowProductDetail extends ProductDetailEvent{
  final Product product;

  ShowProductDetail({this.product});

  @override
  // TODO: implement props
  List<Object> get props => [product];

}

class UpdateCarouselIndex extends ProductDetailEvent{
  final int carouselCurentIndex;

  UpdateCarouselIndex({this.carouselCurentIndex});

  @override
  // TODO: implement props
  List<Object> get props => [carouselCurentIndex];

}