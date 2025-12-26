import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';

/// DTO for Organization Structure Level
class OrgStructureLevelDto {
  final int orgUnitId;
  final int orgStructureId;
  final int enterpriseId;
  final String levelCode;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final int? parentOrgUnitId;
  final String isActive;
  final String? managerName;
  final String? managerEmail;
  final String? managerPhone;
  final String? location;
  final String? city;
  final String? address;
  final String? description;
  final String? createdBy;
  final String? createdDate;
  final String? lastUpdatedBy;
  final String? lastUpdatedDate;
  final String? lastUpdateLogin;

  const OrgStructureLevelDto({
    required this.orgUnitId,
    required this.orgStructureId,
    required this.enterpriseId,
    required this.levelCode,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    this.parentOrgUnitId,
    required this.isActive,
    this.managerName,
    this.managerEmail,
    this.managerPhone,
    this.location,
    this.city,
    this.address,
    this.description,
    this.createdBy,
    this.createdDate,
    this.lastUpdatedBy,
    this.lastUpdatedDate,
    this.lastUpdateLogin,
  });

  /// Creates DTO from JSON
  factory OrgStructureLevelDto.fromJson(Map<String, dynamic> json) {
    return OrgStructureLevelDto(
      orgUnitId: (json['org_unit_id'] as num?)?.toInt() ??
          (json['orgUnitId'] as num?)?.toInt() ??
          0,
      orgStructureId: (json['org_structure_id'] as num?)?.toInt() ??
          (json['orgStructureId'] as num?)?.toInt() ??
          0,
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ??
          (json['enterpriseId'] as num?)?.toInt() ??
          0,
      levelCode: json['level_code'] as String? ??
          json['levelCode'] as String? ??
          '',
      orgUnitCode: json['org_unit_code'] as String? ??
          json['orgUnitCode'] as String? ??
          '',
      orgUnitNameEn: json['org_unit_name_en'] as String? ??
          json['orgUnitNameEn'] as String? ??
          '',
      orgUnitNameAr: json['org_unit_name_ar'] as String? ??
          json['orgUnitNameAr'] as String? ??
          '',
      parentOrgUnitId: (json['parent_org_unit_id'] as num?)?.toInt() ??
          (json['parentOrgUnitId'] as num?)?.toInt(),
      isActive: json['is_active'] as String? ??
          json['isActive'] as String? ??
          'N',
      managerName: json['manager_name'] as String? ??
          json['managerName'] as String?,
      managerEmail: json['manager_email'] as String? ??
          json['managerEmail'] as String?,
      managerPhone: json['manager_phone'] as String? ??
          json['managerPhone'] as String?,
      location: json['location'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      createdBy: json['created_by'] as String? ??
          json['createdBy'] as String?,
      createdDate: json['created_date'] as String? ??
          json['createdDate'] as String?,
      lastUpdatedBy: json['last_updated_by'] as String? ??
          json['lastUpdatedBy'] as String?,
      lastUpdatedDate: json['last_updated_date'] as String? ??
          json['lastUpdatedDate'] as String?,
      lastUpdateLogin: json['last_update_login'] as String? ??
          json['lastUpdateLogin'] as String?,
    );
  }

  /// Converts DTO to domain model
  OrgStructureLevel toDomain() {
    return OrgStructureLevel(
      orgUnitId: orgUnitId,
      orgStructureId: orgStructureId,
      enterpriseId: enterpriseId,
      levelCode: levelCode,
      orgUnitCode: orgUnitCode,
      orgUnitNameEn: orgUnitNameEn,
      orgUnitNameAr: orgUnitNameAr,
      parentOrgUnitId: parentOrgUnitId,
      isActive: isActive.toUpperCase() == 'Y',
      managerName: managerName ?? '',
      managerEmail: managerEmail ?? '',
      managerPhone: managerPhone ?? '',
      location: location ?? '',
      city: city ?? '',
      address: address ?? '',
      description: description ?? '',
      createdBy: createdBy ?? '',
      createdDate: createdDate ?? '',
      lastUpdatedBy: lastUpdatedBy ?? '',
      lastUpdatedDate: lastUpdatedDate ?? '',
      lastUpdateLogin: lastUpdateLogin ?? '',
    );
  }

  /// Creates JSON from DTO
  Map<String, dynamic> toJson() {
    return {
      'org_unit_id': orgUnitId,
      'org_structure_id': orgStructureId,
      'enterprise_id': enterpriseId,
      'level_code': levelCode,
      'org_unit_code': orgUnitCode,
      'org_unit_name_en': orgUnitNameEn,
      'org_unit_name_ar': orgUnitNameAr,
      if (parentOrgUnitId != null) 'parent_org_unit_id': parentOrgUnitId,
      'is_active': isActive,
      if (managerName != null) 'manager_name': managerName,
      if (managerEmail != null) 'manager_email': managerEmail,
      if (managerPhone != null) 'manager_phone': managerPhone,
      if (location != null) 'location': location,
      if (city != null) 'city': city,
      if (address != null) 'address': address,
      if (description != null) 'description': description,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
      if (lastUpdatedBy != null) 'last_updated_by': lastUpdatedBy,
      if (lastUpdatedDate != null) 'last_updated_date': lastUpdatedDate,
      if (lastUpdateLogin != null) 'last_update_login': lastUpdateLogin,
    };
  }
}

