import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:merch/models/product_model.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {

   Product _product = Product();

  ProductDetailBloc({Product product}) : _product = product, super(ProductDetailState.initial()){
    add(LoadProductDetail());
  }

  @override
  Stream<ProductDetailState> mapEventToState(
      ProductDetailEvent event,
      ) async* {

    if(event is LoadProductDetail) yield state.update(product: _product,isLoading: false);
    if(event is UpdateCarouselIndex) yield state.update(carouselCurentIndex: event.carouselCurentIndex);

  }

}
