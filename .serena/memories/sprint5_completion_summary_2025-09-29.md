Sprint 5 完成内容（搜索与标签）：
- 收藏切换：在 lib/presentation/pages/home_page.dart 中实现 _toggleFavorite，接入 UpdateDiaryEntryUseCase.toggleFavorite，UI Snackbar 反馈。
- 全局搜索：新增 lib/presentation/pages/search_page.dart，顶部 AppBar 搜索框回车跳转；支持全局搜索与简单高亮、以及高级筛选（日期范围、仅收藏）。facebook_layout 搜索框 onSubmitted 导航到 SearchPage。
- 标签管理：新增 lib/presentation/pages/tag_management_page.dart，支持列表、搜索、新建、编辑、删除（防默认标签删除），基于 TagManagementUseCase。
- 收藏夹页面：新增 lib/presentation/pages/favorites_page.dart，基于 favoriteDiaryEntriesProvider。
- 导出 Markdown：新增 lib/presentation/pages/export_page.dart，生成 Markdown 并支持复制到剪贴板（无需插件）。
- 左侧栏入口：facebook_left_sidebar.dart 接入上述页面的导航。
- 文档：AGILE_PLAN.md 将 Sprint3/4/5 状态标为已完成。
- 验证：flutter analyze 无问题；flutter test 全部通过。