import 'package:flutter/foundation.dart';

@immutable
class OrgStructureLevel {
  final int orgUnitId;
  final int orgStructureId;
  final int enterpriseId;
  final String levelCode;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final int? parentOrgUnitId;
  final bool isActive;
  final String managerName;
  final String managerEmail;
  final String managerPhone;
  final String location;
  final String city;
  final String address;
  final String description;
  final String createdBy;
  final String createdDate;
  final String lastUpdatedBy;
  final String lastUpdatedDate;
  final String lastUpdateLogin;

  const OrgStructureLevel({
    required this.orgUnitId,
    required this.orgStructureId,
    required this.enterpriseId,
    required this.levelCode,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    this.parentOrgUnitId,
    required this.isActive,
    required this.managerName,
    required this.managerEmail,
    required this.managerPhone,
    required this.location,
    required this.city,
    required this.address,
    required this.description,
    required this.createdBy,
    required this.createdDate,
    required this.lastUpdatedBy,
    required this.lastUpdatedDate,
    required this.lastUpdateLogin,
  });
}

