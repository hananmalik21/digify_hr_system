class OvertimeRecord {
  final String employeeId;
  final DateTime date;
  final DateTime requestedDate;
  final String amount;
  final EmployeeDetail? employeeDetail;
  final OvertimeDetail? overtimeDetail;
  final ApprovalInformation? approvalInformation;

  OvertimeRecord({
    required this.employeeId,
    required this.date,
    required this.requestedDate,

    required this.amount,
    required this.employeeDetail,
    required this.overtimeDetail,
    required this.approvalInformation,
  });

  static empty() {
    return OvertimeRecord(
      employeeId: "",
      date: DateTime.now(),
      requestedDate: DateTime.now(),

      amount: "",
      employeeDetail: null,
      overtimeDetail: null,
      approvalInformation: null,
    );
  }

  OvertimeRecord copyWith({
    String? name,
    String? employeeId,
    DateTime? date,
    DateTime? requestedDate,
    String? type,
    String? overtimeHours,
    String? regularHours,
    String? rate,
    String? status,
    String? amount,
    EmployeeDetail? employeeDetail,
    OvertimeDetail? overtimeDetail,
    ApprovalInformation? approvalInformation,
  }) {
    return OvertimeRecord(
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      requestedDate: requestedDate ?? this.requestedDate,
      amount: amount ?? this.amount,
      employeeDetail: employeeDetail ?? this.employeeDetail,
      overtimeDetail: overtimeDetail ?? this.overtimeDetail,
      approvalInformation: approvalInformation ?? this.approvalInformation,
    );
  }
}

class EmployeeDetail {
  final String name;
  final String employeeId;
  final String position;
  final String department;
  final String lineManager;

  EmployeeDetail({
    required this.name,
    required this.employeeId,
    required this.position,
    required this.department,
    required this.lineManager,
  });

  static empty() {
    return EmployeeDetail(
      name: "",
      employeeId: "",
      position: "",
      department: "",
      lineManager: "",
    );
  }

  EmployeeDetail copyWith({
    String? name,
    String? employeeId,
    String? position,
    String? department,
    String? lineManager,
  }) {
    return EmployeeDetail(
      name: name ?? this.name,
      employeeId: employeeId ?? this.employeeId,
      position: position ?? this.position,
      department: department ?? this.department,
      lineManager: lineManager ?? this.lineManager,
    );
  }
}

class OvertimeDetail {
  final String overtimeHours;
  final String regularHours;
  final String type;
  final String rate;
  final String amount;

  OvertimeDetail({
    required this.overtimeHours,
    required this.regularHours,
    required this.type,

    required this.rate,
    required this.amount,
  });

  static empty() {
    return OvertimeDetail(
      overtimeHours: "",
      regularHours: "",
      type: "",
      rate: "",
      amount: "",
    );
  }

  OvertimeDetail copyWith({
    String? overtimeHours,
    String? regularHours,
    String? type,
    String? rate,
    String? amount,
  }) {
    return OvertimeDetail(
      overtimeHours: overtimeHours ?? this.overtimeHours,
      regularHours: regularHours ?? this.regularHours,
      type: type ?? this.type,
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
    );
  }
}

class ApprovalInformation {
  final String status;
  final String byUser;
  final DateTime? date;
  final String reason;

  ApprovalInformation({
    required this.status,
    required this.byUser,
    this.date,
    required this.reason,
  });

  static empty() {
    return ApprovalInformation(status: "", byUser: "", date: null, reason: "");
  }

  ApprovalInformation copyWith({
    String? status,
    String? byUser,
    DateTime? date,
    String? reason,
  }) {
    return ApprovalInformation(
      status: status ?? this.status,
      byUser: byUser ?? this.byUser,
      date: date ?? this.date,
      reason: reason ?? this.reason,
    );
  }
}
