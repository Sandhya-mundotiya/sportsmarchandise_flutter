part of 'product_detail_user_bloc.dart';

abstract class ProductDetailUserEvent extends Equatable {
  const ProductDetailUserEvent();
}

class LoadProductDetail extends ProductDetailUserEvent{
  @override
  List<Object> get props => [];

}

class ShowProductDetail extends ProductDetailUserEvent{
  final Product product;
  final isExistProduct;

  const ShowProductDetail({this.product,this.isExistProduct});

  @override
  List<Object> get props => [product,isExistProduct];

}

class UpdateCarouselIndex extends ProductDetailUserEvent{
  final int carouselCurentIndex;

  const UpdateCarouselIndex({this.carouselCurentIndex});

  @override
  List<Object> get props => [carouselCurentIndex];

}

class BuyProduct extends ProductDetailUserEvent{
  final BuildContext context;

  BuyProduct(this.context);
  @override
  List<Object> get props => [];

}

class StartLoading extends ProductDetailUserEvent{
  @override
  List<Object> get props => [];

}

class StopLoading extends ProductDetailUserEvent{
  @override
  List<Object> get props => [];

}