import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/data/services/encryption_service_impl.dart';

void main() {
  group('EncryptionServiceImpl', () {
    test('generate/validate key and encrypt/decrypt roundtrip', () async {
      final svc = EncryptionServiceImpl();
      final key = await svc.generateKey();
      // base64 decode length should be 32
      expect(base64.decode(key).length, 32);
      expect(await svc.validateKey(key), true);

      await svc.setKey(key);
      final plain = 'Hello 世界 123!';
      final enc = await svc.encrypt(plain);
      expect(enc, isNotEmpty);
      final dec = await svc.decrypt(enc);
      expect(dec, plain);

      // sensitive helpers
      expect(await svc.encryptSensitiveData(''), '');
      expect(await svc.decryptSensitiveData(''), '');

      // wrong key should fail to decrypt correctly
      final otherKey = await svc.generateKey();
      await svc.setKey(otherKey);
      try {
        final wrong = await svc.decrypt(enc);
        // 在这种简化实现中，错误密钥可能产生乱码但不一定抛错；至少不是原文
        expect(wrong, isNot(equals(plain)));
      } catch (e) {
        // 也接受抛错
        expect(e, isA<Exception>());
      }

      await svc.clearKey();
      expect(() => svc.encrypt('x'), throwsA(isA<Exception>()));
    });
  });
}
