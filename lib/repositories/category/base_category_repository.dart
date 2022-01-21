import 'package:merch/admin/add_category/add_category_controller.dart';
import 'package:merch/bloc/edit_category/edit_category_bloc.dart';
import 'package:merch/models/category_model.dart';

abstract class BaseCategoryRepository {
  Stream<List<Category>> getAllCategories();
  addCategories({Category categoryOb,String schoolId,AddCategoryController controller});
  updateCategoryOrSubCategory({Category category,EditCategoryBloc bloc});
  enableOrDisableCategory({String uid,EditCategoryBloc bloc,bool isEnable,String type});

}
