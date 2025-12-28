import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/grade_repository.dart';

class UpdateGradeUseCase {
  final GradeRepository repository;

  UpdateGradeUseCase(this.repository);

  Future<Grade> execute(int gradeId, Grade grade) {
    return repository.updateGrade(gradeId, grade);
  }
}
