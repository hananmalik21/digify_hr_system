import 'package:digify_hr_system/features/workforce_structure/domain/models/grade_response.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/grade_repository.dart';

class GetGradesUseCase {
  final GradeRepository repository;

  GetGradesUseCase(this.repository);

  Future<GradeResponse> execute({
    int page = 1,
    int pageSize = 10,
    String? search,
  }) {
    return repository.getGrades(page: page, pageSize: pageSize, search: search);
  }
}
