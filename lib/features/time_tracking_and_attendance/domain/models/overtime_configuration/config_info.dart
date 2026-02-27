class ConfigInfo {
  final String otConfigId;
  final String configName;
  final String effectiveStartDate;
  final String effectiveEndDate;

  ConfigInfo({
    this.otConfigId = '',
    this.configName = '',
    this.effectiveStartDate = '',
    this.effectiveEndDate = '',
  });

  ConfigInfo copyWith({
    String? otConfigId,
    String? configName,
    String? effectiveStartDate,
    String? effectiveEndDate,
  }) {
    return ConfigInfo(
      otConfigId: otConfigId ?? this.otConfigId,
      configName: configName ?? this.configName,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
      effectiveEndDate: effectiveEndDate ?? this.effectiveEndDate,
    );
  }

  factory ConfigInfo.fromJson(Map<String, dynamic> json) {
    return ConfigInfo(
      otConfigId: json['ot_config_id']?.toString() ?? '',
      configName: json['config_name']?.toString() ?? '',
      effectiveStartDate: json['effective_start_date']?.toString() ?? '',
      effectiveEndDate: json['effective_end_date']?.toString() ?? '',
    );
  }
}
