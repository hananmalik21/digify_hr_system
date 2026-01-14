import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/public_holiday_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/data/repositories/public_holiday_repository_impl.dart';
import 'package:digify_hr_system/features/time_management/domain/models/public_holiday.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/public_holiday_repository.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/create_public_holiday_usecase.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/delete_public_holiday_usecase.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/get_public_holidays_usecase.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/update_public_holiday_usecase.dart';
import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final publicHolidayApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final publicHolidayRemoteDataSourceProvider = Provider<PublicHolidayRemoteDataSource>((ref) {
  final apiClient = ref.watch(publicHolidayApiClientProvider);
  return PublicHolidayRemoteDataSourceImpl(apiClient: apiClient);
});

final publicHolidayRepositoryProvider = Provider<PublicHolidayRepository>((ref) {
  final remoteDataSource = ref.watch(publicHolidayRemoteDataSourceProvider);
  return PublicHolidayRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getPublicHolidaysUseCaseProvider = Provider<GetPublicHolidaysUseCase>((ref) {
  final repository = ref.watch(publicHolidayRepositoryProvider);
  return GetPublicHolidaysUseCase(repository: repository);
});

final createPublicHolidayUseCaseProvider = Provider<CreatePublicHolidayUseCase>((ref) {
  final repository = ref.watch(publicHolidayRepositoryProvider);
  return CreatePublicHolidayUseCase(repository: repository);
});

final updatePublicHolidayUseCaseProvider = Provider<UpdatePublicHolidayUseCase>((ref) {
  final repository = ref.watch(publicHolidayRepositoryProvider);
  return UpdatePublicHolidayUseCase(repository);
});

final deletePublicHolidayUseCaseProvider = Provider<DeletePublicHolidayUseCase>((ref) {
  final repository = ref.watch(publicHolidayRepositoryProvider);
  return DeletePublicHolidayUseCase(repository: repository);
});

/// State for public holidays
class PublicHolidaysState {
  final List<PublicHoliday> holidays;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;
  final int currentPage;
  final int pageSize;
  final int totalHolidays;
  final bool hasMore;
  final String? searchQuery;
  final String? selectedYear;
  final String? selectedType;
  final String? deleteSuccessMessage;
  final String? deleteErrorMessage;
  final String? createSuccessMessage;
  final String? createErrorMessage;
  final int? deletingHolidayId;

  const PublicHolidaysState({
    this.holidays = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalHolidays = 0,
    this.hasMore = false,
    this.searchQuery,
    this.selectedYear,
    this.selectedType,
    this.deleteSuccessMessage,
    this.deleteErrorMessage,
    this.createSuccessMessage,
    this.createErrorMessage,
    this.deletingHolidayId,
  });

  PublicHolidaysState copyWith({
    List<PublicHoliday>? holidays,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? totalHolidays,
    bool? hasMore,
    String? searchQuery,
    String? selectedYear,
    String? selectedType,
    String? deleteSuccessMessage,
    String? deleteErrorMessage,
    String? createSuccessMessage,
    String? createErrorMessage,
    int? deletingHolidayId,
    bool clearError = false,
    bool clearSearch = false,
    bool clearSideEffects = false,
    bool clearDeletingHolidayId = false,
  }) {
    return PublicHolidaysState(
      holidays: holidays ?? this.holidays,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: clearError ? false : (hasError ?? this.hasError),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalHolidays: totalHolidays ?? this.totalHolidays,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      selectedYear: selectedYear ?? this.selectedYear,
      selectedType: selectedType ?? this.selectedType,
      deleteSuccessMessage: clearSideEffects ? null : (deleteSuccessMessage ?? this.deleteSuccessMessage),
      deleteErrorMessage: clearSideEffects ? null : (deleteErrorMessage ?? this.deleteErrorMessage),
      createSuccessMessage: clearSideEffects ? null : (createSuccessMessage ?? this.createSuccessMessage),
      createErrorMessage: clearSideEffects ? null : (createErrorMessage ?? this.createErrorMessage),
      deletingHolidayId: clearDeletingHolidayId ? null : (deletingHolidayId ?? this.deletingHolidayId),
    );
  }
}

/// Notifier for public holidays
class PublicHolidaysNotifier extends StateNotifier<PublicHolidaysState> {
  final GetPublicHolidaysUseCase getHolidaysUseCase;
  final DeletePublicHolidayUseCase deleteHolidayUseCase;
  final CreatePublicHolidayUseCase createHolidayUseCase;
  final UpdatePublicHolidayUseCase updateHolidayUseCase;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  PublicHolidaysNotifier({
    required this.getHolidaysUseCase,
    required this.deleteHolidayUseCase,
    required this.createHolidayUseCase,
    required this.updateHolidayUseCase,
  }) : super(const PublicHolidaysState());

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  /// Load holidays
  Future<void> loadHolidays({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(isLoading: true, clearError: true, currentPage: 1);
    } else {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final result = await getHolidaysUseCase(
        page: refresh ? 1 : state.currentPage,
        pageSize: state.pageSize,
        search: state.searchQuery,
        year: state.selectedYear,
        type: state.selectedType,
      );

      state = state.copyWith(
        holidays: refresh ? result.holidays : [...state.holidays, ...result.holidays],
        isLoading: false,
        currentPage: result.pagination.currentPage,
        totalHolidays: result.pagination.totalItems,
        hasMore: result.pagination.hasNext,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load holidays: ${e.toString()}',
      );
    }
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await getHolidaysUseCase(
        page: nextPage,
        pageSize: state.pageSize,
        search: state.searchQuery,
        year: state.selectedYear,
        type: state.selectedType,
      );

      state = state.copyWith(
        holidays: [...state.holidays, ...result.holidays],
        isLoadingMore: false,
        currentPage: result.pagination.currentPage,
        hasMore: result.pagination.hasNext,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoadingMore: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load more holidays: ${e.toString()}',
      );
    }
  }

  /// Set search query
  void setSearchQuery(String query) {
    final trimmedQuery = query.trim();
    if (state.searchQuery == trimmedQuery) return;

    if (trimmedQuery.isEmpty) {
      clearSearch();
      return;
    }

    state = state.copyWith(searchQuery: trimmedQuery, currentPage: 1, isLoading: true, clearError: true);
    _debouncer.run(() async {
      await loadHolidays(refresh: true);
    });
  }

  /// Clear search query
  void clearSearch() {
    if (state.searchQuery == null || state.searchQuery!.isEmpty) return;
    state = state.copyWith(clearSearch: true, currentPage: 1);
    loadHolidays(refresh: true);
  }

  /// Set selected year
  void setSelectedYear(String? year) {
    if (state.selectedYear == year) return;
    state = state.copyWith(selectedYear: year, currentPage: 1);
    loadHolidays(refresh: true);
  }

  /// Set selected type
  void setSelectedType(String? type) {
    if (state.selectedType == type) return;
    state = state.copyWith(selectedType: type, currentPage: 1);
    loadHolidays(refresh: true);
  }

  /// Refresh holidays
  Future<void> refresh() async {
    await loadHolidays(refresh: true);
  }

  /// Add holiday optimistically
  void addHolidayOptimistically(PublicHoliday holiday) {
    state = state.copyWith(holidays: [holiday, ...state.holidays], totalHolidays: state.totalHolidays + 1);
  }

  /// Remove holiday optimistically
  void removeHolidayOptimistically(int holidayId) {
    state = state.copyWith(
      holidays: state.holidays.where((h) => h.id != holidayId).toList(),
      totalHolidays: state.totalHolidays > 0 ? state.totalHolidays - 1 : 0,
    );
  }

  /// Delete holiday
  Future<void> deleteHoliday(int holidayId, {bool hard = true}) async {
    state = state.copyWith(deletingHolidayId: holidayId);

    try {
      await deleteHolidayUseCase.execute(holidayId, hard: hard);
      state = state.copyWith(
        deletingHolidayId: null,
        deleteSuccessMessage: 'Holiday deleted successfully',
        holidays: state.holidays.where((h) => h.id != holidayId).toList(),
        totalHolidays: state.totalHolidays > 0 ? state.totalHolidays - 1 : 0,
      );
    } catch (e) {
      state = state.copyWith(deletingHolidayId: null, deleteErrorMessage: 'Failed to delete holiday: ${e.toString()}');
    }
  }

  /// Clear side effects
  void clearSideEffects() {
    state = state.copyWith(clearSideEffects: true);
  }

  /// Get holiday by ID
  PublicHoliday? getHolidayById(int holidayId) {
    try {
      return state.holidays.firstWhere((h) => h.id == holidayId);
    } catch (e) {
      return null;
    }
  }

  /// Create holiday
  Future<void> createHoliday({
    required int tenantId,
    required String nameEn,
    required String nameAr,
    required DateTime date,
    required int year,
    required HolidayType type,
    required String descriptionEn,
    required String descriptionAr,
    required String appliesTo,
    required bool isPaid,
  }) async {
    try {
      final createdHoliday = await createHolidayUseCase.execute(
        tenantId: tenantId,
        nameEn: nameEn,
        nameAr: nameAr,
        date: date,
        year: year,
        type: type,
        descriptionEn: descriptionEn,
        descriptionAr: descriptionAr,
        appliesTo: appliesTo,
        isPaid: isPaid,
      );

      state = state.copyWith(
        holidays: [createdHoliday, ...state.holidays],
        totalHolidays: state.totalHolidays + 1,
        createSuccessMessage: 'Holiday created successfully',
      );
    } catch (e) {
      state = state.copyWith(createErrorMessage: 'Failed to create holiday: ${e.toString()}');
    }
  }

  /// Update holiday
  Future<void> updateHoliday({
    required int holidayId,
    required int tenantId,
    required String nameEn,
    required String nameAr,
    required DateTime date,
    required int year,
    required HolidayType type,
    required String descriptionEn,
    required String descriptionAr,
    required String appliesTo,
    required bool isPaid,
  }) async {
    try {
      final updateUseCase = updateHolidayUseCase;
      await updateUseCase.execute(
        holidayId: holidayId,
        tenantId: tenantId,
        nameEn: nameEn,
        nameAr: nameAr,
        date: date,
        year: year,
        type: type,
        descriptionEn: descriptionEn,
        descriptionAr: descriptionAr,
        appliesTo: appliesTo,
        isPaid: isPaid,
      );

      await refresh();
      state = state.copyWith(createSuccessMessage: 'Holiday updated successfully');
    } catch (e) {
      state = state.copyWith(createErrorMessage: 'Failed to update holiday: ${e.toString()}');
    }
  }
}

/// Provider for public holidays notifier
final publicHolidaysNotifierProvider = StateNotifierProvider<PublicHolidaysNotifier, PublicHolidaysState>((ref) {
  final getHolidaysUseCase = ref.watch(getPublicHolidaysUseCaseProvider);
  final deleteHolidayUseCase = ref.watch(deletePublicHolidayUseCaseProvider);
  final createHolidayUseCase = ref.watch(createPublicHolidayUseCaseProvider);
  final updateHolidayUseCase = ref.watch(updatePublicHolidayUseCaseProvider);
  return PublicHolidaysNotifier(
    getHolidaysUseCase: getHolidaysUseCase,
    deleteHolidayUseCase: deleteHolidayUseCase,
    createHolidayUseCase: createHolidayUseCase,
    updateHolidayUseCase: updateHolidayUseCase,
  );
});
