CI评估：
- 工作流：checkout@v4 + subosito/flutter-action@v2 + build_runner + analyze + test --coverage + 自定义Python阈值检查(默认90%) + 上传过滤后lcov。
- 仓库现状：
  - scripts/filter_lcov.py 存在并正确过滤 g.dart、平台生成文件等。
  - build.yaml 与 injectable_generator/dev依赖齐全；service_locator.config.dart 和 app_database.g.dart 已存在。
  - 测试数量充足；部分专为覆盖率(文本样式/尺寸)补测文件存在。
  - 记忆显示：flutter analyze 已归零；之前“全部测试通过”在Sprint5完成摘要中出现。
  - 覆盖率记忆：过滤后≈80.73%（需继续冲刺至≥90%）。
- 风险点：覆盖率阈值90%，若当前增量测试未达标将导致CI失败。
- 建议：先本地运行 flutter test --coverage && python3 scripts/filter_lcov.py 并用CI同款Python代码校验阈值；如低于90%，优先补测核心用例与边界分支（SearchPage与UseCase错误分支等）。
