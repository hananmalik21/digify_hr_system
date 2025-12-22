/// Job Level domain model
class JobLevel {
  final String nameEnglish;
  final String code;
  final String description;
  final String gradeRange;
  final int totalPositions;
  final bool isActive;
  final String jobFamily;
  final int filledPositions;
  final double fillRate;
  final String minSalary;
  final String maxSalary;
  final String medianSalary;
  final String averageTenure;
  final String talentStatus;
  final List<String> responsibilities;
  final List<String> progressionLevels;

  const JobLevel({
    required this.nameEnglish,
    required this.code,
    required this.description,
    required this.gradeRange,
    required this.totalPositions,
    required this.isActive,
    required this.jobFamily,
    required this.filledPositions,
    required this.fillRate,
    required this.minSalary,
    required this.maxSalary,
    required this.medianSalary,
    required this.averageTenure,
    required this.talentStatus,
    required this.responsibilities,
    required this.progressionLevels,
  });

  int get vacantPositions => totalPositions - filledPositions;

  JobLevel copyWith({
    String? nameEnglish,
    String? code,
    String? description,
    String? gradeRange,
    int? totalPositions,
    bool? isActive,
    String? jobFamily,
    int? filledPositions,
    double? fillRate,
    String? minSalary,
    String? maxSalary,
    String? medianSalary,
    String? averageTenure,
    String? talentStatus,
    List<String>? responsibilities,
    List<String>? progressionLevels,
  }) {
    return JobLevel(
      nameEnglish: nameEnglish ?? this.nameEnglish,
      code: code ?? this.code,
      description: description ?? this.description,
      gradeRange: gradeRange ?? this.gradeRange,
      totalPositions: totalPositions ?? this.totalPositions,
      isActive: isActive ?? this.isActive,
      jobFamily: jobFamily ?? this.jobFamily,
      filledPositions: filledPositions ?? this.filledPositions,
      fillRate: fillRate ?? this.fillRate,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      medianSalary: medianSalary ?? this.medianSalary,
      averageTenure: averageTenure ?? this.averageTenure,
      talentStatus: talentStatus ?? this.talentStatus,
      responsibilities: responsibilities ?? this.responsibilities,
      progressionLevels: progressionLevels ?? this.progressionLevels,
    );
  }
}

