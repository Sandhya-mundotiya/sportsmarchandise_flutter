import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/main.dart';



class ProductDetailCubit extends Cubit<int> {
  ProductDetailCubit() : super(0);

  void setCarouselCurentIndex({int carouselCurentIndex}){
    emit(carouselCurentIndex);
  }
}