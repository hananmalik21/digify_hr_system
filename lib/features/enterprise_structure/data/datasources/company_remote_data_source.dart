import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/dto/company_dto.dart';

/// Remote data source for company operations
abstract class CompanyRemoteDataSource {
  Future<List<CompanyDto>> getCompanies({String? search, int? page, int? pageSize});
  Future<CompanyDto> createCompany(Map<String, dynamic> companyData);
  Future<CompanyDto> updateCompany(int companyId, Map<String, dynamic> companyData);
  Future<void> deleteCompany(int companyId, {bool hard = true});
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final ApiClient apiClient;

  CompanyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CompanyDto>> getCompanies({String? search, int? page, int? pageSize}) async {
    try {
      // Build query parameters
      final queryParameters = <String, String>{};
      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }
      if (page != null) {
        queryParameters['page'] = page.toString();
      }
      if (pageSize != null) {
        queryParameters['page_size'] = pageSize.toString();
      }

      final response = await apiClient.get(
        ApiEndpoints.companies,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      // Handle different response formats
      List<dynamic> data;
      if (response.containsKey('data') && response['data'] is List) {
        data = response['data'] as List<dynamic>;
      } else if (response.containsKey('companies') && response['companies'] is List) {
        data = response['companies'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      } else {
        data = [];
      }

      return data.whereType<Map<String, dynamic>>().map((json) => CompanyDto.fromJson(json)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch companies: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CompanyDto> createCompany(Map<String, dynamic> companyData) async {
    try {
      final response = await apiClient.post(ApiEndpoints.companies, body: companyData);

      // Handle different response formats
      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return CompanyDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create company: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CompanyDto> updateCompany(int companyId, Map<String, dynamic> companyData) async {
    try {
      final response = await apiClient.put('${ApiEndpoints.companies}/$companyId', body: companyData);

      // Handle different response formats
      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return CompanyDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update company: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteCompany(int companyId, {bool hard = true}) async {
    try {
      await apiClient.delete('${ApiEndpoints.companies}/$companyId', queryParameters: {'hard': hard.toString()});
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete company: ${e.toString()}', originalError: e);
    }
  }
}
