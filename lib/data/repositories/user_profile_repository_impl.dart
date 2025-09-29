import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../database/app_database.dart';

@LazySingleton(as: UserProfileRepository)
class UserProfileRepositoryImpl implements UserProfileRepository {
  final AppDatabase _db;
  const UserProfileRepositoryImpl(this._db);

  @override
  Future<UserProfile?> getProfile() async {
    final row = await (_db.select(_db.userProfiles)
          ..where((tbl) => tbl.id.equals(1)))
        .getSingleOrNull();
    if (row == null) return null;
    return _map(row);
  }

  @override
  Stream<UserProfile?> watchProfile() {
    final q = (_db.select(_db.userProfiles)..where((t) => t.id.equals(1)));
    return q.watchSingleOrNull().map((row) => row == null ? null : _map(row));
  }

  @override
  Future<bool> upsertProfile(UserProfile profile) async {
    final data = UserProfilesCompanion(
      id: const Value(1),
      avatar: profile.avatar != null ? Value(profile.avatar!) : const Value.absent(),
      nickname: Value(profile.nickname),
      signature: Value(profile.signature),
      gender: Value(profile.gender),
      birthday: Value(profile.birthday),
      region: Value(profile.region),
      email: Value(profile.email),
      updatedAt: Value(DateTime.now()),
    );

    // 若存在则更新，否则插入
    final exists = await getProfile();
    if (exists == null) {
      final inserted = await _db.into(_db.userProfiles).insert(data);
      return inserted > 0;
    } else {
      final count = await (_db.update(_db.userProfiles)
            ..where((tbl) => tbl.id.equals(1)))
          .write(data);
      return count > 0;
    }
  }

  @override
  Future<bool> clearAvatar() async {
    final count = await (_db.update(_db.userProfiles)
          ..where((tbl) => tbl.id.equals(1)))
        .write(const UserProfilesCompanion(avatar: Value(null)));
    return count > 0;
  }

  UserProfile _map(UserProfileData r) {
    return UserProfile(
      id: r.id,
      avatar: r.avatar == null ? null : Uint8List.fromList(r.avatar!),
      nickname: r.nickname,
      signature: r.signature,
      gender: r.gender,
      birthday: r.birthday,
      region: r.region,
      email: r.email,
      updatedAt: r.updatedAt,
    );
  }
}

