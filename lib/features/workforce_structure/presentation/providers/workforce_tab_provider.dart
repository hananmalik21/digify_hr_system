import 'package:digify_hr_system/core/enums/workforce_enums.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/utils/workforce_tab_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the workforce tab selection
class WorkforceTabState {
  final WorkforceTab currentTab;

  const WorkforceTabState({this.currentTab = WorkforceTab.positions});

  WorkforceTabState copyWith({WorkforceTab? currentTab}) {
    return WorkforceTabState(currentTab: currentTab ?? this.currentTab);
  }
}

/// Notifier to manage the selection of workforce tabs
class WorkforceTabNotifier extends StateNotifier<WorkforceTabState> {
  WorkforceTabNotifier() : super(const WorkforceTabState());

  /// Update the current tab based on a route parameter
  void setTabFromRoute(String? routeTab) {
    final tab = WorkforceTabManager.getTabFromRoute(routeTab);
    if (state.currentTab != tab) {
      state = state.copyWith(currentTab: tab);
    }
  }

  /// Manually set the current tab
  void setTab(WorkforceTab tab) {
    if (state.currentTab != tab) {
      state = state.copyWith(currentTab: tab);
    }
  }
}

/// Provider for workforce tab state
final workforceTabStateProvider =
    StateNotifierProvider<WorkforceTabNotifier, WorkforceTabState>((ref) {
      return WorkforceTabNotifier();
    });
