import 'package:digify_hr_system/features/enterprise_structure/domain/models/department.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final departmentListProvider = Provider<List<DepartmentOverview>>((ref) {
  return const [
    DepartmentOverview(
      id: 'dept_1',
      name: 'Treasury Department',
      nameArabic: 'قسم الخزينة',
      code: 'DEPT-TREAS',
      businessUnitName: 'Corporate Finance',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Yousef Al-Othman',
      headEmail: 'yousef.othman@kuwaitholdings.com',
      headPhone: '+965 2222 3388',
      isActive: true,
      employees: 15,
      sections: 3,
      budget: '1.2M',
      focusArea: 'Treasury',
    ),
    DepartmentOverview(
      id: 'dept_2',
      name: 'Investment Department',
      nameArabic: 'قسم الاستثمار',
      code: 'DEPT-INV',
      businessUnitName: 'Corporate Finance',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Layla Al-Sabah',
      headEmail: 'layla.sabah@kuwaitholdings.com',
      headPhone: '+965 2233 5566',
      isActive: true,
      employees: 18,
      sections: 2,
      budget: '1.4M',
      focusArea: 'Investments',
    ),
    DepartmentOverview(
      id: 'dept_3',
      name: 'Financial Reporting',
      nameArabic: 'قسم التقارير المالية',
      code: 'DEPT-FIN-RPT',
      businessUnitName: 'Accounting & Reporting',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Abdullah Al-Mudhaf',
      headEmail: 'abdullah.mudhaf@kuwaitholdings.com',
      headPhone: '+965 2244 1122',
      isActive: true,
      employees: 12,
      sections: 2,
      budget: '0.9M',
      focusArea: 'Reporting',
    ),
    DepartmentOverview(
      id: 'dept_4',
      name: 'Maintenance Department',
      nameArabic: 'قسم الصيانة',
      code: 'DEPT-MAINT',
      businessUnitName: 'Field Operations',
      divisionName: 'Operations Division',
      companyName: 'Kuwait Petroleum Services',
      headName: 'Hamad Al-Dhafiri',
      headEmail: 'hamad.dhafiri@kps.com',
      headPhone: '+965 2299 5544',
      isActive: true,
      employees: 95,
      sections: 4,
      budget: '2.8M',
      focusArea: 'Maintenance',
    ),
  ];
});

final departmentSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredDepartmentProvider = Provider<List<DepartmentOverview>>((ref) {
  final departments = ref.watch(departmentListProvider);
  final query = ref.watch(departmentSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return departments;

  return departments.where((department) {
    return department.name.toLowerCase().contains(query) ||
        department.code.toLowerCase().contains(query) ||
        department.headName.toLowerCase().contains(query);
  }).toList();
});
