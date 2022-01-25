part of 'add_category_bloc.dart';

abstract class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();
}


class LoadCategory extends AddCategoryEvent{
  final List<Category> categories;

  LoadCategory({this.categories});

  @override
  // TODO: implement props
  List<Object> get props => [categories];

}

class SelectCategoryForSubCategory extends AddCategoryEvent{
  final Category selectedCategory;

  SelectCategoryForSubCategory({this.selectedCategory});

  @override
  // TODO: implement props
  List<Object> get props => [selectedCategory];

}

class UpdateCatValue extends AddCategoryEvent{
  final int catValue;

  UpdateCatValue({this.catValue});

  @override
  // TODO: implement props
  List<Object> get props => [catValue];

}

class AddNewCategory extends AddCategoryEvent{
  final BuildContext context;

  AddNewCategory({this.context});

  @override
  // TODO: implement props
  List<Object> get props => [context];

}

class CategoryAddedSuccessfully extends AddCategoryEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

