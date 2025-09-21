# 砚记(Inkboard) - 技术架构设计文档

## 1. 架构概述

### 1.1 整体架构
砚记采用基于Flutter的Clean Architecture架构模式，确保代码的可维护性、可测试性和可扩展性。

### 1.2 设计原则
- **单一职责原则**: 每个类和模块只负责一个功能
- **依赖倒置原则**: 高层模块不依赖低层模块，都依赖于抽象
- **开放封闭原则**: 对扩展开放，对修改封闭
- **接口隔离原则**: 客户端不应依赖它不需要的接口

## 2. 系统架构

### 2.1 三层架构

```
┌─────────────────────────────────────┐
│             Presentation            │
│        (UI/Widgets/Pages)           │
├─────────────────────────────────────┤
│             Domain                  │
│    (Business Logic/Use Cases)       │
├─────────────────────────────────────┤
│             Data                    │
│    (Repository/Data Sources)        │
└─────────────────────────────────────┘
```

#### 2.1.1 Presentation Layer (表现层)
- **职责**: 用户界面、用户交互、状态管理
- **组件**: Pages, Widgets, Controllers, State Management
- **依赖**: 仅依赖Domain层

#### 2.1.2 Domain Layer (业务层)
- **职责**: 业务逻辑、用例定义、实体模型
- **组件**: Entities, Use Cases, Repository Interfaces
- **依赖**: 无外部依赖，纯业务逻辑

#### 2.1.3 Data Layer (数据层)
- **职责**: 数据存储、数据访问、外部API调用
- **组件**: Repository Implementations, Data Sources, Models
- **依赖**: 依赖Domain层的接口

### 2.2 详细架构图

```
Presentation Layer
├── pages/
│   ├── home/
│   │   ├── home_page.dart
│   │   └── widgets/
│   ├── editor/
│   │   ├── editor_page.dart
│   │   └── widgets/
│   └── settings/
│       ├── settings_page.dart
│       └── widgets/
├── controllers/
│   ├── home_controller.dart
│   ├── editor_controller.dart
│   └── settings_controller.dart
└── shared/
    ├── widgets/
    ├── themes/
    └── constants/

Domain Layer
├── entities/
│   ├── diary_entry.dart
│   ├── tag.dart
│   └── user_preferences.dart
├── repositories/
│   ├── diary_repository.dart
│   ├── tag_repository.dart
│   └── preferences_repository.dart
└── usecases/
    ├── diary/
    │   ├── create_diary_entry.dart
    │   ├── get_diary_entries.dart
    │   ├── update_diary_entry.dart
    │   └── delete_diary_entry.dart
    ├── tag/
    │   ├── create_tag.dart
    │   ├── get_tags.dart
    │   └── delete_tag.dart
    └── search/
        └── search_diary_entries.dart

Data Layer
├── repositories/
│   ├── diary_repository_impl.dart
│   ├── tag_repository_impl.dart
│   └── preferences_repository_impl.dart
├── datasources/
│   ├── local/
│   │   ├── diary_local_datasource.dart
│   │   ├── tag_local_datasource.dart
│   │   └── database/
│   │       ├── app_database.dart
│   │       └── tables/
│   └── remote/ (future)
└── models/
    ├── diary_entry_model.dart
    ├── tag_model.dart
    └── mappers/
```

## 3. 技术栈选择

### 3.1 核心框架
- **Flutter**: 3.35.3-stable (跨平台移动应用框架)
- **Dart**: 最新稳定版本

### 3.2 状态管理
**选择**: Riverpod
**理由**:
- 编译时安全
- 优秀的测试支持
- 自动依赖管理
- 良好的开发者体验

**替代方案考虑**:
- Provider: 功能较基础
- Bloc: 样板代码较多
- GetX: 过于魔法化

### 3.3 数据存储
**选择**: drift (原moor)
**理由**:
- 类型安全的SQL查询
- 优秀的性能
- 支持加密
- 活跃的社区维护

**替代方案考虑**:
- sqflite: 较为底层，开发效率低
- hive: 性能优秀但查询能力有限
- isar: 新兴数据库，生态不够成熟

### 3.4 路由管理
**选择**: go_router
**理由**:
- 声明式路由
- 深度链接支持
- 类型安全
- Flutter团队官方推荐

### 3.5 UI组件和动画
**选择方案**:
- Material Design 3
- flutter_animate (动画库)
- flutter_staggered_animations (列表动画)

### 3.6 Markdown处理
**选择**: flutter_markdown + markdown
**理由**:
- Flutter官方维护
- 功能完整
- 性能优秀
- 自定义能力强

### 3.7 依赖注入
**选择**: get_it + injectable
**理由**:
- 编译时依赖注入
- 支持代码生成
- 与Riverpod配合良好

## 4. 数据模型设计

### 4.1 核心实体

#### 4.1.1 DiaryEntry (日记条目)
```dart
class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final DiaryEntryStatus status;
}

enum DiaryEntryStatus {
  draft,
  published,
  archived
}
```

#### 4.1.2 Tag (标签)
```dart
class Tag {
  final String id;
  final String name;
  final String color;
  final DateTime createdAt;
  final int entryCount;
}
```

#### 4.1.3 UserPreferences (用户偏好)
```dart
class UserPreferences {
  final ThemeMode themeMode;
  final double fontSize;
  final String fontFamily;
  final bool enableHapticFeedback;
  final bool enableAutoSave;
  final Duration autoSaveInterval;
}
```

### 4.2 数据库设计

#### 4.2.1 表结构
```sql
-- 日记表
CREATE TABLE diary_entries (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    is_favorite INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'published'
);

-- 标签表
CREATE TABLE tags (
    id TEXT PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    color TEXT NOT NULL,
    created_at INTEGER NOT NULL
);

-- 日记标签关联表
CREATE TABLE diary_entry_tags (
    diary_entry_id TEXT NOT NULL,
    tag_id TEXT NOT NULL,
    PRIMARY KEY (diary_entry_id, tag_id),
    FOREIGN KEY (diary_entry_id) REFERENCES diary_entries(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- 用户偏好表
CREATE TABLE user_preferences (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
```

#### 4.2.2 索引设计
```sql
-- 时间索引
CREATE INDEX idx_diary_entries_created_at ON diary_entries(created_at DESC);
CREATE INDEX idx_diary_entries_updated_at ON diary_entries(updated_at DESC);

-- 收藏索引
CREATE INDEX idx_diary_entries_favorite ON diary_entries(is_favorite, created_at DESC);

-- 全文搜索索引
CREATE VIRTUAL TABLE diary_entries_fts USING fts5(
    title, content, content='diary_entries', content_rowid='rowid'
);
```

## 5. API设计

### 5.1 Repository接口

#### 5.1.1 DiaryRepository
```dart
abstract class DiaryRepository {
  Future<List<DiaryEntry>> getAllEntries({
    int? limit,
    int? offset,
    List<String>? tags,
    DiaryEntryStatus? status,
  });

  Future<DiaryEntry?> getEntryById(String id);

  Future<List<DiaryEntry>> searchEntries(String query);

  Future<String> createEntry(CreateDiaryEntryParams params);

  Future<void> updateEntry(String id, UpdateDiaryEntryParams params);

  Future<void> deleteEntry(String id);

  Future<List<DiaryEntry>> getFavoriteEntries();

  Future<void> toggleFavorite(String id);

  Stream<List<DiaryEntry>> watchAllEntries();
}
```

#### 5.1.2 TagRepository
```dart
abstract class TagRepository {
  Future<List<Tag>> getAllTags();

  Future<Tag?> getTagById(String id);

  Future<String> createTag(CreateTagParams params);

  Future<void> updateTag(String id, UpdateTagParams params);

  Future<void> deleteTag(String id);

  Future<List<Tag>> getTagsForEntry(String entryId);

  Stream<List<Tag>> watchAllTags();
}
```

### 5.2 Use Cases

#### 5.2.1 日记相关用例
```dart
class CreateDiaryEntry {
  final DiaryRepository repository;

  CreateDiaryEntry(this.repository);

  Future<String> call(CreateDiaryEntryParams params) async {
    // 业务逻辑验证
    if (params.title.trim().isEmpty) {
      throw ValidationException('标题不能为空');
    }

    // 调用repository
    return await repository.createEntry(params);
  }
}

class GetDiaryEntries {
  final DiaryRepository repository;

  GetDiaryEntries(this.repository);

  Future<List<DiaryEntry>> call(GetDiaryEntriesParams params) async {
    return await repository.getAllEntries(
      limit: params.limit,
      offset: params.offset,
      tags: params.tags,
      status: params.status,
    );
  }
}
```

## 6. 状态管理架构

### 6.1 Riverpod Provider结构

```dart
// Repository Providers
final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepositoryImpl(
    localDataSource: ref.watch(diaryLocalDataSourceProvider),
  );
});

// Use Case Providers
final createDiaryEntryProvider = Provider<CreateDiaryEntry>((ref) {
  return CreateDiaryEntry(ref.watch(diaryRepositoryProvider));
});

// State Providers
final diaryEntriesProvider = StateNotifierProvider<DiaryEntriesNotifier, AsyncValue<List<DiaryEntry>>>((ref) {
  return DiaryEntriesNotifier(
    getDiaryEntries: ref.watch(getDiaryEntriesProvider),
  );
});

// UI State Providers
final selectedEntryProvider = StateProvider<DiaryEntry?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');
```

### 6.2 State Management流程

```
User Action → Controller → Use Case → Repository → Data Source
     ↓                                                   ↓
UI Update ← State Notifier ← Repository ← Data Source ←----
```

## 7. 安全设计

### 7.1 数据加密
- **方案**: 使用drift的加密功能
- **密钥管理**: 使用flutter_secure_storage存储加密密钥
- **生物识别**: 集成local_auth进行Touch ID/Face ID验证

### 7.2 数据备份
- **本地备份**: 定期导出Markdown文件
- **数据完整性**: 数据库事务保证
- **恢复机制**: 支持从Markdown文件导入

## 8. 性能优化

### 8.1 数据库优化
- 使用适当的索引
- 分页加载数据
- 缓存频繁访问的数据
- 使用数据库连接池

### 8.2 UI性能优化
- 使用ListView.builder进行列表虚拟化
- 图片懒加载和缓存
- 避免不必要的Widget重建
- 使用Cached网络请求

### 8.3 内存管理
- 及时释放未使用的资源
- 使用WeakReference避免内存泄漏
- 监控内存使用情况

## 9. 测试策略

### 9.1 测试金字塔

```
     E2E Tests (5%)
    ┌─────────────┐
   │               │
  │  Integration    │ (15%)
 │     Tests        │
│                   │
└───────────────────┘
      Unit Tests (80%)
```

### 9.2 测试类型

#### 9.2.1 Unit Tests
- Repository层测试
- Use Case层测试
- Utility函数测试
- Model层测试

#### 9.2.2 Widget Tests
- 页面Widget测试
- 自定义Widget测试
- 交互逻辑测试

#### 9.2.3 Integration Tests
- 完整功能流程测试
- 数据库集成测试
- 状态管理集成测试

## 10. 依赖配置

### 10.1 核心依赖
```yaml
dependencies:
  flutter:
    sdk: flutter

  # 状态管理
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.2.0

  # 数据库
  drift: ^2.12.0
  sqlite3_flutter_libs: ^0.5.0

  # 路由
  go_router: ^11.0.0

  # Markdown
  flutter_markdown: ^0.6.0
  markdown: ^7.1.0

  # UI
  flutter_animate: ^4.2.0
  flutter_staggered_animations: ^1.1.0

  # 工具
  get_it: ^7.6.0
  injectable: ^2.2.0
  uuid: ^4.0.0

  # 安全
  flutter_secure_storage: ^9.0.0
  local_auth: ^2.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

  # 代码生成
  riverpod_generator: ^2.3.0
  build_runner: ^2.4.0
  drift_dev: ^2.12.0
  injectable_generator: ^2.2.0

  # 测试
  mockito: ^5.4.0
  integration_test:
    sdk: flutter
```

## 11. 项目结构

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   └── di/
├── data/
│   ├── datasources/
│   ├── models/
│   ├── repositories/
│   └── database/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── pages/
│   ├── widgets/
│   ├── controllers/
│   └── themes/
└── shared/
    ├── widgets/
    ├── constants/
    └── extensions/

test/
├── unit/
├── widget/
└── integration/

docs/
├── architecture/
├── requirements/
├── planning/
├── testing/
└── development/
```

---

**文档版本**: v1.0
**创建日期**: 2025-09-22
**最后更新**: 2025-09-22
**作者**: 成东杰