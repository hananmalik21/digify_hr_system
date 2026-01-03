import 'package:flutter_riverpod/flutter_riverpod.dart';

// Cards visibility provider
class CardsVisibilityNotifier extends StateNotifier<bool> {
  CardsVisibilityNotifier() : super(true);

  void toggle() {
    state = !state;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

final cardsVisibilityProvider =
    StateNotifierProvider<CardsVisibilityNotifier, bool>((ref) {
  return CardsVisibilityNotifier();
});

