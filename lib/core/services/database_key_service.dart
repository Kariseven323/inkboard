import 'dart:math';
import 'dart:convert';

/// 数据库密钥管理服务
abstract class DatabaseKeyService {
  /// 获取已存在密钥；不存在则生成并持久化，最后返回。
  Future<String> getOrCreateKey();

  /// 生成一个新的随机密钥（Base64编码，长度32字节）
  String generateKey() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(32, (_) => rnd.nextInt(256));
    return base64.encode(bytes);
  }

  /// 清空存储的密钥（登出或重置时使用）
  Future<void> clearKey();
}

