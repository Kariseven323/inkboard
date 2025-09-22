import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';

import '../../domain/services/encryption_service.dart';

/// 简单的加密服务实现
/// 注意：这是一个基础实现，生产环境中应该使用更强的加密算法
@LazySingleton(as: EncryptionService)
class EncryptionServiceImpl implements EncryptionService {
  String? _encryptionKey;
  final Random _random = Random.secure();

  @override
  Future<String> encrypt(String plainText) async {
    if (_encryptionKey == null) {
      throw Exception('Encryption key not set');
    }

    // 生成随机盐值
    final salt = _generateSalt();
    final key = _deriveKey(_encryptionKey!, salt);

    // 简单的XOR加密（生产环境应使用AES）
    final plainBytes = utf8.encode(plainText);
    final encryptedBytes = <int>[];

    for (int i = 0; i < plainBytes.length; i++) {
      encryptedBytes.add(plainBytes[i] ^ key[i % key.length]);
    }

    // 组合盐值和加密数据
    final combined = [...salt, ...encryptedBytes];
    return base64.encode(combined);
  }

  @override
  Future<String> decrypt(String encryptedText) async {
    if (_encryptionKey == null) {
      throw Exception('Encryption key not set');
    }

    try {
      final combined = base64.decode(encryptedText);

      // 分离盐值和加密数据
      final salt = combined.sublist(0, 16);
      final encryptedBytes = combined.sublist(16);

      final key = _deriveKey(_encryptionKey!, salt);

      // 解密
      final decryptedBytes = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ key[i % key.length]);
      }

      return utf8.decode(decryptedBytes);
    } catch (e) {
      throw Exception('Failed to decrypt data: $e');
    }
  }

  @override
  Future<String> generateKey() async {
    final bytes = List<int>.generate(32, (i) => _random.nextInt(256));
    return base64.encode(bytes);
  }

  @override
  Future<void> setKey(String key) async {
    _encryptionKey = key;
  }

  @override
  Future<bool> validateKey(String key) async {
    try {
      // 验证密钥格式
      final decoded = base64.decode(key);
      return decoded.length == 32;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> encryptSensitiveData(String data) async {
    if (data.isEmpty) return data;
    return await encrypt(data);
  }

  @override
  Future<String> decryptSensitiveData(String encryptedData) async {
    if (encryptedData.isEmpty) return encryptedData;
    return await decrypt(encryptedData);
  }

  @override
  Future<void> clearKey() async {
    _encryptionKey = null;
  }

  /// 生成16字节的随机盐值
  List<int> _generateSalt() {
    return List<int>.generate(16, (i) => _random.nextInt(256));
  }

  /// 使用PBKDF2从密钥和盐值派生固定长度的密钥
  List<int> _deriveKey(String password, List<int> salt) {
    final passwordBytes = utf8.encode(password);

    // 简化的密钥派生（生产环境应使用PBKDF2）
    final hmac = Hmac(sha256, passwordBytes);
    final digest = hmac.convert(salt);

    return digest.bytes.take(32).toList();
  }
}