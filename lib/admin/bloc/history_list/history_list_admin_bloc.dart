import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:merch/admin/bloc/category/category_bloc.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_history_model.dart';
import 'package:merch/repositories/history/history_repository.dart';

part 'history_list_admin_event.dart';
part 'history_list_admin_state.dart';

class HistoryListAdminBloc extends Bloc<HistoryListAdminEvent, HistoryListAdminState> {
  final HistoryRepository _historyRepository;
  StreamSubscription _historySubscription;
  final CategoryBloc categoryBloc;



  HistoryListAdminBloc({HistoryRepository historyRepository,@required this.categoryBloc}): _historyRepository = historyRepository,
        super(HistoryListAdminState.initial()){
    add(LoadHistoryProducts());
  }

  @override
  Stream<HistoryListAdminState> mapEventToState(
      HistoryListAdminEvent event,
      ) async* {
    if (event is LoadHistoryProducts) yield* _mapLoadProductsToState(state);
    if (event is UpdateHistoryProducts) yield state.update(categories: categoryBloc.state.categories,products: event.products,isLoading: false);
    if (event is CategoryFilterUpdatedHistory) yield state.update(category: event.category,subCategory: Category(name: SELECT_VALUE));
    if (event is SubCategoryFilterUpdatedHistory) yield state.update(subCategory: event.subCategory);
    if (event is DateFilterUpdatedHistory) yield state.update(date: event.date);

    if (event is UpdateFiltersHistory) {
      yield state.update(isLoading: true);
      add(LoadHistoryProducts());
    }

    if (event is ClearFiltersHistory) {
      yield state.update(category: Category(name: SELECT_VALUE),subCategory: Category(name: SELECT_VALUE),date: "");
      add(LoadHistoryProducts());
    }
  }

  Stream<HistoryListAdminState> _mapLoadProductsToState(HistoryListAdminState state) async* {

    String catId = "";
    int createdDate = 0;


    if (state.subCategory != null &&
        state.subCategory.catId != null &&
        state.subCategory.catId != "") {
      catId = state.subCategory.uId;
    } else if (state.category != null &&
        state.category.uId != null &&
        state.category.uId != "") {
      catId = state.category.uId;
    }

    if (state.date != null && state.date != "") {
      var localDate = DateFormat("dd-MM-yyyy").parse(state.date);
      createdDate = localDate.microsecondsSinceEpoch;
    }


      _historySubscription =
          _historyRepository.getAllHistoryProducts(date: createdDate, catId: catId).listen(
                (products) =>
                add(
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
