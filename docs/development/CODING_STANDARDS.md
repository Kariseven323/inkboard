# 砚记(Inkboard) - 开发规范与代码标准

## 1. 代码风格规范

### 1.1 Dart代码风格

#### 1.1.1 基本格式化
遵循[Dart Style Guide](https://dart.dev/guides/language/effective-dart)标准：

```dart
// 正确：使用2个空格缩进
class DiaryEntry {
  final String id;
  final String title;

  DiaryEntry({
    required this.id,
    required this.title,
  });
}

// 错误：使用4个空格或tab缩进
class DiaryEntry {
    final String id;
    final String title;
}
```

#### 1.1.2 行长度限制
- **最大行长度**: 80字符
- **建议行长度**: 避免超过80字符的行
- **例外情况**: 字符串、URL、import语句可以适当超长

```dart
// 正确：合理换行
final String longVariableName = someMethodCall(
  parameter1,
  parameter2,
  parameter3,
);

// 错误：单行过长
final String longVariableName = someMethodCall(parameter1, parameter2, parameter3, parameter4);
```

### 1.2 代码组织

#### 1.2.1 文件结构
```dart
// 1. 版权信息（如需要）
// Copyright (c) 2025 UltraThink. All rights reserved.

// 2. package导入
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 3. 本地相对导入
import '../entities/diary_entry.dart';
import '../repositories/diary_repository.dart';

// 4. 类型定义
typedef DiaryEntryCallback = void Function(DiaryEntry entry);

// 5. 常量定义
const int maxTitleLength = 100;

// 6. 主要类定义
class DiaryService {
  // 类实现
}
```

#### 1.2.2 类内部组织
```dart
class DiaryEntry {
  // 1. 静态常量
  static const int maxContentLength = 50000;

  // 2. 静态变量
  static int _instanceCount = 0;

  // 3. 实例变量
  final String id;
  final String title;
  late final String _processedContent;

  // 4. 构造函数
  DiaryEntry({
    required this.id,
    required this.title,
    required String content,
  }) : _processedContent = _processContent(content);

  // 5. 命名构造函数
  DiaryEntry.empty() : this(
    id: '',
    title: '',
    content: '',
  );

  // 6. Getter/Setter
  String get content => _processedContent;

  // 7. 公共方法
  void updateTitle(String newTitle) {
    // 实现
  }

  // 8. 私有方法
  static String _processContent(String content) {
    return content.trim();
  }
}
```

## 2. 命名规范

### 2.1 通用命名规则

#### 2.1.1 基本原则
- **清晰性**: 名称应该清楚表达用途
- **简洁性**: 避免不必要的冗长
- **一致性**: 整个项目保持一致的命名风格
- **避免缩写**: 除非是行业通用缩写

#### 2.1.2 命名风格

| 类型 | 风格 | 示例 |
|------|------|------|
| 类名 | PascalCase | `DiaryEntry`, `UserPreferences` |
| 方法名 | camelCase | `createEntry`, `updateContent` |
| 变量名 | camelCase | `entryId`, `createdAt` |
| 常量 | camelCase | `maxTitleLength`, `defaultTheme` |
| 私有变量 | _camelCase | `_isLoading`, `_cachedData` |
| 文件名 | snake_case | `diary_entry.dart`, `home_page.dart` |
| 文件夹名 | snake_case | `use_cases`, `data_sources` |

### 2.2 特定类型命名

#### 2.2.1 Widget命名
```dart
// 页面Widget：以Page结尾
class HomePage extends StatelessWidget {}
class EditorPage extends StatefulWidget {}

// 组件Widget：描述性名称
class DiaryEntryCard extends StatelessWidget {}
class MarkdownEditor extends StatefulWidget {}

// 通用Widget：功能描述
class LoadingIndicator extends StatelessWidget {}
class ErrorMessage extends StatelessWidget {}
```

#### 2.2.2 状态管理命名
```dart
// Provider命名
final diaryEntriesProvider = StateNotifierProvider<...>(...);
final selectedEntryProvider = StateProvider<...>(...);

// Notifier命名
class DiaryEntriesNotifier extends StateNotifier<...> {}
class SearchNotifier extends StateNotifier<...> {}

// State类命名
class DiaryEntriesState {
  final List<DiaryEntry> entries;
  final bool isLoading;
  final String? errorMessage;
}
```

#### 2.2.3 数据层命名
```dart
// Repository接口
abstract class DiaryRepository {}
abstract class TagRepository {}

// Repository实现
class DiaryRepositoryImpl implements DiaryRepository {}
class TagRepositoryImpl implements TagRepository {}

// DataSource命名
abstract class DiaryLocalDataSource {}
class DiaryLocalDataSourceImpl implements DiaryLocalDataSource {}

// Model命名
class DiaryEntryModel {
  // 包含fromEntity和toEntity方法
}
```

#### 2.2.4 UseCase命名
```dart
// UseCase使用动词开头
class CreateDiaryEntry {}
class GetDiaryEntries {}
class UpdateDiaryEntry {}
class DeleteDiaryEntry {}
class SearchDiaryEntries {}

// 参数类命名
class CreateDiaryEntryParams {}
class GetDiaryEntriesParams {}
```

### 2.3 布尔变量命名
```dart
// 正确：使用is、has、can、should等前缀
bool isLoading = false;
bool hasError = false;
bool canEdit = true;
bool shouldAutoSave = true;

// 错误：不清晰的布尔命名
bool loading = false;
bool error = false;
bool edit = true;
```

## 3. 项目结构规范

### 3.1 目录结构

```
lib/
├── main.dart                    # 应用入口
├── app.dart                     # 应用配置
├── core/                        # 核心功能
│   ├── constants/              # 常量定义
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── ui_constants.dart
│   ├── errors/                 # 错误定义
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── extensions/             # 扩展方法
│   │   ├── string_extensions.dart
│   │   └── datetime_extensions.dart
│   ├── utils/                  # 工具类
│   │   ├── date_utils.dart
│   │   ├── validators.dart
│   │   └── logger.dart
│   └── di/                     # 依赖注入
│       ├── injection.dart
│       └── injection.config.dart
├── data/                       # 数据层
│   ├── datasources/           # 数据源
│   │   ├── local/
│   │   │   ├── diary_local_datasource.dart
│   │   │   └── database/
│   │   │       ├── app_database.dart
│   │   │       ├── tables/
│   │   │       └── daos/
│   │   └── remote/            # 预留远程数据源
│   ├── models/                # 数据模型
│   │   ├── diary_entry_model.dart
│   │   ├── tag_model.dart
│   │   └── mappers/
│   └── repositories/          # Repository实现
│       ├── diary_repository_impl.dart
│       └── tag_repository_impl.dart
├── domain/                    # 业务层
│   ├── entities/             # 实体
│   │   ├── diary_entry.dart
│   │   ├── tag.dart
│   │   └── user_preferences.dart
│   ├── repositories/         # Repository接口
│   │   ├── diary_repository.dart
│   │   └── tag_repository.dart
│   └── usecases/            # 用例
│       ├── diary/
│       │   ├── create_diary_entry.dart
│       │   ├── get_diary_entries.dart
│       │   ├── update_diary_entry.dart
│       │   └── delete_diary_entry.dart
│       ├── tag/
│       └── search/
├── presentation/             # 表现层
│   ├── pages/               # 页面
│   │   ├── home/
│   │   │   ├── home_page.dart
│   │   │   ├── widgets/
│   │   │   └── controllers/
│   │   ├── editor/
│   │   └── settings/
│   ├── shared/              # 共享组件
│   │   ├── widgets/
│   │   │   ├── buttons/
│   │   │   ├── inputs/
│   │   │   └── layouts/
│   │   ├── themes/
│   │   │   ├── app_theme.dart
│   │   │   ├── colors.dart
│   │   │   └── text_styles.dart
│   │   └── constants/
│   └── routes/              # 路由配置
│       ├── app_router.dart
│       └── route_names.dart
└── shared/                  # 全局共享
    ├── widgets/
    ├── constants/
    └── extensions/
```

### 3.2 文件命名规范

#### 3.2.1 基本规则
- 使用snake_case命名
- 文件名应该反映其内容
- 避免过长的文件名
- 使用有意义的前缀/后缀

#### 3.2.2 特殊后缀
```
页面文件:     *_page.dart
Widget文件:   *_widget.dart (可选)
Controller:   *_controller.dart
Model文件:    *_model.dart
Service文件:  *_service.dart
Repository:   *_repository.dart
UseCase文件:  无特殊后缀，使用动词短语
测试文件:     *_test.dart
```

### 3.3 导入规范

#### 3.3.1 导入顺序
```dart
// 1. Dart核心库
import 'dart:async';
import 'dart:convert';

// 2. Flutter库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. 第三方库（按字母序）
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. 项目内导入（相对路径）
import '../../../domain/entities/diary_entry.dart';
import '../../widgets/diary_card.dart';
import '../controllers/home_controller.dart';
```

#### 3.3.2 导入别名
```dart
// 当有命名冲突时使用别名
import 'package:flutter/material.dart' as material;
import 'package:another_package/material.dart' as another;

// 长包名使用别名
import 'package:very_long_package_name/component.dart' as vlpn;
```

## 4. 注释规范

### 4.1 文档注释

#### 4.1.1 类注释
```dart
/// 日记条目实体类
///
/// 表示用户创建的一条日记记录，包含标题、内容、标签等信息。
/// 支持Markdown格式的内容和多标签分类。
///
/// 示例:
/// ```dart
/// final entry = DiaryEntry(
///   id: 'uuid',
///   title: '今天的心情',
///   content: '# 标题\n内容...',
///   tags: ['生活', '感想'],
///   createdAt: DateTime.now(),
/// );
/// ```
class DiaryEntry {
  // 实现
}
```

#### 4.1.2 方法注释
```dart
/// 创建新的日记条目
///
/// 根据提供的参数创建一个新的日记条目，并保存到数据库。
/// 如果标题为空或内容超过限制，将抛出[ValidationException]。
///
/// [params] 包含创建日记所需的参数
///
/// 返回新创建的日记条目的ID
///
/// 抛出:
/// * [ValidationException] 当验证失败时
/// * [DatabaseException] 当数据库操作失败时
///
/// 示例:
/// ```dart
/// final params = CreateDiaryEntryParams(
///   title: '新日记',
///   content: '内容',
/// );
/// final id = await createDiaryEntry(params);
/// ```
Future<String> createDiaryEntry(CreateDiaryEntryParams params) async {
  // 实现
}
```

#### 4.1.3 变量注释
```dart
class DiaryEntry {
  /// 日记条目的唯一标识符
  ///
  /// 使用UUID v4格式生成，确保全局唯一性
  final String id;

  /// 日记标题
  ///
  /// 长度限制为1-100字符，不能为空
  final String title;

  /// 日记内容，支持Markdown格式
  ///
  /// 最大长度为50,000字符，支持完整的Markdown语法
  final String content;
}
```

### 4.2 行内注释

#### 4.2.1 解释性注释
```dart
// 计算字数时排除Markdown语法标记
final wordCount = content
    .replaceAll(RegExp(r'[#*_`~\[\]()]'), '') // 移除Markdown标记
    .split(RegExp(r'\s+'))                    // 按空白字符分割
    .where((word) => word.isNotEmpty)         // 过滤空字符串
    .length;

// TODO: 考虑支持中文字符计数
// FIXME: 正则表达式需要优化性能
// HACK: 临时解决方案，等待上游库修复
```

#### 4.2.2 警告注释
```dart
// WARNING: 此方法会修改数据库，确保在事务中调用
await _database.deleteEntry(id);

// NOTE: 此处必须使用异步操作，不能改为同步
await Future.delayed(Duration(milliseconds: 100));

// IMPORTANT: 加密密钥存储，不能记录到日志
final encryptedData = encrypt(data, _secretKey);
```

### 4.3 注释最佳实践

#### 4.3.1 什么时候写注释
- 复杂的业务逻辑
- 非显而易见的算法
- 外部API集成点
- 性能敏感代码
- 临时解决方案
- 配置和常量说明

#### 4.3.2 什么时候不写注释
- 显而易见的代码
- 自解释的变量和方法名
- 简单的getter/setter
- 标准的构造函数

## 5. 错误处理规范

### 5.1 异常类型定义

#### 5.1.1 自定义异常
```dart
// 基础异常类
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message';
}

// 具体异常类型
class ValidationException extends AppException {
  const ValidationException(String message, {String? code})
      : super(message, code: code);
}

class DatabaseException extends AppException {
  const DatabaseException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

class NetworkException extends AppException {
  const NetworkException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}
```

#### 5.1.2 Result类型
```dart
// 结果封装类型
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppException exception;
  const Failure(this.exception);
}

// 扩展方法
extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
    Success(data: final data) => data,
    Failure() => null,
  };

  AppException? get exceptionOrNull => switch (this) {
    Success() => null,
    Failure(exception: final exception) => exception,
  };
}
```

### 5.2 错误处理模式

#### 5.2.1 Repository层错误处理
```dart
class DiaryRepositoryImpl implements DiaryRepository {
  @override
  Future<Result<List<DiaryEntry>>> getAllEntries() async {
    try {
      final models = await _localDataSource.getAllEntries();
      final entities = models.map((model) => model.toEntity()).toList();
      return Success(entities);
    } on DatabaseException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(DatabaseException(
        'Failed to get diary entries',
        originalError: e,
      ));
    }
  }
}
```

#### 5.2.2 UseCase层错误处理
```dart
class CreateDiaryEntry {
  Future<Result<String>> call(CreateDiaryEntryParams params) async {
    // 参数验证
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Failure(ValidationException(validationResult));
    }

    // 业务逻辑执行
    return await _repository.createEntry(params);
  }

  String? _validateParams(CreateDiaryEntryParams params) {
    if (params.title.trim().isEmpty) {
      return 'Title cannot be empty';
    }
    if (params.title.length > 100) {
      return 'Title cannot exceed 100 characters';
    }
    if (params.content.length > 50000) {
      return 'Content cannot exceed 50,000 characters';
    }
    return null;
  }
}
```

#### 5.2.3 UI层错误处理
```dart
class DiaryEntriesNotifier extends StateNotifier<AsyncValue<List<DiaryEntry>>> {
  Future<void> loadEntries() async {
    state = const AsyncValue.loading();

    final result = await _getDiaryEntries(GetDiaryEntriesParams());

    state = result.when(
      success: (entries) => AsyncValue.data(entries),
      failure: (exception) => AsyncValue.error(
        exception,
        StackTrace.current,
      ),
    );
  }
}
```

## 6. 测试规范

### 6.1 测试文件组织

#### 6.1.1 测试目录结构
```
test/
├── unit/                      # 单元测试
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── data/
│   │   ├── models/
│   │   ├── datasources/
│   │   └── repositories/
│   └── presentation/
│       ├── controllers/
│       └── utils/
├── widget/                    # Widget测试
│   ├── pages/
│   ├── widgets/
│   └── shared/
├── integration/               # 集成测试
│   ├── app_test.dart
│   └── database_test.dart
├── helpers/                   # 测试辅助
│   ├── test_data.dart
│   ├── mock_factories.dart
│   └── test_utils.dart
└── fixtures/                  # 测试数据
    ├── diary_entries.json
    └── tags.json
```

#### 6.1.2 测试文件命名
```
源文件: lib/domain/entities/diary_entry.dart
测试文件: test/unit/domain/entities/diary_entry_test.dart

源文件: lib/presentation/pages/home/home_page.dart
测试文件: test/widget/pages/home/home_page_test.dart
```

### 6.2 测试代码规范

#### 6.2.1 测试组织
```dart
void main() {
  group('DiaryEntry Entity', () {
    group('Constructor', () {
      test('should create diary entry with valid parameters', () {
        // 测试实现
      });

      test('should throw exception with invalid parameters', () {
        // 测试实现
      });
    });

    group('Methods', () {
      test('should calculate word count correctly', () {
        // 测试实现
      });
    });

    group('Validation', () {
      test('should validate title length', () {
        // 测试实现
      });
    });
  });
}
```

#### 6.2.2 Mock对象管理
```dart
// 在单独文件中定义Mock类
// test/helpers/mocks.dart
import 'package:mockito/annotations.dart';
import 'package:inkboard/domain/repositories/diary_repository.dart';

@GenerateMocks([DiaryRepository])
void main() {}

// 在测试文件中使用
// test/unit/domain/usecases/create_diary_entry_test.dart
import 'package:mockito/mockito.dart';
import '../../helpers/mocks.mocks.dart';

void main() {
  late MockDiaryRepository mockRepository;
  late CreateDiaryEntry useCase;

  setUp(() {
    mockRepository = MockDiaryRepository();
    useCase = CreateDiaryEntry(mockRepository);
  });

  // 测试实现
}
```

## 7. Git工作流规范

### 7.1 分支策略

#### 7.1.1 分支类型
```
main          # 主分支，生产环境代码
develop       # 开发分支，集成最新功能
feature/*     # 功能分支
hotfix/*      # 热修复分支
release/*     # 发布分支
```

#### 7.1.2 分支命名
```
feature/diary-crud          # 功能分支
feature/markdown-editor     # 功能分支
hotfix/search-bug          # 热修复分支
release/v1.0.0             # 发布分支
```

### 7.2 提交规范

#### 7.2.1 提交信息格式
```
<type>(<scope>): <subject>

<body>

<footer>
```

#### 7.2.2 类型定义
```
feat:     新功能
fix:      Bug修复
docs:     文档更新
style:    代码格式（不影响功能）
refactor: 重构
test:     测试相关
chore:    构建工具、依赖更新
perf:     性能优化
ci:       CI/CD相关
```

#### 7.2.3 提交示例
```
feat(diary): add diary entry creation functionality

- Implement CreateDiaryEntry use case
- Add diary entry validation logic
- Create diary entry model and entity
- Add unit tests for diary creation

Closes #123
```

### 7.3 代码审查规范

#### 7.3.1 审查清单
- [ ] 代码符合项目规范
- [ ] 测试覆盖充分
- [ ] 文档更新完整
- [ ] 无安全漏洞
- [ ] 性能影响可接受
- [ ] 无破坏性变更

## 8. 性能规范

### 8.1 性能目标

#### 8.1.1 应用性能
- 应用启动时间 < 3秒
- 页面切换动画保持60fps
- 内存使用 < 100MB
- 电池消耗优化

#### 8.1.2 数据库性能
- 查询响应时间 < 500ms
- 大量数据分页加载
- 适当的索引设计
- 连接池管理

### 8.2 性能最佳实践

#### 8.2.1 Widget优化
```dart
// 正确：使用const构造函数
const Text('Static text');

// 正确：使用ListView.builder
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
);

// 错误：不必要的Widget重建
Widget build(BuildContext context) {
  return Column(
    children: items.map((item) => ItemWidget(item)).toList(),
  );
}
```

#### 8.2.2 状态管理优化
```dart
// 正确：细粒度状态管理
final isLoadingProvider = StateProvider<bool>((ref) => false);
final entriesProvider = StateProvider<List<DiaryEntry>>((ref) => []);

// 正确：使用select减少重建
Consumer(
  builder: (context, ref, child) {
    final isLoading = ref.watch(appStateProvider.select((state) => state.isLoading));
    return isLoading ? LoadingWidget() : ContentWidget();
  },
);
```

## 9. 安全规范

### 9.1 数据安全

#### 9.1.1 敏感数据处理
```dart
// 正确：不在日志中输出敏感信息
logger.info('User authenticated successfully'); // 不输出用户ID

// 错误：在日志中暴露敏感信息
logger.info('User ${userId} with password ${password} authenticated');
```

#### 9.1.2 加密存储
```dart
// 使用flutter_secure_storage存储敏感信息
const secureStorage = FlutterSecureStorage();

// 存储加密密钥
await secureStorage.write(key: 'encryption_key', value: encryptionKey);

// 读取加密密钥
final encryptionKey = await secureStorage.read(key: 'encryption_key');
```

### 9.2 输入验证

#### 9.2.1 数据验证
```dart
class DiaryEntryValidator {
  static String? validateTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Title cannot be empty';
    }
    if (title.length > 100) {
      return 'Title cannot exceed 100 characters';
    }
    return null;
  }

  static String? validateContent(String? content) {
    if (content == null) {
      return 'Content cannot be null';
    }
    if (content.length > 50000) {
      return 'Content cannot exceed 50,000 characters';
    }
    return null;
  }
}
```

## 10. 文档规范

### 10.1 代码文档

#### 10.1.1 README文件
每个主要模块应包含README.md文件，说明：
- 模块用途
- 主要类和接口
- 使用示例
- 依赖关系

#### 10.1.2 API文档
使用dartdoc生成API文档：
```bash
# 生成文档
dart doc

# 查看文档
open doc/api/index.html
```

### 10.2 变更文档

#### 10.2.1 CHANGELOG.md
记录所有重要变更：
```markdown
# Changelog

## [1.0.0] - 2025-09-22
### Added
- 日记条目的CRUD功能
- Markdown编辑器
- 标签系统

### Changed
- 优化数据库查询性能

### Fixed
- 修复搜索功能的bug
```

---

**文档版本**: v1.0
**创建日期**: 2025-09-22
**最后更新**: 2025-09-22
**作者**: 成东杰