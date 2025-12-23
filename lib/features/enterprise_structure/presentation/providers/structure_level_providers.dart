import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/structure_level_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/repositories/structure_level_repository_impl.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_structure_levels_usecase.dart';
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

