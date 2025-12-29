import 'dart:developer';

import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';

/// Simple parent unit model for dropdown/tree display
class ParentUnitDto {
  final int id;
  final String name;

  /// ✅ Parent LEVEL_CODE (e.g. COMPANY, BUSINESS_UNIT, DEPARTMENT)
  final String? level;

  const ParentUnitDto({
    required this.id,
    required this.name,
    this.level,
  });

  factory ParentUnitDto.fromJson(Map<String, dynamic> json) {
    log("parent is ${json}");
    return ParentUnitDto(
      id: (json['id'] as num?)?.toInt() ??
          0,
      name: json['name'] as String? ??
          '',
      level: json['level'] as String? ??""
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (level != null) 'level': level,
  };
}


/// DTO for Organization Structure Level
class OrgStructureLevelDto {
  final int orgUnitId;
  final int orgStructureId;
  final int enterpriseId;
  final String levelCode;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;

  /// Raw FK (still useful internally)
  final int? parentOrgUnitId;

  /// ✅ New: parent object for UI (id + name)
  final ParentUnitDto? parentUnit;

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
    this.parentUnit,
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
    // parent_org_unit_id (FK)


    final parentId = (json['parent_org_unit_id'] as num?)?.toInt() ??
        (json['parentOrgUnitId'] as num?)?.toInt();

    // ✅ parent_unit object (preferred)
    ParentUnitDto? parentUnit;
    final parentUnitJson = json['parent_unit'];
    if (parentUnitJson is Map<String, dynamic>) {
      parentUnit = ParentUnitDto.fromJson(parentUnitJson);
      log("parent is ${parentUnit.name}");

    } else {
      // backward compatibility if API sends parent_id / parent_name
      final fallbackParentId = (json['parent_org_unit_id'] as num?)?.toInt();
      final fallbackParentName = json['parent_name'] as String?;
      if (fallbackParentId != null) {
        parentUnit = ParentUnitDto(
          id: fallbackParentId,
          name: fallbackParentName ?? '',
        );
      }
    }

    return OrgStructureLevelDto(
      orgUnitId: (json['org_unit_id'] as num?)?.toInt() ??
          (json['orgUnitId'] as num?)?.toInt() ??  json["id"]??
          0,
      orgStructureId: (json['org_structure_id'] as num?)?.toInt() ??
          (json['orgStructureId'] as num?)?.toInt() ??
          0,
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ??
          (json['enterpriseId'] as num?)?.toInt() ??
          0,
      levelCode: json['level_code'] as String? ??
          json['levelCode'] as String? ??  json["level"]??
          '',
      orgUnitCode: json['org_unit_code'] as String? ??
          json['orgUnitCode'] as String? ??
          '',
      orgUnitNameEn: json['org_unit_name_en'] as String? ??
          json['orgUnitNameEn'] as String? ??  json["name"]??
          '',
      orgUnitNameAr: json['org_unit_name_ar'] as String? ??
          json['orgUnitNameAr'] as String? ??
          '',
      parentOrgUnitId: parentId,
      parentUnit: parentUnit,
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
      parentUnit: parentUnit,

      // ✅ if you want to show parent name in UI, you can use parentUnit?.name in widgets
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

      // keep FK if present
      if (parentOrgUnitId != null) 'parent_org_unit_id': parentOrgUnitId,

      // ✅ send parent object if present (optional)
      if (parentUnit != null) 'parent_unit': parentUnit!.toJson(),

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
