import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/models/school_model.dart';
import 'package:merch/repositories/school/base_school_repository.dart';

class SchoolRepository extends BaseSchoolRepository {
  final FirebaseFirestore _firebaseFirestore;

  SchoolRepository({
    FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<School>> getAllSchools() {
    return _firebaseFirestore
        .collection(SCHOOL_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => School.fromSnapshot(doc)).toList();
    });
  }
}
