/// Grade domain model (Entity)
class Grade {
  final int id;
  final String gradeNumber;
  final String gradeCategory;
  final String currencyCode;
  final double step1Salary;
  final double step2Salary;
  final double step3Salary;
  final double step4Salary;
  final double step5Salary;
  final String description;
  final String status;
  final String createdBy;
  final DateTime createdDate;
  final String lastUpdatedBy;
  final DateTime lastUpdatedDate;
  final String lastUpdateLogin;

  const Grade({
    required this.id,
    required this.gradeNumber,
    required this.gradeCategory,
    required this.currencyCode,
    required this.step1Salary,
    required this.step2Salary,
    required this.step3Salary,
    required this.step4Salary,
    required this.step5Salary,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.lastUpdatedBy,
    required this.lastUpdatedDate,
    required this.lastUpdateLogin,
  });

  bool get isActive => status == 'ACTIVE';

  String get gradeLabel => 'Grade $gradeNumber';

  List<GradeStep> get steps => [
    GradeStep(step: 1, salary: step1Salary),
    GradeStep(step: 2, salary: step2Salary),
    GradeStep(step: 3, salary: step3Salary),
    GradeStep(step: 4, salary: step4Salary),
    GradeStep(step: 5, salary: step5Salary),
  ];

  Grade copyWith({
    int? id,
    String? gradeNumber,
    String? gradeCategory,
    String? currencyCode,
    double? step1Salary,
    double? step2Salary,
    double? step3Salary,
    double? step4Salary,
    double? step5Salary,
    String? description,
    String? status,
    String? createdBy,
    DateTime? createdDate,
    String? lastUpdatedBy,
    DateTime? lastUpdatedDate,
    String? lastUpdateLogin,
  }) {
    return Grade(
      id: id ?? this.id,
      gradeNumber: gradeNumber ?? this.gradeNumber,
      gradeCategory: gradeCategory ?? this.gradeCategory,
      currencyCode: currencyCode ?? this.currencyCode,
      step1Salary: step1Salary ?? this.step1Salary,
      step2Salary: step2Salary ?? this.step2Salary,
      step3Salary: step3Salary ?? this.step3Salary,
      step4Salary: step4Salary ?? this.step4Salary,
      step5Salary: step5Salary ?? this.step5Salary,
      description: description ?? this.description,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
      lastUpdateLogin: lastUpdateLogin ?? this.lastUpdateLogin,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Grade && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class GradeStep {
  final int step;
  final double salary;

  const GradeStep({required this.step, required this.salary});
}
