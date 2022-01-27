part of 'product_detail_user_bloc.dart';

class ProductDetailUserState extends Equatable {
  final int carouselCurentIndex;
  final Product product;
  final bool isLoading;

  ProductDetailUserState({this.carouselCurentIndex = 0,this.product,this.isLoading = true});

  factory ProductDetailUserState.initial() {
    return ProductDetailUserState(
        product: Product()
    );
  }

  ProductDetailUserState copyWith({
    int carouselCurentIndex,
    Product product,
    bool isLoading
  }) {

    return ProductDetailUserState(
      carouselCurentIndex: carouselCurentIndex,
      product: product,
      isLoading: isLoading,
    );
  }

  ProductDetailUserState update({
    int carouselCurentIndex,
    Product product,
    bool isLoading
  }) {
    return copyWith(
      carouselCurentIndex: carouselCurentIndex ?? this.carouselCurentIndex,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
    );
  }


  @override
  List<Object> get props => [carouselCurentIndex,product,isLoading];
}
