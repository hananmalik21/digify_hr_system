import 'package:digify_hr_system/features/workforce_structure/data/models/job_level_model.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level_response.dart';

class JobLevelResponseModel {
  static JobLevelResponse fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson =
        metaJson['pagination'] as Map<String, dynamic>? ?? {};

    return JobLevelResponse(
      success: json['success'] as bool? ?? false,
      meta: JobLevelMeta(
        version: metaJson['version'] as String? ?? '',
        timestamp: metaJson['timestamp'] as String? ?? '',
        requestId: metaJson['request_id'] as String? ?? '',
        count: metaJson['count'] as int? ?? 0,
        total: metaJson['total'] as int? ?? 0,
        executionTime: metaJson['execution_time'] as String? ?? '',
        pagination: JobLevelPagination(
          page: paginationJson['page'] as int? ?? 1,
          pageSize: paginationJson['page_size'] as int? ?? 10,
          total: paginationJson['total'] as int? ?? 0,
          totalPages: paginationJson['total_pages'] as int? ?? 0,
          hasNext: paginationJson['has_next'] as bool? ?? false,
          hasPrevious: paginationJson['has_previous'] as bool? ?? false,
        ),
      ),
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => JobLevelModel.fromJson(
                  item as Map<String, dynamic>,
                ).toEntity(),
              )
              .toList() ??
          [],
    );
  }
}
