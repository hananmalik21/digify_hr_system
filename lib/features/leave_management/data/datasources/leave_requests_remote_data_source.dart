import 'dart:io';
import 'package:dio/dio.dart';
import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:digify_hr_system/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class LeaveRequestsRemoteDataSource {
  Future<PaginatedLeaveRequestsDto> getLeaveRequests({int page = 1, int pageSize = 10, String? status});

  Future<Map<String, dynamic>> approveLeaveRequest(String guid);

  Future<Map<String, dynamic>> rejectLeaveRequest(String guid);

  Future<Map<String, dynamic>> createLeaveRequest(NewLeaveRequestState state, bool submit);
}

class LeaveRequestsRemoteDataSourceImpl implements LeaveRequestsRemoteDataSource {
  final ApiClient apiClient;

  static const Map<String, String> _absHeaders = {'x-tenant-id': '1001', 'x-user-id': 'admin'};

  LeaveRequestsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedLeaveRequestsDto> getLeaveRequests({int page = 1, int pageSize = 10, String? status}) async {
    try {
      final queryParameters = <String, String>{'page': page.toString(), 'page_size': pageSize.toString()};

      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      final response = await apiClient.get(ApiEndpoints.absLeaveRequests, queryParameters: queryParameters);

      return PaginatedLeaveRequestsDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave requests: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> approveLeaveRequest(String guid) async {
    try {
      final response = await apiClient.post(ApiEndpoints.absLeaveRequestApprove(guid), headers: _absHeaders);

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to approve leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> rejectLeaveRequest(String guid) async {
    try {
      final response = await apiClient.post(ApiEndpoints.absLeaveRequestReject(guid), headers: _absHeaders);

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to reject leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> createLeaveRequest(NewLeaveRequestState state, bool submit) async {
    try {
      if (state.selectedEmployee == null ||
          state.leaveType == null ||
          state.startDate == null ||
          state.endDate == null) {
        throw ValidationException(
          'Required fields are missing',
          errors: {
            'employee': 'Employee is required',
            'leaveType': 'Leave type is required',
            'startDate': 'Start date is required',
            'endDate': 'End date is required',
          },
        );
      }

      final formData = FormData();

      formData.fields.add(MapEntry('employee_guid', state.selectedEmployee!.guid));
      formData.fields.add(MapEntry('leave_type_id', LeaveTypeMapper.getLeaveTypeId(state.leaveType!).toString()));
      formData.fields.add(MapEntry('start_date', _formatDate(state.startDate!)));
      formData.fields.add(MapEntry('end_date', _formatDate(state.endDate!)));

      final startPortion = _mapTimeToPortion(state.startTime);
      final endPortion = _mapTimeToPortion(state.endTime);
      formData.fields.add(MapEntry('start_portion', startPortion));
      formData.fields.add(MapEntry('end_portion', endPortion));

      if (state.reason != null && state.reason!.isNotEmpty) {
        formData.fields.add(MapEntry('reason_for_leave', state.reason!));
      }

      if (state.addressDuringLeave != null && state.addressDuringLeave!.isNotEmpty) {
        formData.fields.add(MapEntry('address_during_leave', state.addressDuringLeave!));
      }

      if (state.contactPhoneNumber != null && state.contactPhoneNumber!.isNotEmpty) {
        formData.fields.add(MapEntry('contact_phone', state.contactPhoneNumber!));
      }

      if (state.emergencyContactName != null && state.emergencyContactName!.isNotEmpty) {
        formData.fields.add(MapEntry('emergency_contact_name', state.emergencyContactName!));
      }

      if (state.emergencyContactPhone != null && state.emergencyContactPhone!.isNotEmpty) {
        formData.fields.add(MapEntry('emergency_contact_phone', state.emergencyContactPhone!));
      }

      if (state.additionalNotes != null && state.additionalNotes!.isNotEmpty) {
        formData.fields.add(MapEntry('additional_notes', state.additionalNotes!));
      }

      formData.fields.add(MapEntry('submit', submit.toString()));

      for (final document in state.documents) {
        if (kIsWeb) {
          continue;
        } else {
          final file = File(document.path);
          if (await file.exists()) {
            final multipartFile = await MultipartFile.fromFile(document.path, filename: document.name);
            formData.files.add(MapEntry('documents', multipartFile));
          }
        }
      }

      final response = await apiClient.postMultipart(
        ApiEndpoints.absLeaveRequests,
        formData: formData,
        headers: _absHeaders,
      );

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create leave request: ${e.toString()}', originalError: e);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _mapTimeToPortion(String? time) {
    if (time == null || time.isEmpty) {
      return 'FULL_DAY';
    }

    final timeLower = time.toLowerCase().trim();

    if (timeLower == 'full time' || timeLower == 'full day' || timeLower == 'full') {
      return 'FULL_DAY';
    }

    if (timeLower == 'half time' || timeLower == 'half') {
      return 'HALF_AM';
    }

    if (time == 'FULL_DAY' || time == 'HALF_AM' || time == 'HALF_PM' || time == 'HOURS') {
      return time;
    }

    return 'FULL_DAY';
  }
}
