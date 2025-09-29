import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/user_profile.dart';
import 'package:inkboard/domain/repositories/user_profile_repository.dart';
import 'package:inkboard/presentation/pages/diary_edit_page.dart';

class _FakeUserProfileRepo implements UserProfileRepository {
  final UserProfile _p = const UserProfile(
    id: 1,
    nickname: '昵称X',
    signature: '签名Y',
    email: 'x@example.com',
    region: '地球',
  );

  @override
  Future<bool> clearAvatar() async => true;

  @override
  Future<UserProfile?> getProfile() async => _p;

  @override
  Future<bool> upsertProfile(UserProfile profile) async => true;

  @override
  Stream<UserProfile?> watchProfile() async* {
    yield _p;
  }
}

void main() {
  Future<void> _pumpEditor(WidgetTester tester) async {
    await getIt.reset();
    getIt.registerSingleton<UserProfileRepository>(_FakeUserProfileRepo());

    tester.view.physicalSize = const Size(390, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 800),
          builder: (context, _) => const MaterialApp(home: DiaryEditPage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('插入资料：昵称插入到光标处', (tester) async {
    await _pumpEditor(tester);

    final contentField = find.byType(TextFormField).last;
    await tester.tap(contentField);
    await tester.pump();

    // 打开“插入资料”菜单并选择“插入昵称”
    await tester.tap(find.byTooltip('插入资料'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('插入昵称'));
    await tester.pump();

    // 断言：文本域包含昵称
    final textField = tester.widget<TextFormField>(contentField);
    expect(textField.controller!.text.contains('昵称X'), isTrue);
  });
}

