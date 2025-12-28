import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';

/// Grade data model (DTO)
class GradeModel {
  final int gradeId;
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
  final String createdDate;
  final String lastUpdatedBy;
  final String lastUpdatedDate;
  final String lastUpdateLogin;

  const GradeModel({
    required this.gradeId,
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

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      gradeId: json['grade_id'] as int,
      gradeNumber: json['grade_number'] as String,
      gradeCategory: json['grade_category'] as String,
      currencyCode: json['currency_code'] as String,
      step1Salary: (json['step_1_salary'] as num).toDouble(),
      step2Salary: (json['step_2_salary'] as num).toDouble(),
      step3Salary: (json['step_3_salary'] as num).toDouble(),
      step4Salary: (json['step_4_salary'] as num).toDouble(),
      step5Salary: (json['step_5_salary'] as num).toDouble(),
      description: json['description'] as String,
      status: json['status'] as String,
      createdBy: json['created_by'] as String,
      createdDate: json['created_date'] as String,
      lastUpdatedBy: json['last_updated_by'] as String,
      lastUpdatedDate: json['last_updated_date'] as String,
      lastUpdateLogin: json['last_update_login'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_id': gradeId,
      'grade_number': gradeNumber,
      'grade_category': gradeCategory,
      'currency_code': currencyCode,
      'step_1_salary': step1Salary,
      'step_2_salary': step2Salary,
      'step_3_salary': step3Salary,
      'step_4_salary': step4Salary,
      'step_5_salary': step5Salary,
      'description': description,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'last_updated_by': lastUpdatedBy,
      'last_updated_date': lastUpdatedDate,
      'last_update_login': lastUpdateLogin,
    };
  }

  Grade toEntity() {
    return Grade(
      id: gradeId,
      gradeNumber: gradeNumber,
      gradeCategory: gradeCategory,
      currencyCode: currencyCode,
      step1Salary: step1Salary,
      step2Salary: step2Salary,
      step3Salary: step3Salary,
      step4Salary: step4Salary,
      step5Salary: step5Salary,
      description: description,
      status: status,
      createdBy: createdBy,
      createdDate: DateTime.parse(createdDate),
      lastUpdatedBy: lastUpdatedBy,
      lastUpdatedDate: DateTime.parse(lastUpdatedDate),
      lastUpdateLogin: lastUpdateLogin,
    );
  }

  factory GradeModel.fromEntity(Grade entity) {
    return GradeModel(
      gradeId: entity.id,
      gradeNumber: entity.gradeNumber,
      gradeCategory: entity.gradeCategory,
      currencyCode: entity.currencyCode,
      step1Salary: entity.step1Salary,
      step2Salary: entity.step2Salary,
      step3Salary: entity.step3Salary,
      step4Salary: entity.step4Salary,
      step5Salary: entity.step5Salary,
      description: entity.description,
      status: entity.status,
      createdBy: entity.createdBy,
      createdDate: entity.createdDate.toIso8601String(),
      lastUpdatedBy: entity.lastUpdatedBy,
      lastUpdatedDate: entity.lastUpdatedDate.toIso8601String(),
      lastUpdateLogin: entity.lastUpdateLogin,
    );
  }
}
