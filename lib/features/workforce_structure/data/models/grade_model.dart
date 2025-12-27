import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';

class GradeModel {
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

  const GradeModel({
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

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['grade_id'] as int? ?? 0,
      gradeNumber: json['grade_number'] as String? ?? '',
      gradeCategory: json['grade_category'] as String? ?? '',
      step1Salary: (json['step_1_salary'] as num?)?.toDouble() ?? 0.0,
      step2Salary: (json['step_2_salary'] as num?)?.toDouble() ?? 0.0,
      step3Salary: (json['step_3_salary'] as num?)?.toDouble() ?? 0.0,
      step4Salary: (json['step_4_salary'] as num?)?.toDouble() ?? 0.0,
      step5Salary: (json['step_5_salary'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'ACTIVE',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_id': id,
      'grade_number': gradeNumber,
      'grade_category': gradeCategory,
      'step_1_salary': step1Salary,
      'step_2_salary': step2Salary,
      'step_3_salary': step3Salary,
      'step_4_salary': step4Salary,
      'step_5_salary': step5Salary,
      'status': status,
      'description': description,
    };
  }

  Grade toEntity() {
    return Grade(
      id: id,
      gradeNumber: gradeNumber,
      gradeCategory: gradeCategory,
      step1Salary: step1Salary,
      step2Salary: step2Salary,
      step3Salary: step3Salary,
      step4Salary: step4Salary,
      step5Salary: step5Salary,
      status: status,
      description: description,
    );
  }

  factory GradeModel.fromEntity(Grade entity) {
    return GradeModel(
      id: entity.id,
      gradeNumber: entity.gradeNumber,
      gradeCategory: entity.gradeCategory,
      step1Salary: entity.step1Salary,
      step2Salary: entity.step2Salary,
      step3Salary: entity.step3Salary,
      step4Salary: entity.step4Salary,
      step5Salary: entity.step5Salary,
      status: entity.status,
      description: entity.description,
    );
  }
}
