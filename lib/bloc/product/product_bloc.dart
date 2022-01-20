import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:merch/admin/home/filters.dart';
import 'package:merch/bloc/category/category_bloc.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/admin/home/filters_product_controller.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription _productSubscription;
  StreamSubscription categorySubscription;

  final CategoryBloc categoryBloc;

  ProductBloc(
      {ProductRepository productRepository,
      @required CategoryBloc categoryBloc})
      : _productRepository = productRepository,
        this.categoryBloc = categoryBloc,
        super(ProductLoading()) {
    categorySubscription =
        categoryBloc.stream.listen((CategoryState categoryState) {
      print("CategoryList");
      if (categoryState != null && categoryState.categories != null) {
        categoryBloc.state.categories = categoryState.categories;
        print(categoryState.categories);
      }
    });
  }

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is LoadProducts) {
        yield* _mapLoadProductsToState(state);
    }
    if (event is UpdateProducts) {
      yield* _mapUpdateProductsToState(event);
    }
    if (event is CategoryFilterUpdated) {
      yield* _mapCategoryFilterUpdatedToState(event, state);
    }
    if (event is SubCategoryFilterUpdated) {
      yield ProductLoaded(
        filter: Filters(
            subCategory: event.subCategory, catagory: state.filter.catagory,
            createdDateController: state.filter.createdDateController,
            createdDate: state.filter.createdDate),
        categories: state.categories,
        products: state.products,
      );
    }
    if (event is UpdateFilters) {
      add(LoadProducts());
    }
    if (event is ClearFilters) {
      state.filter = Filters(createdDateController: TextEditingController(),createdDate: "");
      add(LoadProducts());
    }

    if (event is CreatedDateFilterUpdated) {
      yield ProductLoaded(
        filter: Filters(
            subCategory: state.filter.subCategory, catagory: state.filter.catagory, createdDateController: state.filter
            .createdDateController,createdDate: event.createdDate),
        categories: state.categories,
        products: state.products,
      );
    }
  }

  Stream<ProductState> _mapLoadProductsToState(ProductState state) async* {
    _productSubscription?.cancel();

    String catId = "";
    int createdDate = 0;

    if(state.filter != null){
      if (state.filter.subCategory != null &&
          state.filter.subCategory.catId != null &&
          state.filter.subCategory.catId != "") {
        catId = state.filter.subCategory.uId;
      } else if (state.filter.catagory != null &&
          state.filter.catagory.uId != null &&
          state.filter.catagory.uId != "") {
        catId = state.filter.catagory.uId;
      }

      if(state.filter.createdDate != null && state.filter.createdDate != ""){
        var localDate = DateFormat("dd-MM-yyyy").parse(state.filter.createdDate);
        createdDate = localDate.microsecondsSinceEpoch;
      }
    }

    _productSubscription = _productRepository.getAllProducts(catId: catId,createdDate: createdDate).listen(
          (products) => add(
            UpdateProducts(products),
          ),
        );
  }

  Stream<ProductState> _mapLoadProductsWithCatFilter(
      ProductState state) async* {
    _productSubscription?.cancel();

    String catId = "";

    if (state.filter.subCategory != null &&
        state.filter.subCategory.catId != null &&
        state.filter.subCategory.catId != "") {
      catId = state.filter.subCategory.uId;
    } else if (state.filter.catagory != null &&
        state.filter.catagory.uId != null &&
        state.filter.catagory.uId != "") {
      catId = state.filter.catagory.uId;
    }

    _productSubscription =
        _productRepository.getAllProducts(catId: catId).listen(
              (products) => add(
                UpdateProducts(products),
              ),
            );
  }

  Stream<ProductState> _mapUpdateProductsToState(UpdateProducts event) async* {
    if (state.filter != null &&
        state.filter.subCategory != null &&
        state.filter.catagory != null && state.filter.createdDateController != null && state.filter.createdDate != null) {
      yield ProductLoaded(
          categories: categoryBloc.state.categories,
          products: event.products,
          filter: Filters(
              subCategory:
                  state.filter.subCategory ?? Category(name: selectValue),
              catagory: state.filter.catagory ?? Category(name: selectValue),
            createdDate: state.filter.createdDate ?? "",
              createdDateController: state.filter.createdDateController ?? TextEditingController()
          ));
    } else {
      yield ProductLoaded(
          categories: categoryBloc.state.categories,
          products: event.products,
          filter: Filters(
              subCategory: Category(name: selectValue),
              catagory: Category(name: selectValue),
              createdDate: "",
              createdDateController: TextEditingController()));
    }
  }

  Stream<ProductState> _mapCategoryFilterUpdatedToState(
    CategoryFilterUpdated event,
    ProductState state,
  ) async* {
    yield ProductLoaded(
      filter: Filters(
          catagory: event.category,
          subCategory: Category(name: selectValue),
        createdDate: state.filter.createdDate,
        createdDateController: state.filter.createdDateController
      ),
      categories: state.categories,
      products: state.products,
    );
  }

  @override
  void onEvent(ProductEvent event) {
    // TODO: implement onEvent
    super.onEvent(event);
    print(event);
  }

  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    // TODO: implement onTransition
    super.onTransition(transition);
    print(transition);
  }

  @override
  void onChange(Change<ProductState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }

  @override
  Future<void> close() {
    // TODO: implement close
    categorySubscription.cancel();
    _productSubscription.cancel();
    return super.close();
  }
}
