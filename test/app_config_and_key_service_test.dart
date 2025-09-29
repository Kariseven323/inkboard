import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/core/services/app_config_service.dart';
import 'package:inkboard/core/services/database_key_service.dart';

class _MemoryKeyService extends DatabaseKeyService {
  String? _store;
  @override
  Future<void> clearKey() async {
    _store = null;
  }

  @override
  Future<String> getOrCreateKey() async {
    _store ??= generateKey();
    return _store!;
  }
}

void main() {
  test('AppConfigService basic fields', () {
    final cfg = AppConfigService();
    expect(cfg.appName.isNotEmpty, true);
    expect(cfg.version, '1.0.0');
    cfg.init(); // should not throw
  });

  test(
    'DatabaseKeyService.generateKey returns base64 32 bytes; getOrCreate consistent',
    () async {
      final svc = _MemoryKeyService();
      final key = svc.generateKey();
      expect(base64.decode(key).length, 32);
      final k1 = await svc.getOrCreateKey();
      final k2 = await svc.getOrCreateKey();
      expect(k1, k2);
      await svc.clearKey();
      final k3 = await svc.getOrCreateKey();
      expect(k3 != k1, true);
    },
  );
}
