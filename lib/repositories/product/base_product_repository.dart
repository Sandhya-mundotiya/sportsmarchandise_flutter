
import 'package:flutter/cupertino.dart';
import 'package:merch/admin/bloc/edit_product/edit_product_bloc.dart';
import 'package:merch/models/product_model.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts({String catId = "", int createdDate = 0});
  Stream<List<Product>> getAllProductsUser({String catId = "", String price = "", int purchaseDate = 0});

  addProduct({Product productObj,BuildContext context,List<Asset> assetImages});
  updateProduct({Product productObj,BuildContext context,List<Asset> assetImages});
  deleteImage({String image, BuildContext context,String uid});
}
