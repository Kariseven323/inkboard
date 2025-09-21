已将 CI 覆盖率阈值从 80% 提升至 90%，并通过新增测试将本地覆盖率提升至 92.52%。
修改点：
- .github/workflows/flutter_ci.yml：COVERAGE_THRESHOLD=90.0
- 新增测试：
  - test/text_styles_coverage_test.dart（覆盖 FacebookTextStyles 大量 getter）
  - test/sizes_coverage_test.dart（覆盖 FacebookSizes 多数 getter）
  - test/theme_components_test.dart（Material 组件冒烟覆盖，触发主题配置分支）
  - test/theme_utils_test.dart（isDarkTheme/getAdaptiveColor）
  - test/colors_functions_test.dart（ColorScheme工厂覆盖）
- 文档：docs/planning/AGILE_PLAN.md
  - DoD 勾选静态分析与覆盖率>90%与文档更新
  - 将成功定义中的覆盖率标准从>80%更新为>90%
备注：未勾选“代码Review完成”“功能演示完成”。后续可增加 PR 模板与演示素材。