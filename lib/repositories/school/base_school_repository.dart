
import 'package:merch/models/school_model.dart';

abstract class BaseSchoolRepository {
  Stream<List<School>> getAllSchools();
}
