part of 'product_detail_bloc.dart';

class ProductDetailState extends Equatable {
  final int carouselCurentIndex;
  final Product product;
  final bool isLoading;

  ProductDetailState({this.carouselCurentIndex = 0,this.product,this.isLoading = true});

  factory ProductDetailState.initial() {
    return ProductDetailState(
      product: Product()
    );
  }

  ProductDetailState copyWith({
    int carouselCurentIndex,
    Product product,
    bool isLoading
  }) {

    return ProductDetailState(
      carouselCurentIndex: carouselCurentIndex,
      product: product,
      isLoading: isLoading,
    );
  }

  ProductDetailState update({
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

