import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:merch/models/product_history_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/history/history_repository.dart';
import 'package:merch/repositories/product/product_repository.dart';

part 'history_list_event.dart';
part 'history_list_state.dart';

class HistoryListBloc extends Bloc<HistoryListEvent, HistoryListState> {
  final HistoryRepository _historyRepository;
  StreamSubscription _historySubscription;


  HistoryListBloc({HistoryRepository historyRepository}): _historyRepository = historyRepository,
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
    _historySubscription?.cancel();

    _historySubscription = _historyRepository.getAllHistoryProductsUser().listen(
          (products) => add(
        UpdateHistoryProducts(products),
      ),
    );
  }


  @override
  Future<void> close() {
    _historySubscription.cancel();
    return super.close();
  }
}
