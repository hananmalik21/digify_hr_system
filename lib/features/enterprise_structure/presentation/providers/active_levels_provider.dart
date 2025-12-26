import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_active_levels_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for active levels list
class ActiveLevelsState {
  final List<ActiveStructureLevel> levels;
  final bool isLoading;
  final String? errorMessage;
  final bool hasError;

  const ActiveLevelsState({
    this.levels = const [],
    this.isLoading = false,
    this.errorMessage,
    this.hasError = false,
  });

  ActiveLevelsState copyWith({
    List<ActiveStructureLevel>? levels,
    bool? isLoading,
    String? errorMessage,
    bool? hasError,
  }) {
    return ActiveLevelsState(
      levels: levels ?? this.levels,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
    );
  }
}

/// Notifier for active levels list
class ActiveLevelsNotifier extends StateNotifier<ActiveLevelsState> {
  final GetActiveLevelsUseCase getActiveLevelsUseCase;

  ActiveLevelsNotifier({required this.getActiveLevelsUseCase})
      : super(const ActiveLevelsState()) {
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);

    try {
      final levels = await getActiveLevelsUseCase();
      state = state.copyWith(
        levels: levels,
        isLoading: false,
        hasError: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load active levels: ${e.toString()}',
      );
    }
  }

  Future<void> refresh() async {
    await _loadLevels();
  }
}

/// Provider for active levels list
final activeLevelsProvider =
    StateNotifierProvider.autoDispose<ActiveLevelsNotifier, ActiveLevelsState>(
        (ref) {
  final getActiveLevelsUseCase = ref.watch(getActiveLevelsUseCaseProvider);
  return ActiveLevelsNotifier(getActiveLevelsUseCase: getActiveLevelsUseCase);
});

