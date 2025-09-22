import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/data/database/app_database.dart';
import 'package:inkboard/data/repositories/diary_entry_repository_impl.dart';
import 'package:inkboard/data/repositories/tag_repository_impl.dart';
import 'package:inkboard/domain/repositories/diary_entry_repository.dart';
import 'package:inkboard/domain/repositories/tag_repository.dart';

class TestAppDatabase extends AppDatabase {
  TestAppDatabase() : super(executor: NativeDatabase.memory());
}

class TestHarness {
  late TestAppDatabase db;
  late DiaryEntryRepository diaryRepo;
  late TagRepository tagRepo;

  Future<void> setUp() async {
    db = TestAppDatabase();
    tagRepo = TagRepositoryImpl(db);
    diaryRepo = DiaryEntryRepositoryImpl(db);
  }

  Future<void> tearDown() async {
    await db.close();
  }
}
