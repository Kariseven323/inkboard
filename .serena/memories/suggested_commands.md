# 砚记项目开发命令参考

## 基本开发命令

### 依赖管理
```bash
# 安装依赖
flutter pub get

# 清理依赖
flutter clean && flutter pub get
```

### 代码质量
```bash
# 静态代码分析
flutter analyze

# 代码格式化
dart format lib/ test/

# 代码生成
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 测试命令
```bash
# 运行所有测试
flutter test

# 运行单元测试
flutter test test/unit/

# 运行Widget测试
flutter test test/widget/

# 运行集成测试
flutter test integration_test/

# 生成测试覆盖率
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 运行应用
```bash
# 调试模式运行
flutter run

# 发布模式运行
flutter run --release

# 指定设备运行
flutter run -d ios
flutter run -d android
```

### 构建应用
```bash
# 构建Android APK
flutter build apk

# 构建iOS
flutter build ios

# 构建Web
flutter build web
```

## 当前Sprint 1任务命令

### 数据库相关
```bash
# 生成drift数据库代码
flutter packages pub run build_runner build
```

### 依赖注入相关
```bash
# 生成injectable代码
flutter packages pub run build_runner build
```

### 状态管理相关
```bash
# 生成riverpod代码
flutter packages pub run build_runner build
```