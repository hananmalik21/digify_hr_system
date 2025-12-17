import 'package:flutter/foundation.dart';

@immutable
class CompanyOverview {
  final String id;
  final String name;
  final String nameArabic;
  final String entityCode;
  final String registrationNumber;
  final bool isActive;
  final int employees;
  final String location;
  final String industry;
  final String phone;
  final String email;

  const CompanyOverview({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.entityCode,
    required this.registrationNumber,
    required this.isActive,
    required this.employees,
    required this.location,
    required this.industry,
    required this.phone,
    required this.email,
  });
}

