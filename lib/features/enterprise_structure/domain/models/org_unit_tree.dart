import 'package:flutter/foundation.dart';

/// Domain model for a single node in the org unit tree
@immutable
class OrgUnitTreeNode {
  final String orgUnitId;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String levelCode;
  final String? parentOrgUnitId;
  final bool isActive;
  final List<OrgUnitTreeNode> children;

  const OrgUnitTreeNode({
    required this.orgUnitId,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    required this.levelCode,
    this.parentOrgUnitId,
    required this.isActive,
    required this.children,
  });

  /// Preferred display name
  String get displayName => orgUnitNameEn.isNotEmpty ? orgUnitNameEn : orgUnitNameAr;
}

/// Domain model for the complete org unit tree response
@immutable
class OrgUnitTree {
  final String structureId;
  final String structureName;
  final List<OrgUnitTreeNode> tree;

  const OrgUnitTree({required this.structureId, required this.structureName, required this.tree});
}
