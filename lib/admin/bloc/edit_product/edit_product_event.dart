part of 'edit_product_bloc.dart';

abstract class EditProductEvent extends Equatable {
  const EditProductEvent();
}

class LoadCategory extends EditProductEvent{
  final List<Category> categories;

  LoadCategory({this.categories});

  @override
  // TODO: implement props
  List<Object> get props => [categories];

}

class AddImagesToModel extends EditProductEvent{
  final List<Asset> images;

  AddImagesToModel({this.images});

  @override
  // TODO: implement props
  List<Object> get props => [images];

}

class AddSelectedCategoryModel extends EditProductEvent{
  final Category selectedCategory;

  AddSelectedCategoryModel({this.selectedCategory});

  @override
  // TODO: implement props
  List<Object> get props => [selectedCategory];

}

class AddSelectedSubCategoryModel extends EditProductEvent{
  final Category selectedSubCategory;

  AddSelectedSubCategoryModel({this.selectedSubCategory});

  @override
  // TODO: implement props
  List<Object> get props => [selectedSubCategory];

}

class UpdateProduct extends EditProductEvent{
  final BuildContext context;

  UpdateProduct({this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];

}

class StopLoading extends EditProductEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class DeleteUrlImage extends EditProductEvent{
  final String deletedImageUrl;
  BuildContext context;

  DeleteUrlImage({this.deletedImageUrl,this.context});

  @override
  // TODO: implement props
  List<Object> get props => [deletedImageUrl,context];

}

class DeleteAssetImage extends EditProductEvent{
  final Asset deleteImageAsset;

  DeleteAssetImage({this.deleteImageAsset});

  @override
  // TODO: implement props
  List<Object> get props => [deleteImageAsset];

}

class SuccessfulyDeletedImage extends EditProductEvent{

  final String deletedImageUrl;

  SuccessfulyDeletedImage({this.deletedImageUrl});
  @override
  // TODO: implement props
  List<Object> get props => [deletedImageUrl];

}