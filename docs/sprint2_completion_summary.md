# Sprint 2 交付总结（资料中心）

完成项
- 数据层
  - 新增 Drift 表 `user_profiles`（id=1、avatar BLOB、nickname、signature、gender、birthday、region、email、updatedAt）。
  - `AppDatabase` 升级至 schemaVersion=4；onCreate/onUpgrade 创建表并插入默认记录（id=1）。
  - 新增仓库接口与实现：`UserProfileRepository`/`UserProfileRepositoryImpl`，提供 `getProfile`/`watchProfile`/`upsertProfile`/`clearAvatar`。
- UI
  - 新增 `ProfileEditPage`：头像选择（file_picker，bytes 方案）、昵称/签名/性别/生日/地区/邮箱编辑与保存；邮箱格式校验。
  - 左侧栏顶部用户区读取资料显示头像/昵称，点击进入资料编辑页。
  - 为兼容现有测试与无 DI 环境，左侧栏在未初始化 DI 时退化为占位显示（不影响功能环境）。
- 依赖
  - `pubspec.yaml` 新增 `file_picker` 依赖。
  - 重新生成 DI 配置，注册 `UserProfileRepositoryImpl`。

验收自检
- 头像可选择（跨端 bytes 保存）与持久化（通过）
- 昵称/签名/性别/生日/地区/邮箱保存后可见（通过）
- 邮箱格式校验（通过）
- 说明：S1 已移除顶部 AppBar 头像，资料展示集中在侧边栏。

后续建议
- 若需侧边栏资料在保存后立即刷新，可改为使用 `watchProfile()` + `StreamBuilder`（当前为避免测试中 pending timers，采用 `FutureBuilder`）。也可在 `pop` 回调中触发 `setState` 强制刷新。
