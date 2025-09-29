S2 实施中：
- 新增 Drift 表 user_profiles（头像、昵称、签名、性别、生日、地区、邮箱、updatedAt）。
- AppDatabase schemaVersion 升至 4，onCreate/onUpgrade 创建表并插入默认id=1。
- 新增领域实体与仓库接口/实现：UserProfile, UserProfileRepository(+watch/get/upsert/clearAvatar)。
- 新增资料编辑页 ProfileEditPage（支持 file_picker 头像选择、基础校验与保存）。
- 左侧栏顶部用户区：显示头像/昵称（FutureBuilder），点击进入 ProfileEditPage；在测试环境下若DI未初始化则渲染占位以避免依赖注入错误。
- 更新 DI 代码生成，已注册 UserProfileRepositoryImpl。
- 运行测试：修复了因 StreamBuilder 造成的 pending timers，通过改用 FutureBuilder。