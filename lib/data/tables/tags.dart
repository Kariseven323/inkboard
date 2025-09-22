import 'package:drift/drift.dart';

/// 标签表定义
@DataClassName('TagData')
class Tags extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 标签名称
  TextColumn get name => text().withLength(min: 1, max: 50)();

  /// 标签颜色 (HEX格式，如 #FF5722)
  TextColumn get color => text().withDefault(const Constant('#1877F2'))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 使用次数
  IntColumn get usageCount => integer().withDefault(const Constant(0))();

  /// 标签描述
  TextColumn get description => text().nullable()();

  /// 确保标签名称唯一
  @override
  List<Set<Column>>? get uniqueKeys => [
        {name}
      ];
}