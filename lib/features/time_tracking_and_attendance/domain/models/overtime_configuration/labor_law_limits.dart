class LaborLawLimit {
  final String id;
  final String maxDailyOvertime;
  final String maxAnnualOvertime;
  final String minRestPeriod;

  LaborLawLimit({
    this.id = '',
    this.maxDailyOvertime = '2',
    this.maxAnnualOvertime = '40',
    this.minRestPeriod = '11',
  });

  factory LaborLawLimit.fromJson(Map<String, dynamic> json) {
    return LaborLawLimit(
      id: json['ot_labor_limit_id']?.toString() ?? '',
      maxDailyOvertime: json['max_daily_overtime_hours']?.toString() ?? '2',
      maxAnnualOvertime: json['max_annual_overtime_hours']?.toString() ?? '40',
      minRestPeriod: json['min_rest_period_hours']?.toString() ?? '11',
    );
  }
}
