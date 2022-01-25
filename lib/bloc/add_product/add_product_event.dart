part of 'add_product_bloc.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();
}

class LoadCategory extends AddProductEvent{
  final List<Category> categories;

  LoadCategory({this.categories});

  @override
  // TODO: implement props
  List<Object> get props => [categories];

}

class AddImagesToModel extends AddProductEvent{
  final List<Asset> images;

  AddImagesToModel({this.images});

  @override
  // TODO: implement props
  List<Object> get props => [images];

}

class AddSelectedCategoryModel extends AddProductEvent{
  final Category selectedCategory;

  AddSelectedCategoryModel({this.selectedCategory});

  @override
  // TODO: implement props
  List<Object> get props => [selectedCategory];

}

class AddSelectedSubCategoryModel extends AddProductEvent{
  final Category selectedSubCategory;

  AddSelectedSubCategoryModel({this.selectedSubCategory});

  @override
  // TODO: implement props
  List<Object> get props => [selectedSubCategory];

}

class AddProduct extends AddProductEvent{
  final BuildContext context;

  AddProduct({this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];

}

class StopLoading extends AddProductEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class DeleteAssetImage extends AddProductEvent{
  final Asset deleteImageAsset;

  DeleteAssetImage({this.deleteImageAsset});

  @override
  // TODO: implement props
  List<Object> get props => [deleteImageAsset];

}

