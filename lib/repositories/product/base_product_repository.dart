
import 'package:merch/models/product_model.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
  addProduct({Product productObj});
}
