part of 'product_detail_user_bloc.dart';

class ProductDetailUserState extends Equatable {
  final int carouselCurentIndex;
  final Product product;
  final bool isLoading;
  final bool isInitialLoader;
  final bool isExistProduct;

  ProductDetailUserState({this.carouselCurentIndex = 0,this.product,this.isLoading = false,this.isExistProduct = true,this.isInitialLoader = true});

  factory ProductDetailUserState.initial() {
    return ProductDetailUserState(
        product: Product()
    );
  }

  ProductDetailUserState copyWith({
    int carouselCurentIndex,
    Product product,
    bool isLoading,
    bool isExistProduct,
    bool isInitialLoader
  }) {

    return ProductDetailUserState(
      carouselCurentIndex: carouselCurentIndex,
      product: product,
      isLoading: isLoading,
      isExistProduct: isExistProduct,
      isInitialLoader: isInitialLoader
    );
  }

  ProductDetailUserState update({
    int carouselCurentIndex,
    Product product,
    bool isLoading,
    bool isExistProduct,
    bool isInitialLoader
  }) {
    return copyWith(
      carouselCurentIndex: carouselCurentIndex ?? this.carouselCurentIndex,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isExistProduct: isExistProduct ?? this.isExistProduct,
      isInitialLoader: isInitialLoader ?? this.isInitialLoader,
    );
  }


  @override
  List<Object> get props => [carouselCurentIndex,product,isLoading,isExistProduct,isInitialLoader];
}
