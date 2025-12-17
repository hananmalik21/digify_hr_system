import 'package:digify_hr_system/features/enterprise_structure/domain/models/division.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final divisionListProvider = Provider<List<DivisionOverview>>((ref) {
  return const [
    DivisionOverview(
      id: '1',
      name: 'Finance & Accounting Division',
      nameArabic: 'قسم المالية والمحاسبة',
      code: 'DIV-FIN',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Ahmed Al-Rashid',
      isActive: true,
      employees: 85,
      departments: 6,
      budget: '2.5M',
      location: 'Kuwait City HQ',
      industry: 'Financial Services',
      headEmail: 'ahmed.rashid@kuwaitholdings.com',
      headPhone: '+965 2222 3344',
      address: 'Tower A, 5th Floor, Al-Shuhada Street',
      city: 'Kuwait City',
      establishedDate: '2010-01-15',
      description: 'Responsible for all financial operations, accounting, and treasury management',
    ),
    DivisionOverview(
      id: '2',
      name: 'Human Resources Division',
      nameArabic: 'قسم الموارد البشرية',
      code: 'DIV-HR',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Fatima Al-Salem',
      isActive: true,
      employees: 45,
      departments: 4,
      budget: '1.8M',
      location: 'Kuwait City HQ',
      industry: 'People Management',
      headEmail: 'fatima.salem@kuwaitholdings.com',
      headPhone: '+965 2222 5566',
      address: 'Tower A, 3rd Floor, Al-Shuhada Street',
      city: 'Kuwait City',
      establishedDate: '2012-03-20',
      description: 'Managing talent acquisition, employee relations, and organizational development',
    ),
    DivisionOverview(
      id: '3',
      name: 'Operations Division',
      nameArabic: 'قسم العمليات',
      code: 'DIV-OPS',
      companyName: 'Kuwait Petroleum Services',
      headName: 'Mohammed Al-Kandari',
      isActive: true,
      employees: 320,
      departments: 8,
      budget: '8.5M',
      location: 'Ahmadi Operations Center',
      industry: 'Operational Excellence',
      headEmail: 'mohammed.kandari@kps.com',
      headPhone: '+965 2398 7700',
      address: 'Industrial Zone B, Building 15',
      city: 'Ahmadi',
      establishedDate: '2005-08-10',
      description: 'Overseeing daily operations, logistics, and production activities',
    ),
    DivisionOverview(
      id: '4',
      name: 'Information Technology Division',
      nameArabic: 'قسم تقنية المعلومات',
      code: 'DIV-IT',
      companyName: 'Kuwait Holdings Corporation',
      headName: 'Sara Al-Mutairi',
      isActive: true,
      employees: 62,
      departments: 5,
      budget: '3.2M',
      location: 'Kuwait City HQ',
      industry: 'Technology & Innovation',
      headEmail: 'sara.mutairi@kuwaitholdings.com',
      headPhone: '+965 2222 8899',
      address: 'Tower B, 7th Floor, Al-Shuhada Street',
      city: 'Kuwait City',
      establishedDate: '2015-05-01',
      description: 'Managing IT infrastructure, software development, and digital transformation initiatives',
    ),
  ];
});

final divisionSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredDivisionProvider = Provider<List<DivisionOverview>>((ref) {
  final divisions = ref.watch(divisionListProvider);
  final query = ref.watch(divisionSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return divisions;

  return divisions.where((division) {
    return division.name.toLowerCase().contains(query) ||
        division.code.toLowerCase().contains(query) ||
        division.headName.toLowerCase().contains(query);
  }).toList();
});

