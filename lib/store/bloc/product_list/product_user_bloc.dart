
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merch/admin/bloc/category/category_bloc.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';

part 'product_user_event.dart';
part 'product_user_state.dart';

class ProductUserBloc extends Bloc<ProductUserEvent, ProductUserState> {
  final ProductRepository _productRepository;
  StreamSubscription _productSubscription;

  final CategoryBloc categoryBloc;

  ProductUserBloc({ProductRepository productRepository,@required this.categoryBloc}): _productRepository = productRepository,
        super(ProductUserState.initial());

  @override
  Stream<ProductUserState> mapEventToState(
      ProductUserEvent event,
      ) async* {
    if (event is LoadProducts) yield* _mapLoadProductsToState(state);
    if (event is UpdateProducts) yield state.update(categories: categoryBloc.state.categories, products: event.products,isLoading: false);
    if (event is CategoryFilterUpdated) yield state.update(category: event.category,subCategory: Category(name: SELECT_VALUE));
    if (event is SubCategoryFilterUpdated) yield state.update(subCategory: event.subCategory);
    if (event is PriceFilterUpdated) yield state.update(price: event.price);

    if (event is UpdateFilters) {
      yield state.update(isLoading: true);
      add(LoadProducts());
    }

    if (event is ClearFilters) {
      yield state.update(category: Category(name: SELECT_VALUE),subCategory: Category(name: SELECT_VALUE),price: "",purchaseDate: "");
      add(LoadProducts());
    }


  }

  Stream<ProductUserState> _mapLoadProductsToState(ProductUserState state) async* {
    _productSubscription?.cancel();

    String catId = "",price = "";
    int purchaseDate = 0;


    if (state.subCategory != null &&
        state.subCategory.catId != null &&
        state.subCategory.catId != "") {
      catId = state.subCategory.uId;
    } else if (state.category != null &&
        state.category.uId != null &&
        state.category.uId != "") {
      catId = state.category.uId;
    }

    if(state.purchaseDate != null && state.purchaseDate != ""){
      var localDate = DateFormat("dd-MM-yyyy").parse(state.purchaseDate);
      purchaseDate = localDate.microsecondsSinceEpoch;
    }

    price = state.priceController.text;


    _productSubscription = _productRepository.getAllProductsUser(catId: catId,purchaseDate: purchaseDate,price: price).listen(
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
