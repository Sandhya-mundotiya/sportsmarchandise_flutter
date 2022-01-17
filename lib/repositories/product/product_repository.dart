import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/models/product_model.dart';
import 'package:merch/repositories/product/base_product_repository.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(PRODUCT_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }
}
