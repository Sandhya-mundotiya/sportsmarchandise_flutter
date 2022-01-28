import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';


part 'product_detail_user_event.dart';
part 'product_detail_user_state.dart';

class ProductDetailUserBloc extends Bloc<ProductDetailUserEvent, ProductDetailUserState> {
  String _productId = "";
  final ProductRepository _productRepository;
  StreamSubscription _productSubscription;


  ProductDetailUserBloc({String productId,ProductRepository productRepository}) : _productId = productId,_productRepository = productRepository,
        super(ProductDetailUserState.initial()){
    add(LoadProductDetail());
  }

  @override
  Stream<ProductDetailUserState> mapEventToState(
      ProductDetailUserEvent event,
      ) async* {

    if(event is LoadProductDetail){
      yield* _mapLoadProductsToState(state);
    }

    if(event is ShowProductDetail){
      yield state.update(product: event.product,isLoading: false);
    }

    if(event is UpdateCarouselIndex) yield state.update(carouselCurentIndex: event.carouselCurentIndex);
    if(event is BuyProduct) yield* makePayment(state);

  }

  Stream<ProductDetailUserState> _mapLoadProductsToState(ProductDetailUserState state) async* {
    _productSubscription?.cancel();

    _productSubscription = _productRepository.getProductByProductId(productId: _productId).listen(
          (product) => add(
        ShowProductDetail(product: product),
      ),
    );
  }


  Stream<ProductDetailUserState> makePayment(ProductDetailUserState state) async* {
    _productRepository.buyProduct(uid: state.product.uid,amount: state.product.price);
  }


  @override
  Future<void> close() {
    _productSubscription.cancel();
    return super.close();
  }







}
