import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/delete_structure_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for delete structure operation
class DeleteStructureState {
  final bool isDeleting;
  final String? errorMessage;
  final bool hasError;

  const DeleteStructureState({
    this.isDeleting = false,
    this.errorMessage,
    this.hasError = false,
  });

  DeleteStructureState copyWith({
    bool? isDeleting,
    String? errorMessage,
    bool? hasError,
  }) {
    return DeleteStructureState(
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
    );
  }
}

/// Notifier for delete structure operation
class DeleteStructureNotifier extends StateNotifier<DeleteStructureState> {
  final DeleteStructureUseCase deleteStructureUseCase;

  DeleteStructureNotifier({required this.deleteStructureUseCase})
      : super(const DeleteStructureState());

  /// Delete structure with optional cascade
  Future<Map<String, dynamic>?> deleteStructure({
    required String structureId,
    bool hard = true,
    bool force = false,
    bool autoFallback = false,
  }) async {
    state = state.copyWith(isDeleting: true, hasError: false, errorMessage: null);

    try {
      final result = await deleteStructureUseCase(
        structureId: structureId,
        hard: hard,
        autoFallback: autoFallback,
      );

      state = state.copyWith(isDeleting: false);
      return result;
    } on ConflictException catch (e) {
      state = state.copyWith(
        isDeleting: false,
        hasError: true,
        errorMessage: e.message,
      );
      rethrow;
    } on AppException catch (e) {
      state = state.copyWith(
        isDeleting: false,
        hasError: true,
        errorMessage: e.message,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        hasError: true,
        errorMessage: 'Failed to delete structure: ${e.toString()}',
      );
      rethrow;
    }
  }

  void reset() {
    state = const DeleteStructureState();
  }
}

