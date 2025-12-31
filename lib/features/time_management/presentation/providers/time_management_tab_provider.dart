import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/features/time_management/presentation/utils/time_management_tab_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the time management tab selection
class TimeManagementTabState {
  final TimeManagementTab currentTab;

  const TimeManagementTabState({this.currentTab = TimeManagementTab.shifts});

  TimeManagementTabState copyWith({TimeManagementTab? currentTab}) {
    return TimeManagementTabState(currentTab: currentTab ?? this.currentTab);
  }
}

/// Notifier to manage the selection of time management tabs
class TimeManagementTabNotifier extends StateNotifier<TimeManagementTabState> {
  TimeManagementTabNotifier() : super(const TimeManagementTabState());

  /// Update the current tab based on a route parameter
  void setTabFromRoute(String? routeTab) {
    final tab = TimeManagementTabManager.getTabFromRoute(routeTab);
    if (state.currentTab != tab) {
      state = state.copyWith(currentTab: tab);
    }
  }

  /// Manually set the current tab
  void setTab(TimeManagementTab tab) {
    if (state.currentTab != tab) {
      state = state.copyWith(currentTab: tab);
    }
  }
}

/// Provider for time management tab state
final timeManagementTabStateProvider =
    StateNotifierProvider<TimeManagementTabNotifier, TimeManagementTabState>((
      ref,
    ) {
      return TimeManagementTabNotifier();
    });
