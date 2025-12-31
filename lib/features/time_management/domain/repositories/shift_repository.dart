import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';

/// Repository interface for shift operations
abstract class ShiftRepository {
  /// Gets paginated list of shifts
  ///
  /// [search] - Optional search query
  /// [isActive] - Optional filter by active status
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Throws [AppException] if the operation fails
  Future<PaginatedShifts> getShifts({
    String? search,
    bool? isActive,
    int page = 1,
    int pageSize = 10,
  });

  /// Gets all active shifts
  ///
  /// Throws [AppException] if the operation fails
  Future<List<ShiftOverview>> getActiveShifts();

  /// Gets shift by ID
  ///
  /// Throws [AppException] if the operation fails
  Future<Shift> getShiftById(int shiftId);

  /// Creates a new shift
  ///
  /// Throws [AppException] if the operation fails
  Future<Shift> createShift(Map<String, dynamic> shiftData);

  /// Updates an existing shift
  ///
  /// Throws [AppException] if the operation fails
  Future<Shift> updateShift(int shiftId, Map<String, dynamic> shiftData);

  /// Deletes a shift
  ///
  /// [hard] - If true, permanently deletes. If false, soft deletes.
  /// Throws [AppException] if the operation fails
  Future<void> deleteShift(int shiftId, {bool hard = true});

  /// Assigns a shift to an employee
  ///
  /// Throws [AppException] if the operation fails
  Future<void> assignShiftToEmployee(int shiftId, int employeeId);

  /// Removes shift assignment from an employee
  ///
  /// Throws [AppException] if the operation fails
  Future<void> removeShiftFromEmployee(int shiftId, int employeeId);
}
