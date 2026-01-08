import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';

/// Position domain model
/// Represents a job position within the workforce structure
class Position {
  final String id;
  final String code;
  final String titleEnglish;
  final String titleArabic;
  final String department;
  final String jobFamily;
  final String level;
  final String grade;
  final String step;
  final String? reportsTo;
  final String division;
  final String costCenter;
  final String location;
  final String budgetedMin;
  final String budgetedMax;
  final String actualAverage;
  final int headcount;
  final int filled;
  final int vacant;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Domain references for pre-selection in forms
  final JobFamily? jobFamilyRef;
  final JobLevel? jobLevelRef;
  final Grade? gradeRef;
  final String? orgUnitId;
  final Map<String, String>? orgPathIds;
  final Map<String, OrgUnit>? orgPathRefs;

  const Position({
    required this.id,
    required this.code,
    required this.titleEnglish,
    required this.titleArabic,
    required this.department,
    required this.jobFamily,
    required this.level,
    required this.grade,
    required this.step,
    this.reportsTo,
    required this.division,
    required this.costCenter,
    required this.location,
    required this.budgetedMin,
    required this.budgetedMax,
    required this.actualAverage,
    required this.headcount,
    required this.filled,
    required this.vacant,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.jobFamilyRef,
    this.jobLevelRef,
    this.gradeRef,
    this.orgUnitId,
    this.orgPathIds,
    this.orgPathRefs,
  });

  factory Position.empty() => const Position(
    id: '',
    code: '',
    titleEnglish: '',
    titleArabic: '',
    department: '',
    jobFamily: '',
    level: '',
    grade: '',
    step: '',
    reportsTo: '',
    division: '',
    costCenter: '',
    location: '',
    budgetedMin: '',
    budgetedMax: '',
    actualAverage: '',
    headcount: 0,
    filled: 0,
    vacant: 0,
    isActive: true,
  );

  /// Calculate vacancy status
  bool get hasVacancy => vacant > 0;

  /// Calculate if position is fully filled
  bool get isFullyFilled => filled == headcount;

  /// Calculate fill percentage
  double get fillPercentage => headcount > 0 ? (filled / headcount) * 100 : 0;

  Position copyWith({
    String? id,
    String? code,
    String? titleEnglish,
    String? titleArabic,
    String? department,
    String? jobFamily,
    String? level,
    String? grade,
    String? step,
    String? reportsTo,
    String? division,
    String? costCenter,
    String? location,
    String? budgetedMin,
    String? budgetedMax,
    String? actualAverage,
    int? headcount,
    int? filled,
    int? vacant,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    JobFamily? jobFamilyRef,
    JobLevel? jobLevelRef,
    Grade? gradeRef,
    String? orgUnitId,
    Map<String, String>? orgPathIds,
    Map<String, OrgUnit>? orgPathRefs,
  }) {
    return Position(
      id: id ?? this.id,
      code: code ?? this.code,
      titleEnglish: titleEnglish ?? this.titleEnglish,
      titleArabic: titleArabic ?? this.titleArabic,
      department: department ?? this.department,
      jobFamily: jobFamily ?? this.jobFamily,
      level: level ?? this.level,
      grade: grade ?? this.grade,
      step: step ?? this.step,
      reportsTo: reportsTo ?? this.reportsTo,
      division: division ?? this.division,
      costCenter: costCenter ?? this.costCenter,
      location: location ?? this.location,
      budgetedMin: budgetedMin ?? this.budgetedMin,
      budgetedMax: budgetedMax ?? this.budgetedMax,
      actualAverage: actualAverage ?? this.actualAverage,
      headcount: headcount ?? this.headcount,
      filled: filled ?? this.filled,
      vacant: vacant ?? this.vacant,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      jobFamilyRef: jobFamilyRef ?? this.jobFamilyRef,
      jobLevelRef: jobLevelRef ?? this.jobLevelRef,
      gradeRef: gradeRef ?? this.gradeRef,
      orgUnitId: orgUnitId ?? this.orgUnitId,
      orgPathIds: orgPathIds ?? this.orgPathIds,
      orgPathRefs: orgPathRefs ?? this.orgPathRefs,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Position && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Position(id: $id, code: $code, titleEnglish: $titleEnglish, titleArabic: $titleArabic)';
  }
}
