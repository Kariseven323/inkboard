import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/tag.dart';

void main() {
  test('Tag 实体 copyWith 与 isDefault', () {
    final now = DateTime.now();
    final t1 = Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now);
    expect(t1.isDefault, isTrue);

    final t2 = t1.copyWith(name: '自定义', usageCount: 3);
    expect(t2.isDefault, isFalse);
    expect(t2.name, '自定义');
    expect(t2.usageCount, 3);
    expect(t2.createdAt, t1.createdAt);
  });

  test('Tag 默认名称集合判断', () {
    final now = DateTime.now();
    for (final name in ['工作', '生活', '学习', '思考', '旅行']) {
      expect(Tag(name: name, color: '#000', createdAt: now).isDefault, isTrue);
    }
    expect(Tag(name: '自创', color: '#000', createdAt: now).isDefault, isFalse);
  });

  test('Tag 等价性与哈希', () {
    final now = DateTime.now();
    final a = Tag(id: 1, name: 'X', color: '#000', createdAt: now, usageCount: 2);
    final b = Tag(id: 1, name: 'X', color: '#000', createdAt: now, usageCount: 2);
    final c = Tag(id: 2, name: 'Y', color: '#111', createdAt: now);
    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
    expect(a == c, isFalse);
  });
}
