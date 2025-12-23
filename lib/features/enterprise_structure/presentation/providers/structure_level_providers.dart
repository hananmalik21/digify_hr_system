import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/enterprise_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/enterprise_structure_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/structure_level_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/enterprise_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/enterprise_structure_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/structure_level_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_enterprises_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_structure_levels_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/save_enterprise_structure_usecase.dart';
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

