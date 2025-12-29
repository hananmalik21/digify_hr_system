import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade_response.dart';

abstract class GradeRepository {
  Future<GradeResponse> getGrades({
    int page = 1,
    int pageSize = 10,
    String? search,
  });
  Future<Grade> createGrade(Grade grade);
  Future<Grade> updateGrade(int gradeId, Grade grade);
  Future<void> deleteGrade(int gradeId);
}
