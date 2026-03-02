enum OvertimeStatus {
  pending('Pending'),
  approved('Approved'),
  rejected('Rejected');

  final String label;
  const OvertimeStatus(this.label);

  static OvertimeStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return OvertimeStatus.pending;
      case 'APPROVED':
        return OvertimeStatus.approved;
      case 'REJECTED':
        return OvertimeStatus.rejected;
      default:
        return OvertimeStatus.pending;
    }
  }

  @override
  String toString() => label;
}
