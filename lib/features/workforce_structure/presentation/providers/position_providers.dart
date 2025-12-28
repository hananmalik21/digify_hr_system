import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/workforce_structure/data/datasources/position_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/data/repositories/position_repository_impl.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/position_repository.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/create_position_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/delete_position_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_positions_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Position remote data source provider
final positionRemoteDataSourceProvider = Provider<PositionRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return PositionRemoteDataSourceImpl(apiClient: apiClient);
});

/// Position repository provider
final positionRepositoryProvider = Provider<PositionRepository>((ref) {
  final remoteDataSource = ref.watch(positionRemoteDataSourceProvider);
  return PositionRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Get positions use case provider
final getPositionsUseCaseProvider = Provider<GetPositionsUseCase>((ref) {
  final repository = ref.watch(positionRepositoryProvider);
  return GetPositionsUseCase(repository: repository);
});

/// Create position use case provider
final createPositionUseCaseProvider = Provider<CreatePositionUseCase>((ref) {
  final repository = ref.watch(positionRepositoryProvider);
  return CreatePositionUseCase(repository: repository);
});

/// Delete position use case provider
final deletePositionUseCaseProvider = Provider<DeletePositionUseCase>((ref) {
  final repository = ref.watch(positionRepositoryProvider);
  return DeletePositionUseCase(repository: repository);
});

/// Position notifier provider
final positionNotifierProvider =
    StateNotifierProvider<PositionNotifier, PaginationState<Position>>((ref) {
      final getPositionsUseCase = ref.watch(getPositionsUseCaseProvider);
      final createPositionUseCase = ref.watch(createPositionUseCaseProvider);
      final deletePositionUseCase = ref.watch(deletePositionUseCaseProvider);
      return PositionNotifier(
        getPositionsUseCase,
        createPositionUseCase,
        deletePositionUseCase,
      );
    });
