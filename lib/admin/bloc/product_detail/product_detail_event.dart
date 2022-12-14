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
  final isExistProduct;

  ShowProductDetail({this.product,this.isExistProduct});

  @override
  // TODO: implement props
  List<Object> get props => [product,isExistProduct];

}

class UpdateCarouselIndex extends ProductDetailEvent{
  final int carouselCurentIndex;

  UpdateCarouselIndex({this.carouselCurentIndex});

  @override
  // TODO: implement props
  List<Object> get props => [carouselCurentIndex];

}