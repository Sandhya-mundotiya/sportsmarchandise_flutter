part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class UpdateProducts extends ProductEvent {
  final List<Product> products;

  UpdateProducts(this.products);

  @override
  List<Object> get props => [products];
}

class CategoryFilterUpdated extends ProductEvent {
  final String category;

  const CategoryFilterUpdated({this.category = ""});

  @override
  List<Object> get props => [category];
}

class AddCategoryList extends ProductEvent {
  List<Category> category;

  AddCategoryList({this.category});

  @override
  List<Object> get props => [category];
}

// class SubCatagoryFilterUpdated extends ProductEvent {
//   final PriceFilter priceFilter;
//
//   const PriceFilterUpdated({
//     required this.priceFilter,
//   });
//
//   @override
//   List<Object?> get props => [priceFilter];
// }
