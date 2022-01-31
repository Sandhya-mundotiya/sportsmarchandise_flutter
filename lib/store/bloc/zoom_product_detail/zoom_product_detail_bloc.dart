import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'zoom_product_detail_event.dart';
part 'zoom_product_detail_state.dart';

class ZoomProductDetailBloc extends Bloc<ZoomProductDetailEvent, ZoomProductDetailState> {

  ZoomProductDetailBloc({List<String> images}) : super(ZoomProductDetailState.initial()){
    add(ShowProductImages(images: images));
  }

  @override
  Stream<ZoomProductDetailState> mapEventToState(
      ZoomProductDetailEvent event,
      ) async* {

    if(event is ShowProductImages) yield state.update(images: event.images, isLoading: false);

    if(event is UpdatePageIndex) yield state.update(carouselCurentIndex: event.carouselCurentIndex);

  }



  @override
  Future<void> close() {
    return super.close();
  }



}
