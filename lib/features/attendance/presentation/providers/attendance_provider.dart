import 'package:digify_hr_system/features/attendance/domain/models/attendance_record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceState {
  final DateTime fromDate;
  final DateTime toDate;
  final String employeeNumber;
  final int totalStaff;
  final int present;
  final int late_count;
  final int absent;
  final int halfDay;
  final int onLeave;
  final bool isLoading;
  final List<AttendanceRecord> records;
  final int currentPage;
  final int pageSize;
  final int totalItems;

  const AttendanceState({
    required this.fromDate,
    required this.toDate,
    this.employeeNumber = '',
    this.totalStaff = 3,
    this.present = 3,
    this.late_count = 1,
    this.absent = 1,
    this.halfDay = 0,
    required this.onLeave,
    this.isLoading = false,
    this.records = const [],
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
  });

  AttendanceState copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    String? employeeNumber,
    int? totalStaff,
    int? present,
    int? late_count,
    int? absent,
    int? halfDay,
    int? onLeave,
    bool? isLoading,
    List<AttendanceRecord>? records,
    int? currentPage,
    int? pageSize,
    int? totalItems,
  }) {
    return AttendanceState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      totalStaff: totalStaff ?? this.totalStaff,
      present: present ?? this.present,
      late_count: late_count ?? this.late_count,
      absent: absent ?? this.absent,
      halfDay: halfDay ?? this.halfDay,
      onLeave: onLeave ?? this.onLeave,
      isLoading: isLoading ?? this.isLoading,
      records: records ?? this.records,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier()
      : super(AttendanceState(
          fromDate: DateTime(2026, 2, 2),
          toDate: DateTime(2026, 2, 2),
          totalStaff: 9,
          present: 3,
          late_count: 1,
          absent: 1,
          halfDay: 0,
          onLeave: 1,
          records: _mockRecords,
          totalItems: 9,
        ));

  static final List<AttendanceRecord> _mockRecords = [
    AttendanceRecord(
      employeeName: 'Ahmed Al-Mutairi',
      employeeId: 'EMP-001',
      departmentName: 'IT',
      date: DateTime(2026, 2, 2),
      checkIn: '08:05',
      checkOut: '17:10',
      status: 'Present',
      avatarInitials: 'AA',
    ),
    AttendanceRecord(
      employeeName: 'Fatima Al-Sabah',
      employeeId: 'EMP-002',
      departmentName: 'HR',
      date: DateTime(2026, 2, 2),
      checkIn: '08:30',
      checkOut: '16:45',
      status: 'Late',
      avatarInitials: 'FA',
    ),
    AttendanceRecord(
      employeeName: 'Mohammed Al-Rashid',
      employeeId: 'EMP-003',
      departmentName: 'Finance',
      date: DateTime(2026, 2, 2),
      checkIn: '-',
      checkOut: '-',
      status: 'Absent',
      avatarInitials: 'MA',
    ),
    AttendanceRecord(
      employeeName: 'Sara Al-Kandari',
      employeeId: 'EMP-004',
      departmentName: 'IT',
      date: DateTime(2026, 2, 2),
      checkIn: '07:55',
      checkOut: '15:30',
      status: 'Early',
      avatarInitials: 'SA',
    ),
    AttendanceRecord(
      employeeName: 'Ali Al-Ajmi',
      employeeId: 'EMP-005',
      departmentName: 'Operations',
      date: DateTime(2026, 2, 2),
      checkIn: '-',
      checkOut: '-',
      status: 'On Leave',
      avatarInitials: 'AA',
    ),
    AttendanceRecord(
      employeeName: 'Noor Al-Shammari',
      employeeId: 'EMP-006',
      departmentName: 'Sales',
      date: DateTime(2026, 2, 2),
      checkIn: '09:00',
      checkOut: '17:00',
      status: 'Official Work',
      avatarInitials: 'NA',
    ),
    AttendanceRecord(
      employeeName: 'Khaled Al-Ibrahim',
      employeeId: 'EMP-007',
      departmentName: 'IT',
      date: DateTime(2026, 2, 2),
      checkIn: '06:00',
      checkOut: '14:00',
      status: 'Business Trip',
      avatarInitials: 'KA',
    ),
    AttendanceRecord(
      employeeName: 'Yousef Al-Mutawa',
      employeeId: 'EMP-008',
      departmentName: 'Security',
      date: DateTime(2026, 2, 2),
      checkIn: '22:10',
      checkOut: '06:05',
      status: 'Present',
      avatarInitials: 'YA',
    ),
    AttendanceRecord(
      employeeName: 'Layla Al-Fahad',
      employeeId: 'EMP-009',
      departmentName: 'Operations',
      date: DateTime(2026, 2, 2),
      checkIn: '22:55',
      checkOut: '07:10',
      status: 'Present',
      avatarInitials: 'LA',
    ),
  ];

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size, currentPage: 1);
  }

  void setFromDate(DateTime date) {
    state = state.copyWith(fromDate: date);
  }

  void setToDate(DateTime date) {
    state = state.copyWith(toDate: date);
  }

  void setEmployeeNumber(String number) {
    state = state.copyWith(employeeNumber: number);
  }
}

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  return AttendanceNotifier();
});
