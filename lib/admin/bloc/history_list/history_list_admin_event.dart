part of 'history_list_admin_bloc.dart';

abstract class HistoryListAdminEvent extends Equatable {
  const HistoryListAdminEvent();
}

class LoadHistoryProducts extends HistoryListAdminEvent {
  @override
  List<Object> get props => [];
}

class UpdateHistoryProducts extends HistoryListAdminEvent {
  final List<ProductHistoryModel> products;

  UpdateHistoryProducts(this.products);

  @override
  List<Object> get props => [products];
}

class CategoryFilterUpdatedHistory extends HistoryListAdminEvent {
  final Category category;

  CategoryFilterUpdatedHistory({this.category});

  @override
  List<Object> get props => [category];
}

class SubCategoryFilterUpdatedHistory extends HistoryListAdminEvent {
  final Category subCategory;

  SubCategoryFilterUpdatedHistory({this.subCategory});

  @override
  List<Object> get props => [subCategory];
}

class DateFilterUpdatedHistory extends HistoryListAdminEvent {
  final String date;

  DateFilterUpdatedHistory({this.date});

  @override
  List<Object> get props => [date];
}

class UpdateFiltersHistory extends HistoryListAdminEvent {

  @override
  List<Object> get props => [];
}

class ClearFiltersHistory extends HistoryListAdminEvent {

  @override
  List<Object> get props => [];
}
