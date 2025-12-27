import 'package:digify_hr_system/features/workforce_structure/domain/models/grade_response.dart';

abstract class GradeRepository {
  Future<GradeResponse> getGrades({int page = 1, int pageSize = 10});
}
