# 砚记(Inkboard) - 项目概览

## 项目简介

砚记(Inkboard)是一个极简主义的Markdown日记应用，采用Flutter跨平台技术开发，专为个人日常记录和思考而设计。项目追求"不被软件生态绑架"的理念，提供纯粹、专注的写作体验。

## 核心特性

- **Markdown支持**: 完整的Markdown编辑和预览功能
- **Facebook风格UI**: 现代化的卡片式界面设计
- **iOS原生动效**: 流畅的页面切换和交互动画
- **本地数据存储**: 安全的加密本地数据库
- **标签管理**: 灵活的日记分类和组织方式
- **全文搜索**: 快速查找历史日记内容

## 技术栈

- **框架**: Flutter 3.35.3-stable
- **状态管理**: Riverpod
- **数据库**: drift (加密SQLite)
- **路由**: go_router
- **架构**: Clean Architecture (三层架构)
- **开发方法**: 敏捷开发 + TDD测试驱动开发

## 项目结构

```
inkboard/
├── docs/                    # 项目文档
│   ├── requirements/        # 需求文档
│   │   └── PRD.md          # 产品需求文档
│   ├── architecture/        # 架构文档
│   │   └── ARCHITECTURE.md # 技术架构设计
│   ├── planning/           # 计划文档
│   │   └── AGILE_PLAN.md   # 敏捷开发计划
│   ├── testing/            # 测试文档
│   │   └── TDD_STRATEGY.md # TDD测试策略
│   └── development/        # 开发文档
│       └── CODING_STANDARDS.md # 开发规范
├── lib/                    # 源代码目录
├── test/                   # 测试代码目录
├── pubspec.yaml           # 项目配置
├── README.md              # 项目说明
└── .tool-versions         # 工具版本配置
```

## 开发计划

### 时间安排
- **总开发周期**: 12周 (3个月)
- **Sprint周期**: 2周/Sprint，共6个Sprint
- **发布策略**: MVP → 增量发布 → 完整版本

### Sprint规划

| Sprint | 时间 | 目标 | 状态 |
|--------|------|------|------|
| Sprint 1 | Week 1-2 | 项目基础设置 | ✅ 进行中 |
| Sprint 2 | Week 3-4 | 核心数据层开发 | 📋 计划中 |
| Sprint 3 | Week 5-6 | 基础UI和日记CRUD | 📋 计划中 |
| Sprint 4 | Week 7-8 | 搜索和标签功能 | 📋 计划中 |
| Sprint 5 | Week 9-10 | 高级UI和动画效果 | 📋 计划中 |
| Sprint 6 | Week 11-12 | 优化和发布准备 | 📋 计划中 |

## 文档完成情况

### ✅ 已完成文档

1. **产品需求文档 (PRD)** - `docs/requirements/PRD.md`
   - 产品定位和目标
   - 核心功能需求
   - UI/UX设计要求
   - 用户故事和验收标准

2. **技术架构设计** - `docs/architecture/ARCHITECTURE.md`
   - 系统架构设计
   - 技术栈选择
   - 数据模型设计
   - API接口定义

3. **敏捷开发计划** - `docs/planning/AGILE_PLAN.md`
   - Sprint详细规划
   - 风险管理策略
   - 项目时间线
   - 敏捷实践方法

4. **TDD测试策略** - `docs/testing/TDD_STRATEGY.md`
   - 测试金字塔设计
   - TDD实施流程
   - 测试用例设计规范
   - 持续测试流程

5. **开发规范** - `docs/development/CODING_STANDARDS.md`
   - 代码风格规范
   - 命名规范
   - 项目结构规范
   - Git工作流程

### 📋 下一步行动

根据敏捷开发计划，接下来的开发任务：

1. **依赖注入配置** - 设置get_it + injectable
2. **状态管理设置** - 配置Riverpod基础架构
3. **数据库基础** - 创建drift数据库schema
4. **测试环境** - 配置单元测试、Widget测试和集成测试
5. **CI/CD流水线** - 设置GitHub Actions自动化

## 快速开始

### 环境要求
- Flutter 3.35.3-stable
- Dart SDK
- iOS/Android开发环境

### 安装步骤
```bash
# 1. 克隆项目
git clone <repository-url>
cd inkboard

# 2. 安装依赖
flutter pub get

# 3. 运行应用
flutter run
```

### 开发命令
```bash
# 运行测试
flutter test

# 生成代码覆盖率
flutter test --coverage

# 代码静态分析
flutter analyze

# 代码格式化
dart format lib/ test/
```

### 发布准备（图标与启动页）
```bash
# 准备资源：
# - 将应用图标放置到 assets/icon/icon.png
# - 将启动页图片放置到 assets/splash.png

# 生成应用图标
flutter pub get
dart run flutter_launcher_icons

# 生成原生启动页
dart run flutter_native_splash:create
```

## 质量保证

### 测试覆盖目标
- **单元测试覆盖率**: > 80%
- **关键业务逻辑**: 100%
- **UI组件覆盖率**: > 70%

### 性能指标
- **应用启动时间**: < 3秒
- **页面切换动画**: 保持60fps
- **内存使用**: < 100MB
- **数据库查询**: < 500ms

## 贡献指南

本项目为个人项目，但欢迎提供建议和反馈。请查看以下文档：

- [开发规范](docs/development/CODING_STANDARDS.md)
- [架构设计](docs/architecture/ARCHITECTURE.md)
- [测试策略](docs/testing/TDD_STRATEGY.md)

## 许可证

本项目仅供个人使用和学习参考。

## 联系信息

- **项目作者**: 成东杰
- **项目性质**: 个人项目
- **开发理念**: 不被软件生态绑架，专注纯粹的写作体验

---

**最后更新**: 2025-09-22
**文档状态**: 敏捷开发前置文档已完成，可以开始Sprint 1开发工作
