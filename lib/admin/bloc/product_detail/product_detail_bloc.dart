import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {

  String _productId = "";
  final ProductRepository _productRepository;
  StreamSubscription _productSubscription;

  ProductDetailBloc({String productId,ProductRepository productRepository}) : _productId = productId,_productRepository = productRepository,
        super(ProductDetailState.initial()){
    add(LoadProductDetail());
  }


  @override
  Stream<ProductDetailState> mapEventToState(
      ProductDetailEvent event,
      ) async* {

    if(event is LoadProductDetail){
      yield* _mapLoadProductsToState(state);
    }

    if(event is ShowProductDetail){
      yield state.update(product: event.product,isLoading: false);
    }

    if(event is UpdateCarouselIndex) yield state.update(carouselCurentIndex: event.carouselCurentIndex);

  }

   Stream<ProductDetailState> _mapLoadProductsToState(ProductDetailState state) async* {
     _productSubscription?.cancel();

     _productSubscription = _productRepository.getProductByProductId(productId: _productId).listen(
           (product) => add(
         ShowProductDetail(product: product),
       ),
     );
   }

   @override
   Future<void> close() {
     _productSubscription.cancel();
     return super.close();
   }


}
