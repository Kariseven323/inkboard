执行了Sprint1整改：
- CI增加覆盖率门禁（阈值80%），在 .github/workflows/flutter_ci.yml 中加入 Python 检查步骤
- 新增测试：test/facebook_layout_test.dart（导航/图标存在）、test/theme_test.dart（主题 token 对齐）
- 同步勾选 docs/planning/AGILE_PLAN.md 的 Sprint1 Backlog 完成项
后续建议：逐步将覆盖率阈值提升至90%，补充更多组件测试用例与响应式断点覆盖，添加PR模板/代码评审流程说明