enum SystemUserStatus { active, locked }

class SystemUser {
  final int id;
  final String name;
  final String email;
  final String employeeNumber;
  final String department;
  final String designation;
  final List<String> roles;
  final SystemUserStatus status;
  final bool is2FAEnabled;

  SystemUser({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeNumber,
    required this.department,
    required this.designation,
    required this.roles,
    required this.status,
    required this.is2FAEnabled,
  });

  String get initials {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
