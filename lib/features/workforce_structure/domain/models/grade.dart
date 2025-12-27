class Grade {
  final int id;
  final String gradeNumber;
  final String gradeCategory;
  final double step1Salary;
  final double step2Salary;
  final double step3Salary;
  final double step4Salary;
  final double step5Salary;
  final String status;
  final String description;

  const Grade({
    required this.id,
    required this.gradeNumber,
    required this.gradeCategory,
    required this.step1Salary,
    required this.step2Salary,
    required this.step3Salary,
    required this.step4Salary,
    required this.step5Salary,
    required this.status,
    required this.description,
  });

  bool get isActive => status == 'ACTIVE';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Grade && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
