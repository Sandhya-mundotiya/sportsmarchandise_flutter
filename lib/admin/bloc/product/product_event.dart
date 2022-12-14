part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  @override
  List<Object> get props => [];
}

class UpdateProducts extends ProductEvent {
  final List<Product> products;

  UpdateProducts(this.products);

  @override
  List<Object> get props => [products];
}

class CategoryFilterUpdated extends ProductEvent {
  final Category category;

  CategoryFilterUpdated({this.category});

  @override
  List<Object> get props => [category];
}

class SubCategoryFilterUpdated extends ProductEvent {
  final Category subCategory;

  SubCategoryFilterUpdated({this.subCategory});

  @override
  List<Object> get props => [subCategory];
}

class CreatedDateFilterUpdated extends ProductEvent {
  final String createdDate;

  CreatedDateFilterUpdated({this.createdDate});

  @override
  List<Object> get props => [createdDate];
}

class UpdateFilters extends ProductEvent {

  @override
  List<Object> get props => [];
}

class ClearFilters extends ProductEvent {

  @override
  List<Object> get props => [];
}


