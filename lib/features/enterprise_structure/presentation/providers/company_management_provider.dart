import 'dart:async';

import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/company.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_companies_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for companies list
class CompaniesState {
  final List<CompanyOverview> companies;
  final bool isLoading;
  final String? errorMessage;
  final bool hasError;
  final String searchQuery;
  final int currentPage;
  final int pageSize;

  const CompaniesState({
    this.companies = const [],
    this.isLoading = false,
    this.errorMessage,
    this.hasError = false,
    this.searchQuery = '',
    this.currentPage = 1,
    this.pageSize = 10,
  });

  CompaniesState copyWith({
    List<CompanyOverview>? companies,
    bool? isLoading,
    String? errorMessage,
    bool? hasError,
    String? searchQuery,
    int? currentPage,
    int? pageSize,
  }) {
    return CompaniesState(
      companies: companies ?? this.companies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Notifier for companies list
/// This provider automatically loads companies when accessed
class CompaniesNotifier extends StateNotifier<CompaniesState> {
  final GetCompaniesUseCase getCompaniesUseCase;
  Timer? _debounceTimer;

  CompaniesNotifier({required this.getCompaniesUseCase})
    : super(const CompaniesState()) {
    _loadCompanies();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCompanies({
    String? search,
    int? page,
    int? pageSize,
  }) async {
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
    );

    try {
      final companies = await getCompaniesUseCase(
        search:
            search ?? (state.searchQuery.isNotEmpty ? state.searchQuery : null),
        page: page ?? state.currentPage,
        pageSize: pageSize ?? state.pageSize,
      );
      state = state.copyWith(
        companies: companies,
        isLoading: false,
        hasError: false,
        searchQuery: search ?? state.searchQuery,
        currentPage: page ?? state.currentPage,
        pageSize: pageSize ?? state.pageSize,
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
        errorMessage: 'Failed to load companies: ${e.toString()}',
      );
    }
  }

  /// Search companies with debouncing
  void searchCompanies(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _loadCompanies(
        search: query.trim(),
        page: 1, // Reset to first page on search
      );
    });
  }

  Future<void> refresh() async {
    await _loadCompanies();
  }
}

/// Provider for companies list
/// This provider automatically loads companies every time it's accessed
final companiesProvider =
    StateNotifierProvider.autoDispose<CompaniesNotifier, CompaniesState>((ref) {
      final getCompaniesUseCase = ref.watch(getCompaniesUseCaseProvider);
      return CompaniesNotifier(getCompaniesUseCase: getCompaniesUseCase);
    });

/// Provider for filtered companies based on search query
final companySearchQueryProvider = StateProvider.autoDispose<String>((_) => '');

/// Provider for filtered companies list
final filteredCompanyProvider = Provider.autoDispose<List<CompanyOverview>>((
  ref,
) {
  final query = ref.watch(companySearchQueryProvider).trim().toLowerCase();
  final companiesState = ref.watch(companiesProvider);
  final companies = companiesState.companies;

  if (query.isEmpty) {
    return companies;
  }

  return companies.where((company) {
    final searchableData =
        '''
          ${company.name}
          ${company.nameArabic}
          ${company.entityCode}
          ${company.registrationNumber}
          ${company.industry}
          ${company.location}
        '''
            .toLowerCase();
    return searchableData.contains(query);
  }).toList();
});

/// Legacy provider for backward compatibility
/// This now uses the API-based provider
final companyListProvider = Provider.autoDispose<List<CompanyOverview>>((ref) {
  final companiesState = ref.watch(companiesProvider);
  return companiesState.companies;
});
