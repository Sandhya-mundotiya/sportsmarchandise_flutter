import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';

part 'history_list_event.dart';
part 'history_list_state.dart';

class HistoryListBloc extends Bloc<HistoryListEvent, HistoryListState> {
  final ProductRepository _productRepository;
  StreamSubscription _productSubscription;


  HistoryListBloc({ProductRepository productRepository}): _productRepository = productRepository,
        super(HistoryListState.initial()){
    add(LoadHistoryProducts());
  }

  @override
  Stream<HistoryListState> mapEventToState(
      HistoryListEvent event,
      ) async* {
    if (event is LoadHistoryProducts) yield* _mapLoadProductsToState(state);
    if (event is UpdateHistoryProducts) yield state.update(products: event.products,isLoading: false);

  }

  Stream<HistoryListState> _mapLoadProductsToState(HistoryListState state) async* {
    _productSubscription?.cancel();

    _productSubscription = _productRepository.getAllProductsUser().listen(
          (products) => add(
        UpdateHistoryProducts(products),
      ),
    );
  }


  @override
  Future<void> close() {
    _productSubscription.cancel();
    return super.close();
  }
}
