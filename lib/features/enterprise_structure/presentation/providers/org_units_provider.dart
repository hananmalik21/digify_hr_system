import 'dart:developer';

import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/paginated_org_units_response.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_org_units_paginated_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for org units list
class OrgUnitsState {
  final List<OrgStructureLevel> units;
  final bool isLoading;
  final String? errorMessage;
  final bool hasError;
  final String? levelCode;
  final int? structureId;
  final String? searchQuery;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  const OrgUnitsState({
    this.units = const [],
    this.isLoading = false,
    this.errorMessage,
    this.hasError = false,
    this.levelCode,
    this.structureId,
    this.searchQuery,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalPages = 1,
    this.totalItems = 0,
  });

  OrgUnitsState copyWith({
    List<OrgStructureLevel>? units,
    bool? isLoading,
    String? errorMessage,
    bool? hasError,
    String? levelCode,
    int? structureId,
    String? searchQuery,
    int? currentPage,
    int? pageSize,
    int? totalPages,
    int? totalItems,
  }) {
    return OrgUnitsState(
      units: units ?? this.units,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      levelCode: levelCode ?? this.levelCode,
      structureId: structureId ?? this.structureId,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
}

/// Notifier for org units list
class OrgUnitsNotifier extends StateNotifier<OrgUnitsState> {
  final GetOrgUnitsByLevelUseCase getOrgUnitsByLevelUseCase;
  final GetOrgUnitsPaginatedUseCase getOrgUnitsPaginatedUseCase;

  OrgUnitsNotifier({
    required this.getOrgUnitsByLevelUseCase,
    required this.getOrgUnitsPaginatedUseCase,
  }) : super(const OrgUnitsState());

  Future<void> loadOrgUnits(
    String levelCode, {
    int? structureId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    debugPrint('OrgUnitsNotifier: loadOrgUnits called - levelCode=$levelCode, structureId=$structureId, page=$page, pageSize=$pageSize');
    debugPrint('OrgUnitsNotifier: Current state - isLoading=${state.isLoading}, levelCode=${state.levelCode}, structureId=${state.structureId}, currentPage=${state.currentPage}');
    
    // Always allow page changes (for pagination) - don't block if page is different
    final isPageChange = state.currentPage != page;
    
    // Only skip if it's the exact same request (same level, structure, search, AND page) AND already loading
    if (!isPageChange && 
        state.isLoading && 
        state.levelCode == levelCode && 
        state.structureId == structureId &&
        state.searchQuery == search &&
        state.currentPage == page) {
      debugPrint('OrgUnitsNotifier: Skipping load - already loading exact same request');
      return;
    }
    
    // If page is different, always proceed (for pagination)
    if (isPageChange) {
      debugPrint('OrgUnitsNotifier: Page change detected - from ${state.currentPage} to $page, proceeding with load');
    }

    try {
      state = state.copyWith(
        isLoading: true,
        hasError: false,
        errorMessage: null,
        levelCode: levelCode,
        structureId: structureId,
        searchQuery: search,
        currentPage: page,
        pageSize: pageSize,
      );
    } catch (e) {
      debugPrint('OrgUnitsNotifier: Error setting loading state: $e');
      return;
    }

    try {
      PaginatedOrgUnitsResponse? paginatedResponse;
      
      // Use paginated API if structureId is provided
      if (structureId != null) {
        paginatedResponse = await getOrgUnitsPaginatedUseCase.call(
          structureId,
          levelCode,
          search: search,
          page: page,
          pageSize: pageSize,
        );
      } else {
        // Fallback to non-paginated API
        final units = await getOrgUnitsByLevelUseCase(levelCode);
        if(units.isNotEmpty){
          log("units are ${units.first.parentUnit}");

        }
        paginatedResponse = PaginatedOrgUnitsResponse(
          units: units,
          currentPage: 1,
          pageSize: units.length,
          totalPages: 1,
          totalItems: units.length,
        );
      }
      
      if (paginatedResponse.units.isNotEmpty) {
        debugPrint('OrgUnitsNotifier: First unit ID: ${paginatedResponse.units.first.orgUnitId}, Name: ${paginatedResponse.units.first.orgUnitNameEn}');
      }
      
      try {
        final newState = state.copyWith(
          units: paginatedResponse.units,
          isLoading: false,
          hasError: false,
          currentPage: paginatedResponse.currentPage,
          totalPages: paginatedResponse.totalPages,
          totalItems: paginatedResponse.totalItems,
        );
        state = newState;
        debugPrint('OrgUnitsNotifier: State updated - page ${state.currentPage}/${state.totalPages}, total: ${state.totalItems}, units: ${state.units.length}');
        debugPrint('OrgUnitsNotifier: hasNextPage=${state.hasNextPage}, hasPreviousPage=${state.hasPreviousPage}');
      } catch (e) {
        debugPrint('OrgUnitsNotifier: Error updating state (provider may be disposed): $e');
        return;
      }
    } on AppException catch (e) {
      try {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: e.message,
        );
      } catch (_) {
        return;
      }
    } catch (e) {
      try {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Failed to load org units: ${e.toString()}',
        );
      } catch (_) {
        return;
      }
    }
  }

  Future<void> search(String query) async {
    if (state.levelCode != null && state.structureId != null) {
      await loadOrgUnits(
        state.levelCode!,
        structureId: state.structureId,
        search: query.isEmpty ? null : query,
        page: 1, // Reset to first page on search
        pageSize: state.pageSize,
      );
    }
  }

  Future<void> goToPage(int page) async {
    debugPrint('OrgUnitsNotifier: goToPage called with page=$page');
    debugPrint('OrgUnitsNotifier: Current state - levelCode=${state.levelCode}, structureId=${state.structureId}, totalPages=${state.totalPages}, currentPage=${state.currentPage}');
    
    // Validate page number
    if (page < 1 || (state.totalPages > 0 && page > state.totalPages)) {
      debugPrint('OrgUnitsNotifier: Invalid page number $page (totalPages=${state.totalPages})');
      return;
    }
    
    // If we don't have levelCode or structureId, we can't load
    if (state.levelCode == null || state.structureId == null) {
      debugPrint('OrgUnitsNotifier: Cannot navigate - levelCode or structureId is null');
      return;
    }
    
    // If already on this page, don't reload
    if (state.currentPage == page && !state.isLoading) {
      debugPrint('OrgUnitsNotifier: Already on page $page, skipping reload');
      return;
    }
    
    debugPrint('OrgUnitsNotifier: Calling loadOrgUnits for page $page');
    await loadOrgUnits(
      state.levelCode!,
      structureId: state.structureId,
      search: state.searchQuery,
      page: page,
      pageSize: state.pageSize,
    );
  }

  Future<void> nextPage() async {
    debugPrint('OrgUnitsNotifier: nextPage called');
    debugPrint('OrgUnitsNotifier: currentPage=${state.currentPage}, totalPages=${state.totalPages}, hasNextPage=${state.hasNextPage}');
    
    if (state.hasNextPage) {
      final nextPageNum = state.currentPage + 1;
      debugPrint('OrgUnitsNotifier: Navigating to next page $nextPageNum');
      await goToPage(nextPageNum);
    } else {
      debugPrint('OrgUnitsNotifier: Cannot go to next page - hasNextPage is false');
    }
  }

  Future<void> previousPage() async {
    debugPrint('OrgUnitsNotifier: previousPage called');
    debugPrint('OrgUnitsNotifier: currentPage=${state.currentPage}, totalPages=${state.totalPages}, hasPreviousPage=${state.hasPreviousPage}');
    
    if (state.hasPreviousPage) {
      final prevPageNum = state.currentPage - 1;
      debugPrint('OrgUnitsNotifier: Navigating to previous page $prevPageNum');
      await goToPage(prevPageNum);
    } else {
      debugPrint('OrgUnitsNotifier: Cannot go to previous page - hasPreviousPage is false');
    }
  }

  bool get hasNextPage => state.hasNextPage;
  bool get hasPreviousPage => state.hasPreviousPage;

  Future<void> refresh() async {
    if (state.levelCode != null) {
      await loadOrgUnits(
        state.levelCode!,
        structureId: state.structureId,
        search: state.searchQuery,
        page: state.currentPage,
        pageSize: state.pageSize,
      );
    }
  }

  void clear() {
    try {
      state = const OrgUnitsState();
    } catch (_) {
      // Provider was disposed, ignore
    }
  }
}

/// Provider for org units list
/// Takes levelCode as a parameter
final orgUnitsProvider =
    StateNotifierProvider.autoDispose.family<OrgUnitsNotifier, OrgUnitsState, String>(
        (ref, levelCode) {
  final getOrgUnitsByLevelUseCase = ref.watch(getOrgUnitsByLevelUseCaseProvider);
  final getOrgUnitsPaginatedUseCase = ref.watch(getOrgUnitsPaginatedUseCaseProvider);
  final notifier = OrgUnitsNotifier(
    getOrgUnitsByLevelUseCase: getOrgUnitsByLevelUseCase,
    getOrgUnitsPaginatedUseCase: getOrgUnitsPaginatedUseCase,
  );
  
  return notifier;
});

