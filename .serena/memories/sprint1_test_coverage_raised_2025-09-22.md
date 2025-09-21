通过新增高价值测试将覆盖率提升至82.09%（>80%门禁）：
- 新增：test/responsive_layout_test.dart（移动端抽屉打开验证左右侧栏）
- 新增：test/sidebars_content_test.dart（侧栏菜单与右栏内容覆盖）
- 新增：test/service_locator_test.dart（DI注册与获取）
- 新增：test/theme_dark_test.dart（暗色主题分支，ScreenUtilInit支持）
- 现有：test/theme_test.dart, test/facebook_layout_test.dart, test/widget_test.dart
注意：FacebookSizes 断点使用了 ScreenUtil 的 .w 缩放，导致断点随屏幕自适应而放大，测试环境下一直走移动端分支；已在测试中通过打开 Drawer 的方式验证侧栏内容，不改动生产代码。建议后续修正断点计算逻辑（断点用逻辑px而非缩放值）。