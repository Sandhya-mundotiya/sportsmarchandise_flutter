import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:merch/admin/bloc/category/category_bloc.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/repositories/category/category_repository.dart';

part 'edit_category_event.dart';
part 'edit_category_state.dart';

class EditCategoryBloc extends Bloc<EditCategoryEvent, EditCategoryState> {

  final CategoryBloc _categoryBloc;
  final CategoryRepository _categoryRepository;

  EditCategoryBloc({@required CategoryBloc categoryBloc,@required CategoryRepository categoryRepository}) :
        _categoryRepository = categoryRepository, _categoryBloc = categoryBloc,
        super(EditCategoryState.initial()) {

    print("Categoty loaded");
    print(categoryBloc.state.categories);
    add(LoadCategory(categories: categoryBloc.state.categories));

  }


  @override
  Stream<EditCategoryState> mapEventToState(
      EditCategoryEvent event,
      ) async* {

    if(event is LoadCategory) yield(state.update(categoryList: event.categories));

    if(event is LoadSelectedCategoryDetail){

      Category selectedCategory = Category(name: SELECT_VALUE);
      if(event.selctedCatOrSubCat.catId != null && event.selctedCatOrSubCat.catId != ""){
        selectedCategory = state.categoryList.firstWhere((element) => element.uId == event.selctedCatOrSubCat.catId,
            orElse: () => Category(name: SELECT_VALUE));
      }

      yield state.update(selectedCatOrSubCat: event.selctedCatOrSubCat,
          selectedCategory: selectedCategory,nameValue: event.selctedCatOrSubCat.name,
          descValue: event.selctedCatOrSubCat.description,
        isEnable: event.selctedCatOrSubCat.isEnabled
      );
    }

    if(event is SelectCategoryForSubCategory) yield state.update(selectedCategory: event.selectedCategory,);

    if(event is UpdateParticularCatOrSubCat) {
      yield state.update(isLoading: true,);
      yield* _mapUpdateCategoryToState(state);
    };

    if(event is HideLoader) yield state.update(isLoading: false);
    if(event is EnableOrDisableCategory){
      yield state.update(isLoading: true,isEnable: event.isEnable);
      yield* _mapEnableOrDisableCategoryToState(state,event);
    }
  }

  Stream<EditCategoryState> _mapUpdateCategoryToState(EditCategoryState state) async* {

    Category updatedCategory = Category(name: state.nameController.text,description: state.descController.text);

    if(state.selectedCatOrSubCat.catId != ""){
      updatedCategory = Category(name: state.nameController.text,description: state.descController.text,
          catId: state.selectedCategory.uId,uId: state.selectedCatOrSubCat.uId,
          isEnabled: state.selectedCatOrSubCat.isEnabled,
        isSubCategory: true,
      );
    }else{
      updatedCategory = Category(name: state.nameController.text,description: state.descController.text,
          uId: state.selectedCatOrSubCat.uId,
          catId: "",
          isSubCategory: state.selectedCatOrSubCat.isSubCategory,isEnabled: state.selectedCatOrSubCat.isEnabled);
    }

    _categoryRepository.updateCategoryOrSubCategory(category: updatedCategory,bloc: this );

  }

  Stream<EditCategoryState> _mapEnableOrDisableCategoryToState(EditCategoryState state,EnableOrDisableCategory event) async* {

    String type = "Category";

    if(state.selectedCatOrSubCat.catId != null && state.selectedCatOrSubCat.catId != ""){
      type = "Sub Category";
    }

    _categoryRepository.enableOrDisableCategory(bloc: this,isEnable: event.isEnable,type: type,uid: state.selectedCatOrSubCat.uId);

  }



  @override
  Future<void> close() {
    return super.close();
  }
}
