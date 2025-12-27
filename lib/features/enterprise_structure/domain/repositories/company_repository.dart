import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/company.dart';

/// Repository interface for company operations
abstract class CompanyRepository {
  /// Gets list of all companies
  /// 
  /// [search] - Optional search query to filter companies
  /// [page] - Optional page number for pagination
  /// [pageSize] - Optional page size for pagination
  /// Throws [AppException] if the operation fails
  Future<List<CompanyOverview>> getCompanies({
    String? search,
    int? page,
    int? pageSize,
  });

  /// Creates a new company
  /// 
  /// Throws [AppException] if the operation fails
  Future<CompanyOverview> createCompany(Map<String, dynamic> companyData);

  /// Updates an existing company
  /// 
  /// Throws [AppException] if the operation fails
  Future<CompanyOverview> updateCompany(int companyId, Map<String, dynamic> companyData);

  /// Deletes a company
  /// 
  /// [hard] - If true, permanently deletes the company. If false, soft deletes it.
  /// Throws [AppException] if the operation fails
  Future<void> deleteCompany(int companyId, {bool hard = true});
}

