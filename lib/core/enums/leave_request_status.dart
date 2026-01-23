enum LeaveRequestStatus {
  submitted('SUBMITTED'),
  withdrawn('WITHDRAWN'),
  approved('APPROVED'),
  rejected('REJECTED');

  final String value;
  const LeaveRequestStatus(this.value);

  static LeaveRequestStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'SUBMITTED':
        return LeaveRequestStatus.submitted;
      case 'WITHDRAWN':
        return LeaveRequestStatus.withdrawn;
      case 'APPROVED':
        return LeaveRequestStatus.approved;
      case 'REJECTED':
        return LeaveRequestStatus.rejected;
      default:
        return LeaveRequestStatus.submitted;
    }
  }

  @override
  String toString() => value;
}
