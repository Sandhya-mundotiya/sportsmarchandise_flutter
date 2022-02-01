part of 'history_list_bloc.dart';

class HistoryListState extends Equatable {
  final List<ProductHistoryModel> products;
  final bool isLoading;

  HistoryListState({this.products,this.isLoading = true});


  factory HistoryListState.initial() {
    return HistoryListState(
        products: [],
    );
  }

  HistoryListState update({
    List<ProductHistoryModel> products,
    bool isLoading,
  }) {

    return copyWith(
      products: products,
      isLoading: isLoading,
    );
  }


  HistoryListState copyWith({
    List<ProductHistoryModel> products,
    bool isLoading,
  }) {

    return HistoryListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [products,isLoading];
}
