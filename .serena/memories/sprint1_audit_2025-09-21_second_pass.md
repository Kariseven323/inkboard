Sprint1严格审计（基于暂存区）
结论：Sprint1 Backlog全部具备交付物（100%）；DoD存在缺口（测试覆盖率、评审流程），综合评分：92/100。
证据要点：
- 依赖注入：build.yaml（injectable_builder）、service_locator.dart、service_locator.config.dart；CI含build_runner步骤
- Riverpod：pubspec含flutter_riverpod，main.dart以ProviderScope包裹
- 设计系统：facebook_colors/sizes/text_styles/theme四件套，Material3配置
- 三栏布局：presentation/layouts/facebook_layout.dart + 左右侧栏组件
- 测试：integration_test/smoke_test.dart 与 widget_test；CI含 analyze 与 test --coverage
- 代码质量：analysis_options.yaml含flutter_lints
不足：
- DoD> 覆盖率未达90%，未见覆盖阈值门禁；评审流程未体现；AGILE_PLAN.md sprint backlog未同步打勾
整改建议：
- 在CI增加覆盖率阈值检查；加入golden test与关键组件widget test；补充PR模板/评审人；同步文档勾选进度
