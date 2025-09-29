Sprint 6 完成摘要（2025-09-29）

实现内容：
- 动效与转场：Home->Edit 使用 CupertinoPageRoute；FacebookDiaryCard 与 DiaryEditPage 添加 Hero（avatar/title）。
- 列表动画与交互：主页列表项入场淡入+位移；支持 Dismissible 滑动删除（带确认）；长按 BottomSheet 菜单。
- 触觉反馈：收藏、删除、导航、保存等关键交互调用 HapticFeedback。
- 设置页：新增 SettingsPage（主题模式切换、字体缩放、导出入口）；新增 textScaleProvider 并在 MaterialApp.builder 全局应用。
- 发布准备：在 pubspec.yaml 配置 flutter_launcher_icons 与 flutter_native_splash；README 增加生成命令；AGILE_PLAN.md 标记 Sprint 6 完成与完成说明。

后续建议：
- 补充应用图标与启动页素材到 assets/ 并执行生成命令；完善签名与商店提交流程。
- 可考虑丰富列表滚动时的延迟/交错动画、细化 iOS 手势细节。
- 运行 flutter test 验证所有测试通过，必要时补测试覆盖动画与设置页流程。