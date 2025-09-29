import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../database_key_service.dart';

/// 生产环境：使用系统安全存储（Keychain/Keystore 等）
@LazySingleton(as: DatabaseKeyService)
class SecureDatabaseKeyService implements DatabaseKeyService {
  static const _storageKey = 'inkboard_db_encryption_key';
  final FlutterSecureStorage _storage;

  SecureDatabaseKeyService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<String> getOrCreateKey() async {
    // 读取已有
    final existing = await _storage.read(key: _storageKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    // 生成并写入
    final key = generateKey();
    await _storage.write(key: _storageKey, value: key);
    return key;
  }

  @override
  Future<void> clearKey() async {
    await _storage.delete(key: _storageKey);
  }

  @override
  String generateKey() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(32, (_) => rnd.nextInt(256));
    return base64.encode(bytes);
  }
}
