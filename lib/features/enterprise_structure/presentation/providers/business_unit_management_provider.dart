import 'package:digify_hr_system/features/enterprise_structure/domain/models/business_unit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessUnitListProvider = Provider<List<BusinessUnitOverview>>((ref) {
  return const [
    BusinessUnitOverview(
      id: '1',
      name: 'Corporate Finance',
      nameArabic: 'التمويل المؤسسي',
      code: 'BU-CORP-FIN',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Khaled Al-Mutawa',
      headEmail: 'khaled.mutawa@kuwaitholdings.com',
      headPhone: '+965 2200 3344',
      isActive: true,
      employees: 35,
      departments: 3,
      budget: '1.2M',
      focusArea: 'Treasury & Investments',
      location: 'Tower A, 5th Floor',
      city: 'Kuwait City',
      establishedDate: '2011-04-20',
      description: 'Manages corporate treasury and investment strategies.',
    ),
    BusinessUnitOverview(
      id: '2',
      name: 'Accounting & Reporting',
      nameArabic: 'المحاسبة والتقارير',
      code: 'BU-ACCT',
      divisionName: 'Finance & Accounting Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Nadia Al-Fahad',
      headEmail: 'nadia.fahad@kuwaitholdings.com',
      headPhone: '+965 2233 5566',
      isActive: true,
      employees: 28,
      departments: 2,
      budget: '0.9M',
      focusArea: 'Financial Reporting',
      location: 'Tower A, 3rd Floor',
      city: 'Kuwait City',
      establishedDate: '2013-07-12',
      description: 'Handles statutory reporting and compliance.',
    ),
    BusinessUnitOverview(
      id: '3',
      name: 'Recruitment & Talent',
      nameArabic: 'التوظيف والمواهب',
      code: 'BU-REC',
      divisionName: 'Human Resources Division',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Omar Al-Jasem',
      headEmail: 'omar.jasem@kuwaitholdings.com',
      headPhone: '+965 2244 7788',
      isActive: true,
      employees: 22,
      departments: 2,
      budget: '0.8M',
      focusArea: 'Talent Management',
      location: 'Tower B, 2nd Floor',
      city: 'Kuwait City',
      establishedDate: '2015-09-01',
      description: 'Leads recruitment, onboarding, and talent planning.',
    ),
    BusinessUnitOverview(
      id: '4',
      name: 'Field Operations',
      nameArabic: 'العمليات الميدانية',
      code: 'BU-FIELD',
      divisionName: 'Operations Division',
      companyName: 'Kuwait Petroleum Services',
      headName: 'Jassim Al-Ansari',
      headEmail: 'jassim.ansari@kps.com',
      headPhone: '+965 2299 1122',
      isActive: true,
      employees: 185,
      departments: 4,
      budget: '5.2M',
      focusArea: 'Field Services',
      location: 'Field Operations Center',
      city: 'Ahmadi',
      establishedDate: '2010-01-25',
      description: 'Oversees operations across field networks.',
    ),
  ];
});

final businessUnitSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredBusinessUnitsProvider = Provider<List<BusinessUnitOverview>>((ref) {
  final businessUnits = ref.watch(businessUnitListProvider);
  final query = ref.watch(businessUnitSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return businessUnits;

  return businessUnits.where((bu) {
    return bu.name.toLowerCase().contains(query) ||
        bu.code.toLowerCase().contains(query) ||
        bu.headName.toLowerCase().contains(query);
  }).toList();
});

