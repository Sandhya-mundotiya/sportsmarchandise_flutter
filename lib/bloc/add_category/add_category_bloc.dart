import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:merch/bloc/category/category_bloc.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/repositories/category/category_repository.dart';

part 'add_category_event.dart';
part 'add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final CategoryBloc _categoryBloc;
  final CategoryRepository _categoryRepository;
  final int _catValue;

  AddCategoryBloc({@required CategoryBloc categoryBloc,@required CategoryRepository categoryRepository,@required int catValue}) :
        _categoryRepository = categoryRepository, _categoryBloc = categoryBloc,_catValue = catValue,
        super(AddCategoryState.initial()) {

    add(LoadCategory(categories: categoryBloc.state.categories));

  }

  @override
  Stream<AddCategoryState> mapEventToState(
      AddCategoryEvent event,
      ) async* {

    if(event is LoadCategory) yield(state.update(categoryList: event.categories,catValue: _catValue));
    if(event is SelectCategoryForSubCategory) yield state.update(selectedCategory: event.selectedCategory,);
    if(event is UpdateCatValue) yield state.update(catValue: event.catValue,);
    if(event is AddNewCategory){
      yield state.update(isLoading: true,);
      yield* _mapAddCategoryToState(state,event);
    }

    if(event is CategoryAddedSuccessfully) yield state.update(isLoading: false,descValue: "",nameValue: "",selectedCategory: Category(name: SELECT_VALUE));
  }


  Stream<AddCategoryState> _mapAddCategoryToState(AddCategoryState state,AddNewCategory event) async* {

    var categoryOb = Category(
      isEnabled: true,
      isSubCategory: state.catValue==2 && state.selectedCategory.name != SELECT_VALUE ?? false,
      catId: state.catValue==2 ? state.selectedCategory.uId : "",
      description: state.descController.text,
      name: state.nameController.text,
    );

    _categoryRepository.addCategories(context: event.context,categoryOb: categoryOb);
  }



}
