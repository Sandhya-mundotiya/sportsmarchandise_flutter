part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
   List<Category> categories;

  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {


  CategoryLoaded({List<Category> categories}){
    super.categories = categories;
  }

  @override
  List<Object> get props => [categories];
}



