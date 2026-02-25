import '../../domain/models/overtime/overtime_record.dart';
import '../../domain/repositories/overtime_repository.dart';

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
        employeeId: "EMP-001",
        date: DateTime(2026, 2, 2),
        requestedDate: DateTime(2026, 2, 2),
        amount: "100",
        employeeDetail: EmployeeDetail(
          name: "Sarah Jonshon",
          employeeId: "EMP-001",
          position: "Software Engineer",
          department: "IT",
          lineManager: "John Doe",
        ),
        overtimeDetail: OvertimeDetail(
          type: "Regular",
          overtimeHours: "2",
          regularHours: "8",
          rate: "10",
          amount: "100",
        ),
        approvalInformation: ApprovalInformation(
          status: "Approved",
          byUser: "John Doe",
          date: DateTime(2026, 2, 2),
          reason: "Approved",
        ),
      ),
      OvertimeRecord(
        employeeId: "EMP-002",
        date: DateTime(2026, 2, 2),
        requestedDate: DateTime(2026, 2, 2),
        amount: "100",
        employeeDetail: EmployeeDetail(
          name: "Vivian",
          employeeId: "EMP-002",
          position: "Software Engineer",
          department: "IT",
          lineManager: "John Doe",
        ),
        overtimeDetail: OvertimeDetail(
          type: "Regular",
          overtimeHours: "2",
          regularHours: "8",
          rate: "10",
          amount: "100",
        ),
        approvalInformation: ApprovalInformation(
          status: "Approved",
          byUser: "John Doe",
          date: DateTime(2026, 2, 2),
          reason: "Approved",
        ),
      ),
      OvertimeRecord(
        employeeId: "EMP-003",
        date: DateTime(2026, 2, 2),
        requestedDate: DateTime(2026, 2, 2),
        amount: "100",
        employeeDetail: EmployeeDetail(
          name: "Sara",
          employeeId: "EMP-003",
          position: "Software Engineer",
          department: "IT",
          lineManager: "John Doe",
        ),
        overtimeDetail: OvertimeDetail(
          type: "Regular",
          overtimeHours: "2",
          regularHours: "8",
          rate: "10",
          amount: "100",
        ),
        approvalInformation: ApprovalInformation(
          status: "Approved",
          byUser: "John Doe",
          date: DateTime(2026, 2, 2),
          reason: "Approved",
        ),
      ),
    ];

    var filtered = mockOvertimeRecords.where((a) {
      return true;
    }).toList();

    return filtered;
  }
}
