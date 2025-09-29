项目 inkboard（Flutter+Riverpod+Drift）多 Sprint 改造路线：

核心需求：
- 主题：深/浅色模式完善（已存在 ThemeProvider 但需完善调色与入口）。
- 布局：移除顶部 f 图标、通知/主页/设置图标；保留顶部搜索；左侧移除“高级搜索”“我的日记”；侧边栏“设置”修复跳转；侧栏头像点击进入资料编辑。
- 资料：新增用户资料（头像Blob、昵称、签名、其它可选信息），资料编辑页，file_picker 选择头像；Riverpod Provider 全局读写。
- 编辑器：日记“暂存”按钮与草稿状态；一键插入个人信息（在 Markdown 文本框内插入片段）。
- 回收站：DiaryEntries 表新增软删除字段（deletedAt 或 isDeleted），侧边栏入口，支持恢复/清空。

建议库：
- Drift 迁移（stepByStep / addColumn / alterTable.columnTransformer）。
- file_picker 跨平台选图（web 使用 bytes）。
- markdown_widget 夜间配置；保留现有渲染链路。

Sprint 粗排：
- S1（UI清理+主题）：移除 Facebook 化元素、完善主题与入口、整合搜索、修复设置跳转。
- S2（用户资料）：表+仓库+Provider+资料编辑页+头像上传与展示。
- S3（编辑器增强）：草稿与暂存流、多端插入个人信息。
- S4（回收站）：软删除字段与查询、回收站页面、恢复/彻底删除、批量操作。
- S5（验收与文档）：迁移与兼容性测试、集成测试、说明文档与上线清单。

待确认：支持平台范围、资料字段清单、回收站保留期、是否需要自动保存、主题默认跟随系统或固定。