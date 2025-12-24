import 'package:digify_hr_system/features/enterprise_structure/domain/models/company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final companyListProvider = Provider<List<CompanyOverview>>((_) => _mockCompanies);

final companySearchQueryProvider = StateProvider.autoDispose<String>((_) => '');

final filteredCompanyProvider = Provider<List<CompanyOverview>>((ref) {
  final query = ref.watch(companySearchQueryProvider).trim().toLowerCase();
  final companies = ref.watch(companyListProvider);

  if (query.isEmpty) {
    return companies;
  }

  return companies
      .where((company) {
        final searchableData = '''
          ${company.name}
          ${company.nameArabic}
          ${company.entityCode}
          ${company.registrationNumber}
          ${company.industry}
          ${company.location}
        '''.toLowerCase();
        return searchableData.contains(query);
      })
      .toList();
});

const _mockCompanies = <CompanyOverview>[
  CompanyOverview(
    id: 'kuwaitholdings',
    name: 'Kuwait Holdings Corporation',
    nameArabic: 'شركة الكويت القابضة',
    entityCode: 'KWT-HQ',
    registrationNumber: 'CR-2024-001234',
    isActive: true,
    employees: 450,
    location: 'Kuwait City, Kuwait',
    industry: 'Financial Services',
    phone: '+965 2222 3333',
    email: 'info@kuwaitholdings.com',
  ),
  CompanyOverview(
    id: 'kuwaitpetroleum',
    name: 'Kuwait Petroleum Services',
    nameArabic: 'خدمات النفط الكويتية',
    entityCode: 'KWT-OIL',
    registrationNumber: 'CR-2024-005678',
    isActive: true,
    employees: 850,
    location: 'Ahmadi, Kuwait',
    industry: 'Oil & Gas',
    phone: '+965 2333 4444',
    email: 'contact@kw-petroleum.com',
  ),
];

