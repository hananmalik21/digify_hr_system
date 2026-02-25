import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/data/dto/timesheet_dto.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/models/timesheet/timesheet.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/models/timesheet/timesheet_page.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/models/timesheet/timesheet_status.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/repositories/timesheet_repository.dart';

class TimesheetRepositoryImpl implements TimesheetRepository {
  final ApiClient _apiClient;

  TimesheetRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<TimesheetPage> getTimesheets({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? searchQuery,
    TimesheetStatus? status,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final query = <String, String>{
        'enterpriseId': companyId ?? '1',
        'page': page.toString(),
        'limit': pageSize.toString(),
      };

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query['search'] = searchQuery.trim();
      }

      if (orgUnitId != null && orgUnitId.isNotEmpty) {
        query['orgUnitId'] = orgUnitId;
        query['org_unit_id'] = orgUnitId;
      }

      if (levelCode != null && levelCode.isNotEmpty) {
        query['levelCode'] = levelCode;
        query['level_code'] = levelCode;
      }

      final response = await _apiClient.get('/api/tm/timesheets', queryParameters: query);

      final data = response['data'] as List<dynamic>? ?? [];
      final pagination = (response['meta']?['pagination'] as Map<String, dynamic>?) ?? {};

      final items = data.whereType<Map<String, dynamic>>().map((e) => TimesheetDto.fromJson(e).toDomain()).toList();

      final total = pagination['total'] as int? ?? items.length;
      final currentPage = pagination['page'] as int? ?? page;
      final limit = pagination['limit'] as int? ?? pageSize;
      final hasMore = pagination['hasMore'] as bool? ?? false;

      return TimesheetPage(items: items, total: total, page: currentPage, pageSize: limit, hasMore: hasMore);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to load timesheets: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> getTimesheetStatistics({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
  }) async {
    return {
      'total': 0,
      'draft': 0,
      'submitted': 0,
      'approved': 0,
      'rejected': 0,
      'regularHours': 0.0,
      'overtimeHours': 0.0,
    };
  }

  @override
  Future<Timesheet> getTimesheetById(int timesheetId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation
    return Timesheet(
      id: timesheetId,
      employeeId: 1,
      employeeName: 'Ahmed Al-Mutairi',
      employeeNumber: 'EMP-001',
      departmentName: 'IT',
      weekStartDate: DateTime(2024, 12, 9),
      weekEndDate: DateTime(2024, 12, 15),
      regularHours: 40.0,
      overtimeHours: 2.0,
      totalHours: 42.0,
      status: TimesheetStatus.approved,
    );
  }

  @override
  Future<Timesheet> createTimesheet(Map<String, dynamic> timesheetData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('createTimesheet not implemented');
  }

  @override
  Future<Timesheet> updateTimesheet(int timesheetId, Map<String, dynamic> timesheetData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('updateTimesheet not implemented');
  }

  @override
  Future<Timesheet> submitTimesheet(int timesheetId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('submitTimesheet not implemented');
  }

  @override
  Future<Timesheet> approveTimesheet(int timesheetId, {String? notes}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('approveTimesheet not implemented');
  }

  @override
  Future<Timesheet> rejectTimesheet(int timesheetId, {required String reason}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('rejectTimesheet not implemented');
  }

  @override
  Future<void> deleteTimesheet(int timesheetId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('deleteTimesheet not implemented');
  }
}
