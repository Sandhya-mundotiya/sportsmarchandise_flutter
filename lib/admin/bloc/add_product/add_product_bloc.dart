import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:merch/admin/bloc/category/category_bloc.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final CategoryBloc _categoryBloc;
  final ProductRepository _productRepository;
  StreamSubscription _categorySubscription;

  AddProductBloc({@required CategoryBloc categoryBloc,@required ProductRepository productRepository}) :
        _productRepository = productRepository, _categoryBloc = categoryBloc,
        super(AddProductState.initial()) {
    add(LoadCategory(categories: categoryBloc.state.categories));

  }

  @override
  Stream<AddProductState> mapEventToState(
      AddProductEvent event,
      ) async* {

    if(event is LoadCategory) yield(state.update(categoryList: event.categories));
    if(event is AddImagesToModel) yield(state.update(images: event.images));
    if(event is AddSelectedCategoryModel) yield(state.update(selectedCategory: event.selectedCategory,categoryValue: event.selectedCategory.name));
    if(event is AddSelectedSubCategoryModel) yield(state.update(selectedSubCategory: event.selectedSubCategory,subCategoryValue: event.selectedSubCategory.name));
    if(event is AddProduct){
      yield state.update(isLoading: true);
      yield* _mapToAddProductState(state,event,event.context);
    }
    if(event is StopLoading) yield state.update(isLoading: false);

    if(event is DeleteAssetImage) {
      List<Asset> images = state.images;
      images.removeWhere((element) => element == event.deleteImageAsset);
      yield state.update(images: images,isLoading: false);

    }
  }

  Stream<AddProductState> _mapToAddProductState(AddProductState state,AddProductEvent event, BuildContext context) async* {

    var currentDate = DateTime.now();
    DateTime formattedDate = new DateTime(currentDate.year, currentDate.month, currentDate.day);

    var productObj=Product(
      name: state.nameController.text,
      catId: state.subCategoryController.text.isNotEmpty?state.selectedSubCategory.uId:state.selectedCategory.uId,
      description: state.descController.text,
      createdDate: formattedDate.microsecondsSinceEpoch,
      // images: state.images,
      price: state.priceController.text,
    );

    _productRepository.addProduct(productObj: productObj,context: context,assetImages: state.images);


  }


}
