import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/data/database/app_database.dart';
import 'package:inkboard/data/repositories/user_profile_repository_impl.dart';
import 'package:inkboard/domain/entities/user_profile.dart';

void main() {
  late AppDatabase db;
  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
  });
  tearDown(() async {
    await db.close();
  });

  test('UserProfileRepositoryImpl CRUD 基本流程', () async {
    final repo = UserProfileRepositoryImpl(db);

    // 初始应有默认记录（迁移时插入 id=1）
    expect(await repo.getProfile(), isNotNull);

    // 插入
    final p0 = UserProfile(
      id: 1,
      nickname: '张三',
      signature: 'Just do it',
      gender: 'male',
      birthday: DateTime(1990, 1, 1),
      region: 'CN',
      email: 'a@b.com',
      avatar: Uint8List.fromList([1, 2, 3]),
    );
    final okIns = await repo.upsertProfile(p0);
    expect(okIns, isTrue);

    final fetched = await repo.getProfile();
    expect(fetched, isNotNull);
    expect(fetched!.nickname, '张三');
    expect(fetched.email, 'a@b.com');
    expect(fetched.avatar, isNotNull);

    // 观察流
    final first = await repo.watchProfile().first;
    expect(first, isNotNull);

    // 更新（尝试传 null 头像不会生效，由 clearAvatar 专职处理；仅修改昵称）
    final okUpd = await repo.upsertProfile(p0.copyWith(nickname: '李四'));
    expect(okUpd, isTrue);
    final afterUpd = await repo.getProfile();
    expect(afterUpd!.nickname, '李四');
    expect(afterUpd.avatar, isNotNull);

    // clearAvatar 专项
    final okClr = await repo.clearAvatar();
    expect(okClr, isTrue);
    final afterClr = await repo.getProfile();
    expect(afterClr!.avatar, isNull);
  });
}
