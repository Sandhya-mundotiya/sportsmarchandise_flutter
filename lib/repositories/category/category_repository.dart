import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/repositories/category/base_category_repository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({
    FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Category>> getAllCategories() {
    return _firebaseFirestore
        .collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(CATEGORY_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList();
    });
  }
}
