part of 'product_user_bloc.dart';

abstract class ProductUserEvent extends Equatable {
  const ProductUserEvent();
}

class LoadProducts extends ProductUserEvent {
  @override
  List<Object> get props => [];
}

class UpdateProducts extends ProductUserEvent {
  final List<Product> products;

  UpdateProducts(this.products);

  @override
  List<Object> get props => [products];
}

class CategoryFilterUpdated extends ProductUserEvent {
  final Category category;

  CategoryFilterUpdated({this.category});

  @override
  List<Object> get props => [category];
}

class SubCategoryFilterUpdated extends ProductUserEvent {
  final Category subCategory;

  SubCategoryFilterUpdated({this.subCategory});

  @override
  List<Object> get props => [subCategory];
}

class PriceFilterUpdated extends ProductUserEvent {
  final String price;

  PriceFilterUpdated({this.price});

  @override
  List<Object> get props => [price];
}

class PurchaseDateFilterUpdated extends ProductUserEvent {
  final String purchaseDate;

  PurchaseDateFilterUpdated({this.purchaseDate});

  @override
  List<Object> get props => [purchaseDate];
}

class UpdateFilters extends ProductUserEvent {

  @override
  List<Object> get props => [];
}

class ClearFilters extends ProductUserEvent {

  @override
  List<Object> get props => [];
}


