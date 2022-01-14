import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/main.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import 'AddProductController.dart';
class AssetCubit extends Cubit<List<Asset>> {
  AssetCubit() : super([]);
  var controller=getIt<AddProductModel>();
  void refresh(){
    clear();
    emit(controller.images);
  }
  void clear(){
    emit([]);
  }
}