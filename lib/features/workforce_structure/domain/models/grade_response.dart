import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level_response.dart';

/// Grade response with pagination
class GradeResponse {
  final List<Grade> data;
  final JobLevelMeta meta;

  const GradeResponse({required this.data, required this.meta});
}
