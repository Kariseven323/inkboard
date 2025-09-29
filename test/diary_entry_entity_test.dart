import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';

void main() {
  test('DiaryEntry copyWith/等价性/派生属性', () {
    final now = DateTime.now();
    final e1 = DiaryEntry(
      id: 1,
      title: 'T',
      content: 'C**1**',
      createdAt: now,
      updatedAt: now,
    );
    final e2 = e1.copyWith(
      isFavorite: true,
      moodScore: 4,
      tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
    );
    expect(e2.isFavorite, isTrue);
    expect(e2.hasTags, isTrue);
    expect(e1 == e2, isFalse);
    expect(e1.excerpt.isNotEmpty, isTrue);
    expect(e2.moodDescription, '不错');
    final e3 = e1.copyWith();
    expect(e1, equals(e3));
  });
}
