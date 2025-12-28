import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/grade_repository.dart';

class CreateGradeUseCase {
  final GradeRepository repository;

  CreateGradeUseCase(this.repository);

  Future<Grade> execute(Grade grade) {
    return repository.createGrade(grade);
  }
}
