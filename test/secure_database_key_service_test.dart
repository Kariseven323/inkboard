import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:inkboard/core/services/impl/database_key_service_secure.dart';

class _FakeSecureStorage extends FlutterSecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return _store[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    _store.remove(key);
  }
}

void main() {
  test('SecureDatabaseKeyService getOrCreate/clear/generateKey', () async {
    final fake = _FakeSecureStorage();
    final svc = SecureDatabaseKeyService(storage: fake);

    final k1 = await svc.getOrCreateKey();
    expect(k1, isNotEmpty);
    // base64 of 32 bytes ~ 44 chars
    expect(k1.length, greaterThanOrEqualTo(43));

    final k2 = await svc.getOrCreateKey();
    expect(k2, equals(k1));

    await svc.clearKey();
    final k3 = await svc.getOrCreateKey();
    expect(k3, isNot(equals(k1)));

    final g = svc.generateKey();
    expect(g.length, greaterThanOrEqualTo(43));
  });
}
