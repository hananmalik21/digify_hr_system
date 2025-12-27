import 'package:digify_hr_system/features/workforce_structure/data/datasources/grade_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade_response.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/grade_repository.dart';

class GradeRepositoryImpl implements GradeRepository {
  final GradeRemoteDataSource remoteDataSource;

  const GradeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GradeResponse> getGrades({int page = 1, int pageSize = 10}) async {
    return await remoteDataSource.getGrades(page: page, pageSize: pageSize);
  }
}
