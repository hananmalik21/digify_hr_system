import 'package:digify_hr_system/features/enterprise_structure/data/dto/org_structure_level_dto.dart';

/// DTO for a single node in the org unit tree
class OrgUnitTreeNodeDto {
  final String orgUnitId;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String levelCode;
  final String? parentOrgUnitId;
  final String isActive;
  final List<OrgUnitTreeNodeDto> children;

  const OrgUnitTreeNodeDto({
    required this.orgUnitId,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    required this.levelCode,
    this.parentOrgUnitId,
    required this.isActive,
    required this.children,
  });

  factory OrgUnitTreeNodeDto.fromJson(Map<String, dynamic> json) {
    // Helper to convert id to String
    String parseIdToString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is num) return value.toString();
      return value.toString();
    }

    final childrenJson = json['children'] as List<dynamic>? ?? [];
    final children = childrenJson
        .whereType<Map<String, dynamic>>()
        .map((childJson) => OrgUnitTreeNodeDto.fromJson(childJson))
        .toList();

    return OrgUnitTreeNodeDto(
      orgUnitId: parseIdToString(json['org_unit_id'] ?? json['orgUnitId']),
      orgUnitCode: json['org_unit_code'] as String? ?? json['orgUnitCode'] as String? ?? '',
      orgUnitNameEn: json['org_unit_name_en'] as String? ?? json['orgUnitNameEn'] as String? ?? '',
      orgUnitNameAr: json['org_unit_name_ar'] as String? ?? json['orgUnitNameAr'] as String? ?? '',
      levelCode: json['level_code'] as String? ?? json['levelCode'] as String? ?? '',
      parentOrgUnitId: json['parent_org_unit_id'] != null
          ? parseIdToString(json['parent_org_unit_id'] ?? json['parentOrgUnitId'])
          : null,
      isActive: json['is_active'] as String? ?? json['isActive'] as String? ?? 'N',
      children: children,
    );
  }

  /// Converts tree node DTO to OrgStructureLevelDto
  OrgStructureLevelDto toOrgStructureLevelDto(String structureId, int enterpriseId) {
    return OrgStructureLevelDto(
      orgUnitId: orgUnitId,
      orgStructureId: structureId,
      enterpriseId: enterpriseId,
      levelCode: levelCode,
      orgUnitCode: orgUnitCode,
      orgUnitNameEn: orgUnitNameEn,
      orgUnitNameAr: orgUnitNameAr,
      parentOrgUnitId: parentOrgUnitId,
      isActive: isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'org_unit_id': orgUnitId,
      'org_unit_code': orgUnitCode,
      'org_unit_name_en': orgUnitNameEn,
      'org_unit_name_ar': orgUnitNameAr,
      'level_code': levelCode,
      if (parentOrgUnitId != null) 'parent_org_unit_id': parentOrgUnitId,
      'is_active': isActive,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

/// DTO for the complete org unit tree response
class OrgUnitTreeResponseDto {
  final String structureId;
  final String structureName;
  final List<OrgUnitTreeNodeDto> tree;

  const OrgUnitTreeResponseDto({required this.structureId, required this.structureName, required this.tree});

  factory OrgUnitTreeResponseDto.fromJson(Map<String, dynamic> json) {
    // Helper to convert id to String
    String parseIdToString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is num) return value.toString();
      return value.toString();
    }

    final data = json['data'] as Map<String, dynamic>? ?? {};
    final treeJson = data['tree'] as List<dynamic>? ?? [];

    return OrgUnitTreeResponseDto(
      structureId: parseIdToString(data['structure_id'] ?? data['structureId']),
      structureName: data['structure_name'] as String? ?? data['structureName'] as String? ?? '',
      tree: treeJson
          .whereType<Map<String, dynamic>>()
          .map((nodeJson) => OrgUnitTreeNodeDto.fromJson(nodeJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'structure_id': structureId,
        'structure_name': structureName,
        'tree': tree.map((node) => node.toJson()).toList(),
      },
    };
  }
}
