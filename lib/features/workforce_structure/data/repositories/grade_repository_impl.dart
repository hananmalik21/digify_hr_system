import 'package:digify_hr_system/features/workforce_structure/data/datasources/grade_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade_response.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/grade_repository.dart';

class GradeRepositoryImpl implements GradeRepository {
  final GradeRemoteDataSource remoteDataSource;

  const GradeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GradeResponse> getGrades({int page = 1, int pageSize = 10}) async {
    return await remoteDataSource.getGrades(page: page, pageSize: pageSize);
  }

  @override
  Future<Grade> createGrade(Grade grade) async {
    final data = {
      'grade_number': grade.gradeNumber,
      'grade_category': grade.gradeCategory,
      'step_1_salary': grade.step1Salary,
      'step_2_salary': grade.step2Salary,
      'step_3_salary': grade.step3Salary,
      'step_4_salary': grade.step4Salary,
      'step_5_salary': grade.step5Salary,
      'description': grade.description,
      'last_update_login': 'ADMIN',
    };
    return await remoteDataSource.createGrade(data);
  }

  @override
  Future<void> deleteGrade(int gradeId) async {
    return await remoteDataSource.deleteGrade(gradeId);
  }
}
