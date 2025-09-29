/// 加密服务接口
abstract class EncryptionService {
  /// 加密文本
  Future<String> encrypt(String plainText);

  /// 解密文本
  Future<String> decrypt(String encryptedText);

  /// 生成密钥
  Future<String> generateKey();

  /// 设置密钥
  Future<void> setKey(String key);

  /// 验证密钥
  Future<bool> validateKey(String key);

  /// 加密敏感字段（如日记内容）
  Future<String> encryptSensitiveData(String data);

  /// 解密敏感字段
  Future<String> decryptSensitiveData(String encryptedData);

  /// 清除密钥（注销时使用）
  Future<void> clearKey();
}
