import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:merch/models/product_model.dart';

part 'product_detail_user_event.dart';
part 'product_detail_user_state.dart';

class ProductDetailUserBloc extends Bloc<ProductDetailUserEvent, ProductDetailUserState> {
  Product _product = Product();

  ProductDetailUserBloc({Product product}) : _product = product, super(ProductDetailUserState.initial()){
    add(LoadProductDetail());
  }

  @override
  Stream<ProductDetailUserState> mapEventToState(
      ProductDetailUserEvent event,
      ) async* {

    if(event is LoadProductDetail) yield state.update(product: _product,isLoading: false);
    if(event is UpdateCarouselIndex) yield state.update(carouselCurentIndex: event.carouselCurentIndex);

  }
}
