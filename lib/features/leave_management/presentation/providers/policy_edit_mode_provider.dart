import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing policy edit mode state
final policyEditModeProvider = StateNotifierProvider<PolicyEditModeNotifier, bool>((ref) {
  return PolicyEditModeNotifier();
});

class PolicyEditModeNotifier extends StateNotifier<bool> {
  PolicyEditModeNotifier() : super(false);

  void startEditing() {
    state = true;
  }

  void cancelEditing() {
    state = false;
  }

  void saveChanges() {
    state = false;
  }
}
