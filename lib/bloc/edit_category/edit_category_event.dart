part of 'edit_category_bloc.dart';

abstract class EditCategoryEvent extends Equatable {
  const EditCategoryEvent();
}

class LoadCategory extends EditCategoryEvent{
  final List<Category> categories;

  LoadCategory({this.categories});

  @override
  // TODO: implement props
  List<Object> get props => [categories];

}

class LoadSelectedCategoryDetail extends EditCategoryEvent{
  final Category selctedCatOrSubCat;

  LoadSelectedCategoryDetail({this.selctedCatOrSubCat});

  @override
  // TODO: implement props
  List<Object> get props => [selctedCatOrSubCat];

}

class SelectCategoryForSubCategory extends EditCategoryEvent{
  final Category selectedCategory;

  SelectCategoryForSubCategory({this.selectedCategory});

  @override
  // TODO: implement props
  List<Object> get props => [selectedCategory];

}

class UpdateParticularCatOrSubCat extends EditCategoryEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class EnableOrDisableCategory extends EditCategoryEvent{

  final bool isEnable;

  EnableOrDisableCategory({this.isEnable});

  @override
  // TODO: implement props
  List<Object> get props => [isEnable];

}

class HideLoader extends EditCategoryEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

}


