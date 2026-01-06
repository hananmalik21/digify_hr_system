import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/public_holiday_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/data/repositories/public_holiday_repository_impl.dart';
import 'package:digify_hr_system/features/time_management/domain/models/public_holiday.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/public_holiday_repository.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/create_public_holiday_usecase.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/get_public_holidays_usecase.dart';
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
    bool clearError = false,
    bool clearSearch = false,
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
    );
  }
}

/// Notifier for public holidays
class PublicHolidaysNotifier extends StateNotifier<PublicHolidaysState> {
  final GetPublicHolidaysUseCase getHolidaysUseCase;

  PublicHolidaysNotifier({required this.getHolidaysUseCase}) : super(const PublicHolidaysState());

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
  void setSearchQuery(String? query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query, currentPage: 1);
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
}

/// Provider for public holidays notifier
final publicHolidaysNotifierProvider = StateNotifierProvider<PublicHolidaysNotifier, PublicHolidaysState>((ref) {
  final useCase = ref.watch(getPublicHolidaysUseCaseProvider);
  return PublicHolidaysNotifier(getHolidaysUseCase: useCase);
});
