import 'package:drift/drift.dart';

/// 用户资料表定义（单条记录，id 固定为 1）
@DataClassName('UserProfileData')
class UserProfiles extends Table {
  /// 主键ID（固定为1）
  IntColumn get id => integer()();

  /// 头像（跨端以 bytes 存储）
  BlobColumn get avatar => blob().nullable()();

  /// 昵称
  TextColumn get nickname => text().nullable()();

  /// 个性签名
  TextColumn get signature => text().nullable()();

  /// 性别（可空：male/female/other）
  TextColumn get gender => text().nullable()();

  /// 生日
  DateTimeColumn get birthday => dateTime().nullable()();

  /// 地区
  TextColumn get region => text().nullable()();

  /// 邮箱
  TextColumn get email => text().nullable()();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
