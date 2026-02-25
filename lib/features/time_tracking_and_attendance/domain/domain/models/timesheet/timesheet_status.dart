/// Timesheet status enum matching Figma design
enum TimesheetStatus {
  draft,
  submitted,
  approved,
  rejected,
}

extension TimesheetStatusExtension on TimesheetStatus {
  String get displayName {
    switch (this) {
      case TimesheetStatus.draft:
        return 'Draft';
      case TimesheetStatus.submitted:
        return 'Submitted';
      case TimesheetStatus.approved:
        return 'Approved';
      case TimesheetStatus.rejected:
        return 'Rejected';
    }
  }

  static TimesheetStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return TimesheetStatus.draft;
      case 'submitted':
        return TimesheetStatus.submitted;
      case 'approved':
        return TimesheetStatus.approved;
      case 'rejected':
        return TimesheetStatus.rejected;
      default:
        return TimesheetStatus.draft;
    }
  }

  String toApiString() {
    switch (this) {
      case TimesheetStatus.draft:
        return 'draft';
      case TimesheetStatus.submitted:
        return 'submitted';
      case TimesheetStatus.approved:
        return 'approved';
      case TimesheetStatus.rejected:
        return 'rejected';
    }
  }
}

