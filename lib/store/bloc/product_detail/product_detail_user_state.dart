part of 'product_detail_user_bloc.dart';

class ProductDetailUserState extends Equatable {
  final int carouselCurentIndex;
  final Product product;
  final bool isLoading;
  final bool isExistProduct;

  ProductDetailUserState({this.carouselCurentIndex = 0,this.product,this.isLoading = true,this.isExistProduct = true});

  factory ProductDetailUserState.initial() {
    return ProductDetailUserState(
        product: Product()
    );
  }

  ProductDetailUserState copyWith({
    int carouselCurentIndex,
    Product product,
    bool isLoading,
    bool isExistProduct
  }) {

    return ProductDetailUserState(
      carouselCurentIndex: carouselCurentIndex,
      product: product,
      isLoading: isLoading,
      isExistProduct: isExistProduct
    );
  }

  ProductDetailUserState update({
    int carouselCurentIndex,
    Product product,
    bool isLoading,
    bool isExistProduct
  }) {
    return copyWith(
      carouselCurentIndex: carouselCurentIndex ?? this.carouselCurentIndex,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isExistProduct: isExistProduct ?? this.isExistProduct,
    );
  }


  @override
  List<Object> get props => [carouselCurentIndex,product,isLoading,isExistProduct];
}
