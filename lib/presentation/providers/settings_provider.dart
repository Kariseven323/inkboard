import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextScaleNotifier extends StateNotifier<double> {
  static const _key = 'text_scale_factor';

  TextScaleNotifier() : super(1.0) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final v = prefs.getDouble(_key);
      if (v != null) state = v.clamp(0.8, 1.6);
    } catch (_) {}
  }

  Future<void> set(double value) async {
    final v = value.clamp(0.8, 1.6);
    state = v;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_key, v);
    } catch (_) {}
  }
}

final textScaleProvider = StateNotifierProvider<TextScaleNotifier, double>(
  (ref) => TextScaleNotifier(),
);

