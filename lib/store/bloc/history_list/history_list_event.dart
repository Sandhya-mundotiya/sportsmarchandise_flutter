part of 'history_list_bloc.dart';

abstract class HistoryListEvent extends Equatable {
  const HistoryListEvent();
}

class LoadHistoryProducts extends HistoryListEvent {
  @override
  List<Object> get props => [];
}

class UpdateHistoryProducts extends HistoryListEvent {
  final List<ProductHistoryModel> products;

  UpdateHistoryProducts(this.products);

  @override
  List<Object> get props => [products];
}
