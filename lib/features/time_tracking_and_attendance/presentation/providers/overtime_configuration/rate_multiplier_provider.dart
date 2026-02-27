import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/overtime_configuration/rate_multiplier.dart';
import 'overtime_configuration_provider.dart';

final rateMultiplierDialogProvider =
    StateNotifierProvider<RateMultiplierDialogNotifier, RateMultiplier>((ref) {
      return RateMultiplierDialogNotifier(ref);
    });

class RateMultiplierDialogNotifier extends StateNotifier<RateMultiplier> {
  RateMultiplierDialogNotifier(Ref ref) : super(RateMultiplier()) {}
  void updateRateTypeName(String name) {
    state = state.copyWith(name: name);
  }

  void updateMultiplier(String multiplier) {
    state = state.copyWith(multiplier: multiplier);
  }

  void updateCategory(String category) {
    state = state.copyWith(category: category);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void reset() {
    state = RateMultiplier();
  }

  Future<void> handleSubmit(WidgetRef ref) async {
    ref.read(overtimeConfigurationProvider.notifier).addRateMultiplier(state);
  }
}
