part of 'product_detail_user_bloc.dart';

abstract class ProductDetailUserEvent extends Equatable {
  const ProductDetailUserEvent();
}

class LoadProductDetail extends ProductDetailUserEvent{

  @override
  // TODO: implement props
  List<Object> get props => [];

}

class ShowProductDetail extends ProductDetailUserEvent{
  final Product product;

  ShowProductDetail({this.product});

  @override
  // TODO: implement props
  List<Object> get props => [product];

}

class UpdateCarouselIndex extends ProductDetailUserEvent{
  final int carouselCurentIndex;

  UpdateCarouselIndex({this.carouselCurentIndex});

  @override
  // TODO: implement props
  List<Object> get props => [carouselCurentIndex];

}

class BuyProduct extends ProductDetailUserEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

}