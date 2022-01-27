import 'package:flutter/cupertino.dart';
import 'package:merch/admin/bloc/edit_category/edit_category_bloc.dart';
import 'package:merch/models/category_model.dart';

abstract class BaseCategoryRepository {
  Stream<List<Category>> getAllCategories();
  addCategories({Category categoryOb,BuildContext context});
  updateCategoryOrSubCategory({Category category,EditCategoryBloc bloc});
  enableOrDisableCategory({String uid,EditCategoryBloc bloc,bool isEnable,String type});

}
