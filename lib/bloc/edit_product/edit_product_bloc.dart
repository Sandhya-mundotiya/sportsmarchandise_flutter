import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:merch/bloc/category/category_bloc.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

part 'edit_product_event.dart';
part 'edit_product_state.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  final CategoryBloc _categoryBloc;
  final ProductRepository _productRepository;
  StreamSubscription _categorySubscription;
  final Product _selectedProduct;

  EditProductBloc({@required CategoryBloc categoryBloc,@required ProductRepository productRepository,@required  Product selectedProduct}) :
        _productRepository = productRepository, _categoryBloc = categoryBloc, _selectedProduct = selectedProduct,
        super(EditProductState.initial()) {

    print("Categoty loaded");
    print(categoryBloc.state.categories);
    add(LoadCategory(categories: categoryBloc.state.categories));

  }

  @override
  Stream<EditProductState> mapEventToState(
      EditProductEvent event,
      ) async* {

    if(event is LoadCategory) {

      Category category = event.categories.firstWhere((element) => element.uId == _selectedProduct.catId);
      print(category);
      Category subCategory;

      if(category != null && category.isSubCategory){
        subCategory = category;
        category = event.categories.firstWhere((element) => element.uId == category.catId);

        yield(state.update(categoryList: event.categories,nameValue: _selectedProduct.name,priceValue: _selectedProduct.price,
            descValue: _selectedProduct.description,imagesNetwork: _selectedProduct.images,selectedCategory: category,categoryValue: category.name,
          subCategoryValue: subCategory.name,selectedSubCategory: subCategory
        ));
      }

      yield(state.update(categoryList: event.categories,nameValue: _selectedProduct.name,priceValue: _selectedProduct.price,
          descValue: _selectedProduct.description,imagesNetwork: _selectedProduct.images,selectedCategory: category,categoryValue: category.name
      ));
    }
    if(event is AddImagesToModel) yield(state.update(images: event.images));
    if(event is AddSelectedCategoryModel) yield(state.update(selectedCategory: event.selectedCategory,categoryValue: event.selectedCategory.name));
    if(event is AddSelectedSubCategoryModel) yield(state.update(selectedSubCategory: event.selectedSubCategory,subCategoryValue: event.selectedSubCategory.name));
    if(event is UpdateProduct){
      yield state.update(isLoading: true);
      yield* _mapToUpdateProductProductState(state,event,event.context);
    }
    if(event is StopLoading) yield state.update(isLoading: false);
  }


  Stream<EditProductState> _mapToUpdateProductProductState(EditProductState state,EditProductEvent event, BuildContext context) async* {
    _categorySubscription?.cancel();

    String catId = "";

    if(state.selectedSubCategory != null){
      catId = state.selectedSubCategory.uId;
    }else{
      catId = state.selectedCategory.uId;
    }

    Product updatedProduct = Product(
      description: state.descController.text,
      uid: _selectedProduct.uid,
      name: state.nameController.text,
      price: state.priceController.text,
      catId: catId,
    );

    _productRepository.updateProduct(productObj:  updatedProduct,context: context);

  }

}
