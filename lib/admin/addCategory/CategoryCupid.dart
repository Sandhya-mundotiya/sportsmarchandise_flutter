import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/main.dart';

import 'AddCategoryController.dart';

class CategoryCubit extends Cubit<int> {
  CategoryCubit() : super(1);
  var controller=getIt<AddCategoryModel>();
  void one(){
    controller.catValue=1;
    controller.isCategory=true;
    emit(state==2?state-1:state);
  }
  void two() {
    controller.catValue=2;
    controller.isCategory=false;
    emit(state==1?state+1:state);
  }
}