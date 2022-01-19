part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
   ProductState();

  List<Product> products;
  Filters filter;
   List<Category> categories;

  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {

  ProductLoaded({List<Product> products,Filters filter,List<Category> categories}){
    super.products = products;
    super.filter = filter;
    super.categories = categories;
  }

  @override
  List<Object> get props => [products,filter];
}





