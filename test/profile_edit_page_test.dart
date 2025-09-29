import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/user_profile.dart';
import 'package:inkboard/domain/repositories/user_profile_repository.dart';
import 'package:inkboard/presentation/pages/profile_edit_page.dart';

void main() {
  setUpAll(() async {
    // 使用 Fake 仓库，避免依赖真实数据库/插件导致用例阻塞
    await getIt.reset(dispose: true);
    getIt.registerLazySingleton<UserProfileRepository>(
      () => _FakeUserProfileRepository(),
    );
  });

  testWidgets('ProfileEditPage: 表单校验与保存资料', (tester) async {
    // 放大测试视口，避免 ListView 子项未构建导致找不到输入框
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(800, 1600);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: ProfileEditPage()),
        ),
      ),
    );
    // 使用固定时长的 pump，避免受第三方定时器/平台通道干扰导致 settle 卡住
    await tester.pump(const Duration(milliseconds: 200));

    // 输入昵称（通过 Key 定位）
    final nicknameField = find.byKey(const ValueKey('profile_nickname_field'));
    final nickEditable = find.descendant(
      of: nicknameField,
      matching: find.byType(EditableText),
    );
    await tester.enterText(nickEditable, '小明');
    await tester.pump();

    // 输入邮箱并保存
    // 输入邮箱（通过 Key 定位）
    final emailField = find.byKey(const ValueKey('profile_email_field'));
    final emailEditable = find.descendant(
      of: emailField,
      matching: find.byType(EditableText),
    );
    await tester.enterText(emailEditable, 'a@b.com');
    await tester.pump();
    await tester.tap(find.widgetWithText(TextButton, '保存'));
    // 避免受 SnackBar/异步定时器影响导致 settle 阻塞，使用定时 pump
    await tester.pump(const Duration(milliseconds: 600));

    // 读取仓库确认持久化
    final repo = getIt<UserProfileRepository>();
    final p = await repo.getProfile();
    expect(p, isNotNull);
    expect(p!.nickname, equals('小明'));
    expect(p.email, equals('a@b.com'));

    // 卸载页面以触发 dispose，避免定时器挂起测试
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 200));
  });
}

class _FakeUserProfileRepository implements UserProfileRepository {
  UserProfile? _p = const UserProfile(id: 1);

  @override
  Future<bool> clearAvatar() async {
    _p = _p?.copyWith(avatar: null, updatedAt: DateTime.now());
    return true;
  }

  @override
  Future<UserProfile?> getProfile() async => _p;

  @override
  Stream<UserProfile?> watchProfile() async* {
    yield _p;
  }

  @override
  Future<bool> upsertProfile(UserProfile profile) async {
    _p = profile.copyWith(updatedAt: DateTime.now());
    return true;
  }
}
