import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';

void main() {
  test('DiaryEntry helpers & Tag default', () {
    final now = DateTime.now();
    final tagWork = Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now);
    final tagX = Tag(id: 2, name: '自定义', color: '#000000', createdAt: now);

    final e = DiaryEntry(
      title: '标题',
      content: '# Hello **World** [link](url)!',
      createdAt: now,
      updatedAt: now,
      moodScore: 5,
      tags: [tagWork, tagX],
    );

    expect(e.hasTags, true);
    expect(e.isEmpty, false);
    expect(e.excerpt.isNotEmpty, true);
    expect(e.moodDescription, '很棒');

    expect(tagWork.isDefault, true);
    expect(tagX.isDefault, false);

    final e2 = e.copyWith(title: '', content: '');
    expect(e2.isEmpty, true);
  });
}
