import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise_structure.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/save_enterprise_structure_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for save enterprise structure operation
class SaveEnterpriseStructureState {
  final bool isSaving;
  final String? errorMessage;
  final bool hasError;
  final bool isSuccess;
  final String? loadingStructureId; // Track which structure is being activated

  const SaveEnterpriseStructureState({
    this.isSaving = false,
    this.errorMessage,
    this.hasError = false,
    this.isSuccess = false,
    this.loadingStructureId,
  });

  SaveEnterpriseStructureState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool? hasError,
    bool? isSuccess,
    String? loadingStructureId,
  }) {
    return SaveEnterpriseStructureState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      isSuccess: isSuccess ?? this.isSuccess,
      loadingStructureId: loadingStructureId ?? this.loadingStructureId,
    );
  }
}

/// Notifier for saving enterprise structure
class SaveEnterpriseStructureNotifier
    extends StateNotifier<SaveEnterpriseStructureState> {
  final SaveEnterpriseStructureUseCase saveUseCase;

  SaveEnterpriseStructureNotifier({required this.saveUseCase})
    : super(const SaveEnterpriseStructureState());

  /// Saves or updates the enterprise structure
  /// Returns true on success, throws AppException on error
  Future<bool> saveStructure({
    required String structureName,
    required String description,
    required List<HierarchyLevel> levels,
    int? enterpriseId,
    String? structureCode,
    bool isActive = true,
    String?
    structureId, // If provided, performs update (PUT), otherwise create (POST)
  }) async {
    // Try to update loading state, but don't fail if provider is disposed
    try {
      state = state.copyWith(
        isSaving: true,
        hasError: false,
        errorMessage: null,
        loadingStructureId:
            structureId, // Track which structure is being activated
      );
    } catch (e) {
      // Provider might be disposed, continue anyway
    }

    // Store error message to return if needed
    String? errorMessage;

    try {
      // Generate structure code if not provided
      final code = structureCode ?? _generateStructureCode(structureName);

      // For updates (PUT), don't include levels since they can't be changed
      // For creates (POST), include levels
      List<EnterpriseStructureLevel> structureLevels = [];
      if (structureId == null) {
        // Convert HierarchyLevel to EnterpriseStructureLevel (only for create)
        // Only include active levels and maintain their order
        structureLevels = levels
            .where((level) => level.isActive)
            .toList()
            .asMap()
            .entries
            .map((entry) {
              final level = entry.value;
              final displayOrder =
                  entry.key + 1; // 1-based index for display order

              // Parse structureLevelId from HierarchyLevel.id
              // HierarchyLevel.id should be the structure level ID from API
              final structureLevelId = int.tryParse(level.id) ?? 0;

              return EnterpriseStructureLevel(
                structureLevelId: structureLevelId,
                levelNumber: level.level,
                displayOrder: displayOrder,
              );
            })
            .toList();
      }

      final enterpriseStructure = EnterpriseStructure(
        enterpriseId: enterpriseId,
        structureCode: code,
        structureName: structureName,
        structureType: 'ENTERPRISE',
        description: description,
        isActive: isActive,
        levels:
            structureLevels, // Empty list for updates, populated for creates
      );

      // Use PUT for updates, POST for creates
      if (structureId != null) {
        await saveUseCase.updateStructure(structureId, enterpriseStructure);
      } else {
        await saveUseCase(enterpriseStructure);
      }

      // Try to update success state, but don't fail if provider is disposed
      try {
        state = state.copyWith(
          isSaving: false,
          isSuccess: true,
          hasError: false,
          errorMessage: null,
          loadingStructureId: null, // Clear loading structure ID
        );
      } catch (e) {
        // Provider might be disposed, continue anyway
      }
      return true;
    } on ValidationException catch (e) {
      // Clear loading structure ID on error
      try {
        state = state.copyWith(isSaving: false, loadingStructureId: null);
      } catch (_) {
        // Provider might be disposed, continue anyway
      }

      // Handle validation errors with detailed messages
      errorMessage = e.message;
      if (e.errors != null && e.errors!.isNotEmpty) {
        // Extract all error messages
        final errorMessages = <String>[];
        e.errors!.forEach((key, value) {
          if (value is List) {
            errorMessages.addAll(value.map((v) => v.toString()));
          } else {
            errorMessages.add(value.toString());
          }
        });
        if (errorMessages.isNotEmpty) {
          errorMessage = errorMessages.join('\n');
        }
      }

      // Don't update state on error - just throw the exception
      // The caller will handle the exception and the provider might be disposed
      throw ValidationException(errorMessage, errors: e.errors);
    } on AppException {
      // Clear loading structure ID on error
      try {
        state = state.copyWith(isSaving: false, loadingStructureId: null);
      } catch (_) {
        // Provider might be disposed, continue anyway
      }

      // Don't update state on error - just rethrow the exception
      // The caller will handle the exception and the provider might be disposed
      rethrow;
    } catch (e) {
      // Clear loading structure ID on error
      try {
        state = state.copyWith(isSaving: false, loadingStructureId: null);
      } catch (_) {
        // Provider might be disposed, continue anyway
      }

      errorMessage = 'Failed to save enterprise structure: ${e.toString()}';
      // Don't update state on error - just throw the exception
      // The caller will handle the exception and the provider might be disposed
      throw UnknownException(errorMessage, originalError: e);
    }
  }

  /// Generates a structure code from structure name
  String _generateStructureCode(String structureName) {
    if (structureName.isEmpty) {
      return 'ORG${DateTime.now().millisecondsSinceEpoch}';
    }

    // Convert name to uppercase and replace spaces with underscores
    final code = structureName
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    // If code is empty or too short, use timestamp
    if (code.isEmpty || code.length < 3) {
      return 'ORG${DateTime.now().millisecondsSinceEpoch}';
    }

    // Limit to 20 characters
    final finalCode = code.length > 20 ? code.substring(0, 20) : code;

    // Add timestamp suffçix if needed to ensure uniqueness
    return '${finalCode}_${DateTime.now().millisecondsSinceEpoch % 10000}';
  }

  void reset() {
    state = const SaveEnterpriseStructureState();
  }
}

/// Provider for save enterprise structure notifier
