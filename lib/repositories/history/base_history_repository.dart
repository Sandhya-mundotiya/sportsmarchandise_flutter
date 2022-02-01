import 'package:flutter/cupertino.dart';
import 'package:merch/models/product_history_model.dart';
import 'package:merch/models/product_model.dart';

abstract class BaseHistoryRepository {
  Stream<List<ProductHistoryModel>> getAllHistoryProducts({String catId = "", int date = 0});
  Stream<List<ProductHistoryModel>> getAllHistoryProductsUser();

  addHistoryProduct({ProductHistoryModel productObj,BuildContext context});
}
