覆盖率里程碑更新：
- 60%：已达成（先前约 62.9%）
- 80%：已达成（过滤后≈80.73%）

关键动作：
- 新增测试：
  - test/home_page_actions_test.dart（收藏操作触发用例、分享按钮路径）
  - test/home_page_longpress_test.dart（长按弹出底部操作单、选择“编辑日记”跳转）
  - test/search_page_test.dart（初始查询显示结果、错误态、空态与高级筛选控件可见）
  - 其余补测：providers、usecases、导出页等
- 修正过滤逻辑：scripts/coverage.sh 现在会按 coverage_exclude.lst 整段过滤匹配的 SF: 文件到 end_of_record，Filtered 覆盖率计算正确。
- 过滤项：*.g.dart、service_locator.config.dart、lib/main.dart、lib/data/tables/**、lib/data/database/**（保持与用户确认一致）

下一步建议（冲刺90%）：
- HomePage：补充更多交互（取消收藏分支、删除失败分支等）
- SearchPage：覆盖更多结果列表分支与高亮片段、更多错误分支
- 用例层：补齐 search_diary_usecase 边界，AdvancedSearchParams.hasAnyCondition 测试
