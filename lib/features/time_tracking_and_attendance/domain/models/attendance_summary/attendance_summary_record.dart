class AttendanceSummaryRecord {
  final String employeeName;
  final String date;
  final String checkIn;
  final String checkOut;
  final String hours;
  final String overtime;
  final String status;

  AttendanceSummaryRecord({
    required this.employeeName,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.hours,
    required this.overtime,
    required this.status,
  });

  factory AttendanceSummaryRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryRecord(
      employeeName: json['employeeName'],
      date: json['date'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      hours: json['hours'],
      overtime: json['overtime'],
      status: json['status'],
    );
  }
}
