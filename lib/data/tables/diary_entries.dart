import 'package:drift/drift.dart';

/// 日记条目表定义
@DataClassName('DiaryEntryData')
class DiaryEntries extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 日记标题
  TextColumn get title => text().withLength(min: 1, max: 200)();

  /// 日记内容（Markdown格式）
  TextColumn get content => text()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime()();

  /// 是否收藏
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  /// 心情评分 (1-5)
  IntColumn get moodScore => integer().nullable()();

  /// 天气信息
  TextColumn get weather => text().nullable()();

  /// 位置信息
  TextColumn get location => text().nullable()();
}