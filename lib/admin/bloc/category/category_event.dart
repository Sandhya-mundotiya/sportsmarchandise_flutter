part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  List<Category> categories;

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

class UpdateCategories extends CategoryEvent {


  UpdateCategories({List<Category> categories}){
    super.categories = categories;
  }

  @override
  List<Object> get props => [categories];
}


