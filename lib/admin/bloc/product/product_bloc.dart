import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:merch/admin/bloc/category/category_bloc.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription _productSubscription;

  final CategoryBloc categoryBloc;

  ProductBloc({ProductRepository productRepository,@required this.categoryBloc}): _productRepository = productRepository,
        super(ProductState.initial());

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is LoadProducts) yield* _mapLoadProductsToState(state);
    if (event is UpdateProducts) yield state.update(categories: categoryBloc.state.categories, products: event.products,isLoading: false);
    if (event is CategoryFilterUpdated) yield state.update(category: event.category,subCategory: Category(name: SELECT_VALUE));
    if (event is SubCategoryFilterUpdated) yield state.update(subCategory: event.subCategory);
    if (event is CreatedDateFilterUpdated) yield state.update(createdDate: event.createdDate);

    if (event is UpdateFilters) {
      yield state.update(isLoading: true);
      add(LoadProducts());
    }

    if (event is ClearFilters) {
      yield state.update(category: Category(name: SELECT_VALUE),subCategory: Category(name: SELECT_VALUE),createdDate: "");
      add(LoadProducts());
    }


  }

  Stream<ProductState> _mapLoadProductsToState(ProductState state) async* {
    _productSubscription?.cancel();

    String catId = "";
    int createdDate = 0;


      if (state.subCategory != null &&
          state.subCategory.catId != null &&
          state.subCategory.catId != "") {
        catId = state.subCategory.uId;
      } else if (state.category != null &&
          state.category.uId != null &&
          state.category.uId != "") {
        catId = state.category.uId;
      }

      if(state.createdDate != null && state.createdDate != ""){
        var localDate = DateFormat("dd-MM-yyyy").parse(state.createdDate);
        createdDate = localDate.microsecondsSinceEpoch;
      }


    _productSubscription = _productRepository.getAllProducts(catId: catId,createdDate: createdDate).listen(
          (products) => add(
            UpdateProducts(products),
          ),
        );
  }


  @override
  Future<void> close() {
    _productSubscription.cancel();
    return super.close();
  }
}
