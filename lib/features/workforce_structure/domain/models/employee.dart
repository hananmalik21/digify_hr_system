class Employee {
  final int id;
  final String guid;
  final int enterpriseId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? firstNameAr;
  final String? middleNameAr;
  final String? lastNameAr;
  final String email;
  final String? employeeNumber;
  final String? phoneNumber;
  final String? mobileNumber;
  final DateTime? dateOfBirth;
  final String status;
  final bool isActive;
  final DateTime createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  const Employee({
    required this.id,
    required this.guid,
    required this.enterpriseId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.firstNameAr,
    this.middleNameAr,
    this.lastNameAr,
    required this.email,
    this.employeeNumber,
    this.phoneNumber,
    this.mobileNumber,
    this.dateOfBirth,
    required this.status,
    required this.isActive,
    required this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  String get fullName => [firstName, middleName, lastName].where((n) => n != null && n.isNotEmpty).join(' ').trim();

  String get fullNameAr =>
      [firstNameAr, middleNameAr, lastNameAr].where((n) => n != null && n.isNotEmpty).join(' ').trim();
}
