# 砚记(Inkboard) - TDD测试策略文档

## 1. TDD概述

### 1.1 测试驱动开发(TDD)定义
测试驱动开发是一种软件开发方法，其基本流程是：先编写测试，然后编写代码使测试通过，最后进行重构。这种方法确保代码质量高、可维护性强，同时提供了天然的回归测试保护。

### 1.2 TDD的三个步骤 (Red-Green-Refactor)
1. **Red (红色)**: 编写一个失败的测试
2. **Green (绿色)**: 编写最少的代码使测试通过
3. **Refactor (重构)**: 在保持测试通过的前提下改进代码

### 1.3 TDD在砚记项目中的价值
- **质量保证**: 确保每个功能都有对应的测试
- **设计驱动**: 通过先写测试来驱动更好的API设计
- **回归保护**: 防止新功能破坏现有功能
- **文档价值**: 测试本身就是活的文档
- **重构信心**: 有测试保护的重构更安全

## 2. 测试策略

### 2.1 测试金字塔

```
        E2E Tests (5%)
       ┌─────────────┐
      │   UI Flow    │
     │   Integration │ (15%)
    │     Tests      │
   │                 │
  └─────────────────┘
      Unit Tests (80%)
```

#### 2.1.1 单元测试 (Unit Tests) - 80%
- **范围**: 单个类、函数或方法
- **速度**: 毫秒级执行
- **隔离性**: 完全隔离，使用mock和stub
- **覆盖**: 业务逻辑、工具类、数据模型

#### 2.1.2 集成测试 (Integration Tests) - 15%
- **范围**: 多个组件协作
- **速度**: 秒级执行
- **真实性**: 使用真实的数据库和依赖
- **覆盖**: 数据流、API交互、复杂场景

#### 2.1.3 端到端测试 (E2E Tests) - 5%
- **范围**: 完整的用户场景
- **速度**: 分钟级执行
- **真实性**: 模拟真实用户操作
- **覆盖**: 关键用户路径、回归测试

### 2.2 测试分类

#### 2.2.1 按测试类型分类
- **功能测试**: 验证功能是否按预期工作
- **性能测试**: 验证响应时间和资源使用
- **安全测试**: 验证数据加密和访问控制
- **可用性测试**: 验证用户体验和界面交互

#### 2.2.2 按测试层级分类
- **Model层测试**: 数据模型、实体类
- **Repository层测试**: 数据访问逻辑
- **UseCase层测试**: 业务逻辑
- **Controller层测试**: 状态管理
- **Widget层测试**: UI组件

## 3. TDD实施流程

### 3.1 开发流程

```
1. 需求分析
   ↓
2. 编写失败测试 (Red)
   ↓
3. 运行测试确认失败
   ↓
4. 编写最小实现 (Green)
   ↓
5. 运行测试确认通过
   ↓
6. 重构优化 (Refactor)
   ↓
7. 回到步骤2(如有新需求)
```

### 3.2 测试优先原则

#### 3.2.1 对于新功能
1. 首先编写失败的测试用例
2. 确保测试用例能够准确反映需求
3. 编写最少的代码使测试通过
4. 逐步添加更多测试用例
5. 重构代码提高质量

#### 3.2.2 对于Bug修复
1. 编写能重现Bug的测试用例
2. 确认测试失败
3. 修复Bug使测试通过
4. 添加边界情况的测试
5. 重构相关代码

## 4. 测试工具和框架

### 4.1 Flutter测试工具

#### 4.1.1 单元测试
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

#### 4.1.2 Widget测试
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  golden_toolkit: ^0.15.0
```

#### 4.1.3 集成测试
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_driver:
    sdk: flutter
```

### 4.2 测试相关库

#### 4.2.1 Mock库
- **mockito**: 用于创建mock对象
- **mocktail**: 更现代的mock库，支持null safety

#### 4.2.2 测试数据
- **faker**: 生成测试数据
- **test_fixtures**: 管理测试fixture

#### 4.2.3 断言库
- **matcher**: Flutter内置的断言库
- **given_when_then**: BDD风格的测试写法

## 5. 测试用例设计

### 5.1 测试用例命名规范

#### 5.1.1 单元测试命名
```dart
// 格式：should_[预期结果]_when_[条件]
test('should_return_diary_entry_when_valid_id_provided', () {});
test('should_throw_exception_when_invalid_id_provided', () {});
test('should_return_empty_list_when_no_entries_exist', () {});
```

#### 5.1.2 Widget测试命名
```dart
// 格式：should_[UI行为]_when_[用户操作]
testWidgets('should_show_diary_list_when_entries_exist', (tester) async {});
testWidgets('should_navigate_to_editor_when_fab_pressed', (tester) async {});
```

### 5.2 测试用例结构 (AAA模式)

#### 5.2.1 Arrange-Act-Assert模式
```dart
test('should_create_diary_entry_when_valid_data_provided', () {
  // Arrange (准备)
  final repository = MockDiaryRepository();
  final useCase = CreateDiaryEntry(repository);
  final params = CreateDiaryEntryParams(
    title: 'Test Title',
    content: 'Test Content',
  );

  when(repository.createEntry(any)).thenAnswer((_) async => 'test-id');

  // Act (执行)
  final result = await useCase(params);

  // Assert (断言)
  expect(result, equals('test-id'));
  verify(repository.createEntry(any)).called(1);
});
```

#### 5.2.2 Given-When-Then模式
```dart
test('should_create_diary_entry_when_valid_data_provided', () {
  // Given
  final repository = MockDiaryRepository();
  final useCase = CreateDiaryEntry(repository);
  when(repository.createEntry(any)).thenAnswer((_) async => 'test-id');

  // When
  final result = useCase(CreateDiaryEntryParams(
    title: 'Test Title',
    content: 'Test Content',
  ));

  // Then
  expect(result, completion(equals('test-id')));
});
```

### 5.3 边界条件测试

#### 5.3.1 输入验证测试
```dart
group('CreateDiaryEntry validation tests', () {
  test('should_throw_exception_when_title_is_empty', () {
    // 空标题测试
  });

  test('should_throw_exception_when_title_too_long', () {
    // 标题过长测试
  });

  test('should_handle_special_characters_in_content', () {
    // 特殊字符测试
  });

  test('should_handle_large_content_size', () {
    // 大内容测试
  });
});
```

#### 5.3.2 错误场景测试
```dart
group('DiaryRepository error handling', () {
  test('should_throw_exception_when_database_unavailable', () {
    // 数据库不可用
  });

  test('should_retry_when_network_timeout', () {
    // 网络超时重试
  });

  test('should_handle_concurrent_modifications', () {
    // 并发修改处理
  });
});
```

## 6. 测试数据管理

### 6.1 测试数据策略

#### 6.1.1 数据隔离
- 每个测试使用独立的数据
- 测试之间不共享状态
- 使用setUp和tearDown确保清理

#### 6.1.2 数据生成
```dart
class DiaryEntryTestData {
  static DiaryEntry createValidEntry({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return DiaryEntry(
      id: id ?? 'test-id-${DateTime.now().millisecondsSinceEpoch}',
      title: title ?? 'Test Diary Entry',
      content: content ?? 'This is test content',
      tags: [],
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      isFavorite: false,
      status: DiaryEntryStatus.published,
    );
  }

  static List<DiaryEntry> createEntryList(int count) {
    return List.generate(count, (index) => createValidEntry(
      id: 'test-id-$index',
      title: 'Test Entry $index',
    ));
  }
}
```

### 6.2 Mock数据管理

#### 6.2.1 Repository Mock
```dart
class MockDiaryRepository extends Mock implements DiaryRepository {}

void setupMockRepository(MockDiaryRepository mock) {
  when(mock.getAllEntries()).thenAnswer((_) async => []);
  when(mock.getEntryById(any)).thenAnswer((_) async => null);
  when(mock.createEntry(any)).thenAnswer((_) async => 'mock-id');
  when(mock.updateEntry(any, any)).thenAnswer((_) async {});
  when(mock.deleteEntry(any)).thenAnswer((_) async {});
}
```

## 7. 具体测试实例

### 7.1 Domain层测试

#### 7.1.1 Entity测试
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';

void main() {
  group('DiaryEntry Entity Tests', () {
    test('should_create_diary_entry_with_all_fields', () {
      // Arrange
      final createdAt = DateTime.now();
      final updatedAt = DateTime.now();

      // Act
      final entry = DiaryEntry(
        id: 'test-id',
        title: 'Test Title',
        content: 'Test Content',
        tags: ['tag1', 'tag2'],
        createdAt: createdAt,
        updatedAt: updatedAt,
        isFavorite: true,
        status: DiaryEntryStatus.published,
      );

      // Assert
      expect(entry.id, equals('test-id'));
      expect(entry.title, equals('Test Title'));
      expect(entry.content, equals('Test Content'));
      expect(entry.tags, hasLength(2));
      expect(entry.isFavorite, isTrue);
    });

    test('should_return_word_count_for_content', () {
      // Arrange
      final entry = DiaryEntryTestData.createValidEntry(
        content: 'This is a test content with ten words exactly.'
      );

      // Act
      final wordCount = entry.wordCount;

      // Assert
      expect(wordCount, equals(10));
    });
  });
}
```

#### 7.1.2 UseCase测试
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:inkboard/domain/usecases/create_diary_entry.dart';

void main() {
  group('CreateDiaryEntry UseCase Tests', () {
    late MockDiaryRepository mockRepository;
    late CreateDiaryEntry useCase;

    setUp(() {
      mockRepository = MockDiaryRepository();
      useCase = CreateDiaryEntry(mockRepository);
    });

    test('should_create_diary_entry_when_valid_params_provided', () async {
      // Arrange
      const expectedId = 'generated-id';
      final params = CreateDiaryEntryParams(
        title: 'New Entry',
        content: 'Entry content',
        tags: ['personal'],
      );

      when(mockRepository.createEntry(any))
        .thenAnswer((_) async => expectedId);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, equals(expectedId));
      verify(mockRepository.createEntry(any)).called(1);
    });

    test('should_throw_validation_exception_when_title_empty', () async {
      // Arrange
      final params = CreateDiaryEntryParams(
        title: '',
        content: 'Valid content',
      );

      // Act & Assert
      expect(
        () async => await useCase(params),
        throwsA(isA<ValidationException>()),
      );

      verifyNever(mockRepository.createEntry(any));
    });
  });
}
```

### 7.2 Data层测试

#### 7.2.1 Repository实现测试
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:inkboard/data/repositories/diary_repository_impl.dart';

void main() {
  group('DiaryRepositoryImpl Tests', () {
    late MockDiaryLocalDataSource mockLocalDataSource;
    late DiaryRepositoryImpl repository;

    setUp(() {
      mockLocalDataSource = MockDiaryLocalDataSource();
      repository = DiaryRepositoryImpl(
        localDataSource: mockLocalDataSource,
      );
    });

    test('should_return_diary_entries_from_local_data_source', () async {
      // Arrange
      final mockEntries = [
        DiaryEntryModel.fromEntity(
          DiaryEntryTestData.createValidEntry(),
        ),
      ];

      when(mockLocalDataSource.getAllEntries())
        .thenAnswer((_) async => mockEntries);

      // Act
      final result = await repository.getAllEntries();

      // Assert
      expect(result, hasLength(1));
      verify(mockLocalDataSource.getAllEntries()).called(1);
    });

    test('should_cache_results_for_subsequent_calls', () async {
      // 测试缓存逻辑
    });
  });
}
```

### 7.3 Presentation层测试

#### 7.3.1 Controller测试
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('DiaryController Tests', () {
    late ProviderContainer container;
    late MockGetDiaryEntries mockGetDiaryEntries;

    setUp(() {
      mockGetDiaryEntries = MockGetDiaryEntries();
      container = ProviderContainer(
        overrides: [
          getDiaryEntriesProvider.overrideWithValue(mockGetDiaryEntries),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should_load_diary_entries_on_initialization', () async {
      // Arrange
      final mockEntries = DiaryEntryTestData.createEntryList(3);
      when(mockGetDiaryEntries(any))
        .thenAnswer((_) async => mockEntries);

      // Act
      final notifier = container.read(diaryEntriesProvider.notifier);
      await notifier.loadEntries();

      // Assert
      final state = container.read(diaryEntriesProvider);
      expect(state.value, hasLength(3));
    });
  });
}
```

#### 7.3.2 Widget测试
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inkboard/presentation/pages/home/home_page.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('should_display_diary_entries_when_data_available', (tester) async {
      // Arrange
      final mockEntries = DiaryEntryTestData.createEntryList(2);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryEntriesProvider.overrideWith((ref) => AsyncValue.data(mockEntries)),
          ],
          child: MaterialApp(home: HomePage()),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(DiaryEntryCard), findsNWidgets(2));
      expect(find.text('Test Entry 0'), findsOneWidget);
      expect(find.text('Test Entry 1'), findsOneWidget);
    });

    testWidgets('should_show_loading_indicator_when_loading', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryEntriesProvider.overrideWith((ref) => AsyncValue.loading()),
          ],
          child: MaterialApp(home: HomePage()),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should_navigate_to_editor_when_fab_pressed', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HomePage(),
            routes: {
              '/editor': (context) => EditorPage(),
            },
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(EditorPage), findsOneWidget);
    });
  });
}
```

## 8. 持续测试

### 8.1 自动化测试流水线

#### 8.1.1 GitHub Actions配置
```yaml
name: Test Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.35.3'

    - name: Install dependencies
      run: flutter pub get

    - name: Run unit tests
      run: flutter test --coverage

    - name: Run integration tests
      run: flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart

    - name: Upload coverage
      uses: codecov/codecov-action@v3
```

### 8.2 代码覆盖率

#### 8.2.1 覆盖率目标
- **整体覆盖率**: > 80%
- **关键业务逻辑**: 100%
- **UI组件**: > 70%
- **工具类**: > 90%

#### 8.2.2 覆盖率监控
```bash
# 生成覆盖率报告
flutter test --coverage

# 生成HTML报告
genhtml coverage/lcov.info -o coverage/html

# 检查覆盖率阈值
lcov --summary coverage/lcov.info
```

## 9. 测试最佳实践

### 9.1 编写规范

#### 9.1.1 测试结构
- 一个测试文件对应一个源文件
- 使用group组织相关测试
- 保持测试简单和专注
- 避免测试之间的依赖

#### 9.1.2 断言规范
- 使用有意义的断言消息
- 优先使用特定的matcher
- 避免过于复杂的断言
- 测试一个概念一个断言

### 9.2 性能考虑

#### 9.2.1 测试性能
- 避免不必要的setup和teardown
- 使用mock而不是真实依赖
- 并行运行独立测试
- 优化慢测试

#### 9.2.2 维护成本
- 重构测试和代码一样重要
- 删除重复和无价值的测试
- 保持测试代码简洁
- 定期review测试质量

## 10. 测试指标和报告

### 10.1 关键指标

#### 10.1.1 数量指标
- 测试总数
- 通过率
- 失败率
- 跳过测试数

#### 10.1.2 质量指标
- 代码覆盖率
- 分支覆盖率
- 变更检测率
- Bug回归率

### 10.2 报告格式

#### 10.2.1 每日报告
- 测试执行结果
- 覆盖率变化
- 新增/修改测试
- 失败测试分析

#### 10.2.2 Sprint报告
- 测试目标达成情况
- 质量指标趋势
- 测试债务分析
- 改进建议

---

**文档版本**: v1.0
**创建日期**: 2025-09-22
**最后更新**: 2025-09-22
**作者**: 成东杰