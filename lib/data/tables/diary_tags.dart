import 'package:drift/drift.dart';

/// 日记条目和标签的关联表（多对多关系）
@DataClassName('DiaryTagData')
class DiaryTags extends Table {
  /// 日记条目ID（外键）
  IntColumn get diaryEntryId => integer()();

  /// 标签ID（外键）
  IntColumn get tagId => integer()();

  /// 关联创建时间
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {diaryEntryId, tagId};
}
