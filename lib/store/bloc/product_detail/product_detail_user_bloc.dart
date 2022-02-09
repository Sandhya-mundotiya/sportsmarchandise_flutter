import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';


part 'product_detail_user_event.dart';
part 'product_detail_user_state.dart';

class ProductDetailUserBloc extends Bloc<ProductDetailUserEvent, ProductDetailUserState> {
  final String _productId;
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
    if(event is BuyProduct) {
      yield state.update(isLoading: true);
      yield* makePayment(state,event );
    }
    if(event is StartLoading) yield state.update(isLoading: true);
    if(event is StopLoading) yield state.update(isLoading: false);

  }

  Stream<ProductDetailUserState> _mapLoadProductsToState(ProductDetailUserState state) async* {
    _productSubscription?.cancel();

    _productSubscription = _productRepository.getProductByProductId(productId: _productId).listen(
          (product) {
            add(
              ShowProductDetail(product: product)
            );
            _productSubscription.cancel();
          },
    );
  }


  Stream<ProductDetailUserState> makePayment(ProductDetailUserState state,BuyProduct event) async* {
    _productRepository.buyProduct(product: state.product, context: event.context);
  }


  @override
  Future<void> close() {
    _productSubscription.cancel();
    return super.close();
  }







}
