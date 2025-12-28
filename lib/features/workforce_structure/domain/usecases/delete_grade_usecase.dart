import 'package:digify_hr_system/features/workforce_structure/domain/repositories/grade_repository.dart';

class DeleteGradeUseCase {
  final GradeRepository repository;

  DeleteGradeUseCase(this.repository);

  Future<void> execute(int gradeId) {
    return repository.deleteGrade(gradeId);
  }
}
