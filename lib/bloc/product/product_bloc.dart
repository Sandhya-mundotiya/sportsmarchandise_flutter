import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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

  ProductBloc({ProductRepository productRepository,@required CategoryBloc categoryBloc})
      : _productRepository = productRepository, this.categoryBloc = categoryBloc,
        super(ProductLoading()){
    categorySubscription = categoryBloc.stream.listen((CategoryState categoryState) {
      print("CategoryList");
      categoryBloc.state.categories = categoryState.categories;
      print(categoryState.categories);
    });
  }

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is LoadProducts) {

      if(state.filter.catagory.catId != null && state.filter.catagory.catId != ""){
        yield* _mapLoadProductsWithCatFilter();
      }else{
        yield* _mapLoadProductsToState();
      }

    }
    if (event is UpdateProducts) {
      yield* _mapUpdateProductsToState(event);
    }
    if (event is CategoryFilterUpdated) {
      yield* _mapCategoryFilterUpdatedToState(event,state);
    }
    if (event is SubCategoryFilterUpdated) {
      yield ProductLoaded(filter: Filters(subCategory: event.subCategory, catagory: state.filter.catagory), categories: state.categories, products: state.products,);
    }
    if (event is UpdateFilters) {
       add(LoadProducts());
    }


  }

  Stream<ProductState> _mapLoadProductsToState() async* {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
          (products) => add(
            UpdateProducts(products),
          ),
        );
  }

  Stream<ProductState> _mapLoadProductsWithCatFilter() async* {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts(catId: state.filter.catagory.catId).listen(
          (products) => add(
        UpdateProducts(products),
      ),
    );
  }


  Stream<ProductState> _mapUpdateProductsToState(UpdateProducts event) async* {
    yield ProductLoaded(categories: categoryBloc.state.categories,products: event.products,
        filter: Filters(subCategory: state.filter.subCategory ?? Category(name: selectValue),catagory: state.filter.catagory ?? Category(name: selectValue)));
  }

  Stream<ProductState> _mapCategoryFilterUpdatedToState(
      CategoryFilterUpdated event,
      ProductState state,
      ) async* {
    yield ProductLoaded(filter:
    Filters(
        catagory: event.category,
      subCategory: Category(name: selectValue)
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
