import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import '../../domain/models/overtime/overtime_requests_page.dart';
import '../../domain/repositories/overtime_repository.dart';
import '../datasources/overtime_requests_remote_data_source.dart';

class OvertimeRepositoryImpl implements OvertimeRepository {
  final OvertimeRequestsRemoteDataSource _requestsDataSource;

  OvertimeRepositoryImpl({OvertimeRequestsRemoteDataSource? requestsDataSource})
    : _requestsDataSource =
          requestsDataSource ?? OvertimeRequestsRemoteDataSourceImpl(apiClient: ApiClient(baseUrl: ApiConfig.baseUrl));

  @override
  Future<OvertimeRequestsPage> getOvertimeRequests({
    required int tenantId,
    String? status,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    final dto = await _requestsDataSource.getOvertimeRequests(
      tenantId: tenantId,
      status: status,
      orgUnitId: orgUnitId,
      levelCode: levelCode,
      page: page,
      pageSize: pageSize,
    );

    final records = dto.items.map((e) => e.toDomain()).toList();
    final pag = dto.pagination;

    return OvertimeRequestsPage(
      records: records,
      page: pag.page,
      pageSize: pag.limit,
      total: pag.total,
      hasMore: pag.hasMore,
    );
  }
}
