/// Position domain model
/// Represents a job position within the workforce structure
class Position {
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

  const Position({
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
  });

  factory Position.empty() => const Position(
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
  }) {
    return Position(
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
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Position && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return 'Position(code: $code, titleEnglish: $titleEnglish, titleArabic: $titleArabic)';
  }
}

