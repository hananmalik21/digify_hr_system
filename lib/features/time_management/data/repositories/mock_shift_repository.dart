import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/shift_repository.dart';

class MockShiftRepository implements ShiftRepository {
  @override
  Future<PaginatedShifts> getShifts({
    String? search,
    bool? isActive,
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final allShifts = [
      const ShiftOverview(
        id: 1,
        name: 'Morning Shift',
        code: 'MS-001',
        startTime: '08:00',
        endTime: '16:00',
        totalHours: 8.0,
        isActive: true,
        assignedEmployeesCount: 45,
      ),
      const ShiftOverview(
        id: 2,
        name: 'Evening Shift',
        code: 'ES-001',
        startTime: '16:00',
        endTime: '00:00',
        totalHours: 8.0,
        isActive: true,
        assignedEmployeesCount: 32,
      ),
      const ShiftOverview(
        id: 3,
        name: 'Night Shift',
        code: 'NS-001',
        startTime: '00:00',
        endTime: '08:00',
        totalHours: 8.0,
        isActive: true,
        assignedEmployeesCount: 28,
      ),
      const ShiftOverview(
        id: 4,
        name: 'Day Shift',
        code: 'DS-001',
        startTime: '09:00',
        endTime: '17:00',
        totalHours: 8.0,
        isActive: true,
        assignedEmployeesCount: 52,
      ),
      const ShiftOverview(
        id: 5,
        name: 'Flexible Shift',
        code: 'FS-001',
        startTime: '10:00',
        endTime: '18:00',
        totalHours: 8.0,
        isActive: true,
        assignedEmployeesCount: 18,
      ),
      const ShiftOverview(
        id: 6,
        name: 'Weekend Shift',
        code: 'WS-001',
        startTime: '08:00',
        endTime: '20:00',
        totalHours: 12.0,
        isActive: false,
        assignedEmployeesCount: 12,
      ),
    ];

    var filteredShifts = allShifts;

    if (search != null && search.isNotEmpty) {
      filteredShifts = filteredShifts
          .where(
            (shift) =>
                shift.name.toLowerCase().contains(search.toLowerCase()) ||
                shift.code.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }

    if (isActive != null) {
      filteredShifts = filteredShifts
          .where((shift) => shift.isActive == isActive)
          .toList();
    }

    return PaginatedShifts(
      shifts: filteredShifts,
      pagination: PaginationInfo(
        currentPage: page,
        pageSize: pageSize,
        totalItems: filteredShifts.length,
        totalPages: (filteredShifts.length / pageSize).ceil(),
        hasNext: page < (filteredShifts.length / pageSize).ceil(),
        hasPrevious: page > 1,
      ),
    );
  }

  @override
  Future<List<ShiftOverview>> getActiveShifts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final result = await getShifts(isActive: true);
    return result.shifts;
  }

  @override
  Future<Shift> getShiftById(int shiftId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    throw UnimplementedError('Mock implementation - not needed for testing');
  }

  @override
  Future<Shift> createShift(Map<String, dynamic> shiftData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError('Mock implementation - not needed for testing');
  }

  @override
  Future<Shift> updateShift(int shiftId, Map<String, dynamic> shiftData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError('Mock implementation - not needed for testing');
  }

  @override
  Future<void> deleteShift(int shiftId, {bool hard = true}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    throw UnimplementedError('Mock implementation - not needed for testing');
  }

  @override
  Future<void> assignShiftToEmployee(int shiftId, int employeeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    throw UnimplementedError('Mock implementation - not needed for testing');
  }

  @override
  Future<void> removeShiftFromEmployee(int shiftId, int employeeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    throw UnimplementedError('Mock implementation - not needed for testing');
  }
}
