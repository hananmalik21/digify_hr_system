import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/business_unit_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/company_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/department_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/division_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/enterprise_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/enterprise_structure_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/org_structure_level_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/org_unit_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/structure_level_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/structure_list_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/structure_delete_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/business_unit_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/company_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/department_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/division_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/enterprise_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/enterprise_structure_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/org_structure_level_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/org_unit_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/structure_level_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/structure_list_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/structure_delete_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/create_business_unit_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/create_company_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/create_division_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/delete_business_unit_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/delete_company_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/delete_division_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/create_department_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_business_units_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_companies_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_departments_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/update_department_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/delete_department_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/business_unit_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_divisions_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/update_business_unit_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/update_company_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/update_division_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_enterprises_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_active_levels_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_org_units_paginated_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/create_org_unit_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/update_org_unit_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/delete_org_unit_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_structure_levels_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_structure_list_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/save_enterprise_structure_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/delete_structure_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart' show StructureListNotifier, StructureListState;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for ApiClient instance
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

/// Provider for StructureLevelRemoteDataSource
final structureLevelRemoteDataSourceProvider =
    Provider<StructureLevelRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StructureLevelRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for StructureLevelRepository
final structureLevelRepositoryProvider =
    Provider<StructureLevelRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(structureLevelRemoteDataSourceProvider);
  return StructureLevelRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetStructureLevelsUseCase
final getStructureLevelsUseCaseProvider =
    Provider<GetStructureLevelsUseCase>((ref) {
  final repository = ref.watch(structureLevelRepositoryProvider);
  return GetStructureLevelsUseCase(repository: repository);
});

/// Provider for EnterpriseStructureRemoteDataSource
final enterpriseStructureRemoteDataSourceProvider =
    Provider<EnterpriseStructureRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EnterpriseStructureRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for EnterpriseStructureRepository
final enterpriseStructureRepositoryProvider =
    Provider<EnterpriseStructureRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(enterpriseStructureRemoteDataSourceProvider);
  return EnterpriseStructureRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for SaveEnterpriseStructureUseCase
final saveEnterpriseStructureUseCaseProvider =
    Provider<SaveEnterpriseStructureUseCase>((ref) {
  final repository = ref.watch(enterpriseStructureRepositoryProvider);
  return SaveEnterpriseStructureUseCase(repository: repository);
});

/// Provider for EnterpriseRemoteDataSource
final enterpriseRemoteDataSourceProvider =
    Provider<EnterpriseRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EnterpriseRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for EnterpriseRepository
final enterpriseRepositoryProvider =
    Provider<EnterpriseRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(enterpriseRemoteDataSourceProvider);
  return EnterpriseRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetEnterprisesUseCase
final getEnterprisesUseCaseProvider =
    Provider<GetEnterprisesUseCase>((ref) {
  final repository = ref.watch(enterpriseRepositoryProvider);
  return GetEnterprisesUseCase(repository: repository);
});

/// Provider for StructureListRemoteDataSource
final structureListRemoteDataSourceProvider =
    Provider<StructureListRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StructureListRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for StructureListRepository
final structureListRepositoryProvider =
    Provider<StructureListRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(structureListRemoteDataSourceProvider);
  return StructureListRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetStructureListUseCase
final getStructureListUseCaseProvider =
    Provider<GetStructureListUseCase>((ref) {
  final repository = ref.watch(structureListRepositoryProvider);
  return GetStructureListUseCase(repository: repository);
});

/// Provider for CompanyRemoteDataSource
final companyRemoteDataSourceProvider =
    Provider<CompanyRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CompanyRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for CompanyRepository
final companyRepositoryProvider =
    Provider<CompanyRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(companyRemoteDataSourceProvider);
  return CompanyRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetCompaniesUseCase
final getCompaniesUseCaseProvider =
    Provider<GetCompaniesUseCase>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return GetCompaniesUseCase(repository: repository);
});

/// Provider for CreateCompanyUseCase
final createCompanyUseCaseProvider =
    Provider<CreateCompanyUseCase>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return CreateCompanyUseCase(repository: repository);
});

/// Provider for UpdateCompanyUseCase
final updateCompanyUseCaseProvider =
    Provider<UpdateCompanyUseCase>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return UpdateCompanyUseCase(repository: repository);
});

/// Provider for DeleteCompanyUseCase
final deleteCompanyUseCaseProvider =
    Provider<DeleteCompanyUseCase>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return DeleteCompanyUseCase(repository: repository);
});

/// Provider for DivisionRemoteDataSource
final divisionRemoteDataSourceProvider =
    Provider<DivisionRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DivisionRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for DivisionRepository
final divisionRepositoryProvider =
    Provider<DivisionRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(divisionRemoteDataSourceProvider);
  return DivisionRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetDivisionsUseCase
final getDivisionsUseCaseProvider =
    Provider<GetDivisionsUseCase>((ref) {
  final repository = ref.watch(divisionRepositoryProvider);
  return GetDivisionsUseCase(repository: repository);
});

/// Provider for CreateDivisionUseCase
final createDivisionUseCaseProvider =
    Provider<CreateDivisionUseCase>((ref) {
  final repository = ref.watch(divisionRepositoryProvider);
  return CreateDivisionUseCase(repository: repository);
});

/// Provider for UpdateDivisionUseCase
final updateDivisionUseCaseProvider =
    Provider<UpdateDivisionUseCase>((ref) {
  final repository = ref.watch(divisionRepositoryProvider);
  return UpdateDivisionUseCase(repository: repository);
});

/// Provider for DeleteDivisionUseCase
final deleteDivisionUseCaseProvider =
    Provider<DeleteDivisionUseCase>((ref) {
  final repository = ref.watch(divisionRepositoryProvider);
  return DeleteDivisionUseCase(repository: repository);
});

/// Provider for BusinessUnitRemoteDataSource
final businessUnitRemoteDataSourceProvider =
    Provider<BusinessUnitRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BusinessUnitRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for BusinessUnitRepository
final businessUnitRepositoryProvider =
    Provider<BusinessUnitRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(businessUnitRemoteDataSourceProvider);
  return BusinessUnitRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetBusinessUnitsUseCase
final getBusinessUnitsUseCaseProvider =
    Provider<GetBusinessUnitsUseCase>((ref) {
  final repository = ref.watch(businessUnitRepositoryProvider);
  return GetBusinessUnitsUseCase(repository: repository);
});

/// Provider for CreateBusinessUnitUseCase
final createBusinessUnitUseCaseProvider =
    Provider<CreateBusinessUnitUseCase>((ref) {
  final repository = ref.watch(businessUnitRepositoryProvider);
  return CreateBusinessUnitUseCase(repository: repository);
});

/// Provider for UpdateBusinessUnitUseCase
final updateBusinessUnitUseCaseProvider =
    Provider<UpdateBusinessUnitUseCase>((ref) {
  final repository = ref.watch(businessUnitRepositoryProvider);
  return UpdateBusinessUnitUseCase(repository: repository);
});

/// Provider for DeleteBusinessUnitUseCase
final deleteBusinessUnitUseCaseProvider =
    Provider<DeleteBusinessUnitUseCase>((ref) {
  final repository = ref.watch(businessUnitRepositoryProvider);
  return DeleteBusinessUnitUseCase(repository: repository);
});

/// Provider for DepartmentRemoteDataSource
final departmentRemoteDataSourceProvider =
    Provider<DepartmentRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DepartmentRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for DepartmentRepository
final departmentRepositoryProvider =
    Provider<DepartmentRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(departmentRemoteDataSourceProvider);
  return DepartmentRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetDepartmentsUseCase
final getDepartmentsUseCaseProvider =
    Provider<GetDepartmentsUseCase>((ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return GetDepartmentsUseCase(repository: repository);
});

/// Provider for CreateDepartmentUseCase
final createDepartmentUseCaseProvider =
    Provider<CreateDepartmentUseCase>((ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return CreateDepartmentUseCase(repository: repository);
});

/// Provider for UpdateDepartmentUseCase
final updateDepartmentUseCaseProvider =
    Provider<UpdateDepartmentUseCase>((ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return UpdateDepartmentUseCase(repository: repository);
});

/// Provider for DeleteDepartmentUseCase
final deleteDepartmentUseCaseProvider =
    Provider<DeleteDepartmentUseCase>((ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return DeleteDepartmentUseCase(repository: repository);
});

/// Provider for business units dropdown (with pageSize 1000)
final businessUnitsDropdownProvider = StateNotifierProvider.autoDispose<BusinessUnitListNotifier, BusinessUnitListState>(
  (ref) {
    final getBusinessUnitsUseCase = ref.watch(getBusinessUnitsUseCaseProvider);
    return BusinessUnitListNotifier.withPageSize(
      getBusinessUnitsUseCase: getBusinessUnitsUseCase,
      pageSize: 1000,
    );
  },
);

/// Provider for organization structures dropdown (with pageSize 1000)
final orgStructuresDropdownProvider =
    StateNotifierProvider.autoDispose<StructureListNotifier, StructureListState>(
  (ref) {
    final getStructureListUseCase = ref.watch(getStructureListUseCaseProvider);
    return StructureListNotifier.withPageSize(
      getStructureListUseCase: getStructureListUseCase,
      pageSize: 1000,
    );
  },
);

/// Provider for OrgStructureLevelRemoteDataSource
final orgStructureLevelRemoteDataSourceProvider =
    Provider<OrgStructureLevelRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrgStructureLevelRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for OrgStructureLevelRepository
final orgStructureLevelRepositoryProvider =
    Provider<OrgStructureLevelRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(orgStructureLevelRemoteDataSourceProvider);
  return OrgStructureLevelRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetActiveLevelsUseCase
final getActiveLevelsUseCaseProvider =
    Provider<GetActiveLevelsUseCase>((ref) {
  final repository = ref.watch(orgStructureLevelRepositoryProvider);
  return GetActiveLevelsUseCase(repository: repository);
});

/// Provider for OrgUnitRemoteDataSource
final orgUnitRemoteDataSourceProvider =
    Provider<OrgUnitRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrgUnitRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for OrgUnitRepository
final orgUnitRepositoryProvider =
    Provider<OrgUnitRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(orgUnitRemoteDataSourceProvider);
  return OrgUnitRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetOrgUnitsByLevelUseCase
final getOrgUnitsByLevelUseCaseProvider =
    Provider<GetOrgUnitsByLevelUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return GetOrgUnitsByLevelUseCase(repository: repository);
});

/// Provider for GetOrgUnitsPaginatedUseCase
final getOrgUnitsPaginatedUseCaseProvider =
    Provider<GetOrgUnitsPaginatedUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return GetOrgUnitsPaginatedUseCase(repository: repository);
});

/// Provider for CreateOrgUnitUseCase
final createOrgUnitUseCaseProvider =
    Provider<CreateOrgUnitUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return CreateOrgUnitUseCase(repository: repository);
});

/// Provider for UpdateOrgUnitUseCase
final updateOrgUnitUseCaseProvider =
    Provider<UpdateOrgUnitUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return UpdateOrgUnitUseCase(repository: repository);
});

/// Provider for DeleteOrgUnitUseCase
final deleteOrgUnitUseCaseProvider =
    Provider<DeleteOrgUnitUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return DeleteOrgUnitUseCase(repository: repository);
});

/// Provider for StructureDeleteRemoteDataSource
final structureDeleteRemoteDataSourceProvider =
    Provider<StructureDeleteRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StructureDeleteRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider for StructureDeleteRepository
final structureDeleteRepositoryProvider =
    Provider<StructureDeleteRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(structureDeleteRemoteDataSourceProvider);
  return StructureDeleteRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for DeleteStructureUseCase
final deleteStructureUseCaseProvider =
    Provider<DeleteStructureUseCase>((ref) {
  final repository = ref.watch(structureDeleteRepositoryProvider);
  return DeleteStructureUseCase(repository: repository);
});

