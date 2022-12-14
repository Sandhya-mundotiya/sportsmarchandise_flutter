part of 'product_detail_bloc.dart';

class ProductDetailState extends Equatable {
  final int carouselCurentIndex;
  final Product product;
  final bool isLoading;
  final bool isExistProduct;

  ProductDetailState({this.carouselCurentIndex = 0,this.product,this.isLoading = true,this.isExistProduct = true});

  factory ProductDetailState.initial() {
    return ProductDetailState(
      product: Product()
    );
  }

  ProductDetailState copyWith({
    int carouselCurentIndex,
    Product product,
    bool isLoading,
    bool isExistProduct
  }) {

    return ProductDetailState(
      carouselCurentIndex: carouselCurentIndex,
      product: product,
      isLoading: isLoading,
      isExistProduct: isExistProduct
    );
  }

  ProductDetailState update({
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

