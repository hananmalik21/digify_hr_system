import '../../domain/domain/models/overtime/overtime_record.dart';
import '../../domain/domain/repositories/overtime_repository.dart';

/// Mock implementation of OvertimeRepository
class OvertimeRepositoryImpl implements OvertimeRepository {
  @override
  Future<List<OvertimeRecord>> getOvertimeRecords({
    String? employeeNumber,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data matching Figma design
    final mockOvertimeRecords = [
      OvertimeRecord(
        name: "Sarah Jonshon",
        employeeId: "EMP-001",
        type: "Regular",
        overtimeHours: "2",
        regularHours: "8",
        date: DateTime(2026, 2, 2),
        requestedDate: DateTime(2026, 2, 2),
        status: "Approved",
        rate: "10",
        amount: "100",
      ),
    ];

    var filtered = mockOvertimeRecords.where((a) {
      return true;
    }).toList();

    return filtered;
  }
}
