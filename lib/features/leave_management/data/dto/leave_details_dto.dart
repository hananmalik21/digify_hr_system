class LeaveDetailsData {
  const LeaveDetailsData({required this.employeeData, required this.summaryByLeaveType, required this.transactions});

  final Map<String, dynamic> employeeData;
  final Map<String, Map<String, dynamic>> summaryByLeaveType;
  final List<Map<String, dynamic>> transactions;
}
