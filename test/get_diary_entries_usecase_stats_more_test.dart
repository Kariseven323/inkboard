import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/usecases/get_diary_entries_usecase.dart';

void main() {
  test('DiaryStatistics.fromMap 缺省键默认0', () {
    final s = DiaryStatistics.fromMap({});
    expect(s.totalCount, 0);
    expect(s.favoriteCount, 0);
    expect(s.monthlyCount, 0);
  });

  test('DiaryStatistics favoriteRate 与平均值边界', () {
    final s = DiaryStatistics(totalCount: 0, favoriteCount: 0, monthlyCount: 0);
    expect(s.favoriteRate, 0.0);
    expect(s.getAverageMonthlyEntries(0), 0.0);
  });
}
