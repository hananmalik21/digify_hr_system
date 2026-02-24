class OvertimeRecord {
  final String name;
  final String employeeId;
  final DateTime date;
  final DateTime requestedDate;
  final String type;
  final String overtimeHours;
  final String regularHours;
  final String rate;
  final String status;
  final String amount;

  OvertimeRecord({
    required this.name,
    required this.employeeId,
    required this.date,
    required this.requestedDate,
    required this.type,
    required this.overtimeHours,
    required this.regularHours,
    required this.rate,
    required this.status,
    required this.amount,
  });

  static empty() {
    return OvertimeRecord(
      name: "",
      employeeId: "",
      date: DateTime.now(),
      requestedDate: DateTime.now(),
      type: "",
      overtimeHours: "",
      regularHours: "",
      rate: "",
      status: "",
      amount: "",
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
  }) {
    return OvertimeRecord(
      name: name ?? this.name,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      requestedDate: requestedDate ?? this.requestedDate,
      type: type ?? this.type,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      regularHours: regularHours ?? this.regularHours,
      rate: rate ?? this.rate,
      status: status ?? this.status,
      amount: amount ?? this.amount,
    );
  }
}
