import 'package:digify_hr_system/features/leave_management/data/datasources/leave_details_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/leave_details_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaveDetailsDataSourceProvider = Provider<LeaveDetailsDataSource>((ref) {
  return LeaveDetailsDataSourceImpl();
});

final leaveDetailsDataProvider = FutureProvider.family<LeaveDetailsData, String>((ref, employeeId) {
  return ref.read(leaveDetailsDataSourceProvider).getLeaveDetails(employeeId);
});
