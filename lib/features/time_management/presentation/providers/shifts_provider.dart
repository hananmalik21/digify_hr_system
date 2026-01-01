import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/data/repositories/mock_shift_repository.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/get_shifts_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mockShiftRepositoryProvider = Provider((ref) => MockShiftRepository());

final getShiftsUseCaseProvider = Provider((ref) {
  return GetShiftsUseCase(repository: ref.read(mockShiftRepositoryProvider));
});

class ShiftsState {
  final List<ShiftOverview> shifts;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;

  const ShiftsState({
    this.shifts = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  ShiftsState copyWith({
    List<ShiftOverview>? shifts,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return ShiftsState(
      shifts: shifts ?? this.shifts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class ShiftsNotifier extends StateNotifier<ShiftsState> {
  final GetShiftsUseCase getShiftsUseCase;

  ShiftsNotifier({required this.getShiftsUseCase}) : super(const ShiftsState());

  Future<void> loadShifts({
    String? search,
    bool? isActive,
    int page = 1,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await getShiftsUseCase(
        search: search,
        isActive: isActive,
        page: page,
        pageSize: 10,
      );

      state = state.copyWith(
        shifts: result.shifts,
        isLoading: false,
        currentPage: result.pagination.currentPage,
        totalPages: result.pagination.totalPages,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  void reset() {
    state = const ShiftsState();
  }
}

final shiftsNotifierProvider =
    StateNotifierProvider<ShiftsNotifier, ShiftsState>((ref) {
      return ShiftsNotifier(
        getShiftsUseCase: ref.read(getShiftsUseCaseProvider),
      );
    });
