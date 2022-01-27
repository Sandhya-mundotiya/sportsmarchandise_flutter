part of 'product_detail_user_bloc.dart';

abstract class ProductDetailUserEvent extends Equatable {
  const ProductDetailUserEvent();
}

class LoadProductDetail extends ProductDetailUserEvent{

  @override
  // TODO: implement props
  List<Object> get props => [];

}

class UpdateCarouselIndex extends ProductDetailUserEvent{
  final int carouselCurentIndex;

  UpdateCarouselIndex({this.carouselCurentIndex});

  @override
  // TODO: implement props
  List<Object> get props => [carouselCurentIndex];

}
