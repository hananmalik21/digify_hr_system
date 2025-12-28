import 'package:digify_hr_system/features/workforce_structure/data/models/grade_model.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade_response.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level_response.dart';

class GradeResponseModel {
  final List<GradeModel> data;
  final JobLevelMeta meta;

  const GradeResponseModel({required this.data, required this.meta});

  factory GradeResponseModel.fromJson(Map<String, dynamic> json) {
    return GradeResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((item) => GradeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      meta: JobLevelMeta(
        version: json['meta']['version'] as String,
        timestamp: json['meta']['timestamp'] as String,
        requestId: json['meta']['request_id'] as String,
        count: json['meta']['count'] as int,
        total: json['meta']['total'] as int,
        executionTime: json['meta']['execution_time'] as String,
        pagination: JobLevelPagination(
          page: json['meta']['pagination']['page'] as int,
          pageSize: json['meta']['pagination']['page_size'] as int,
          total: json['meta']['pagination']['total'] as int,
          totalPages: json['meta']['pagination']['total_pages'] as int,
          hasNext: json['meta']['pagination']['has_next'] as bool,
          hasPrevious: json['meta']['pagination']['has_previous'] as bool,
        ),
      ),
    );
  }

  GradeResponse toEntity() {
    return GradeResponse(
      data: data.map((model) => model.toEntity()).toList(),
      meta: meta,
    );
  }
}
