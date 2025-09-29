// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/database/app_database.dart' as _i160;
import '../../data/repositories/diary_entry_repository_impl.dart' as _i21;
import '../../data/repositories/tag_repository_impl.dart' as _i165;
import '../../data/services/encryption_service_impl.dart' as _i608;
import '../../data/services/search_service_impl.dart' as _i195;
import '../../domain/repositories/diary_entry_repository.dart' as _i725;
import '../../domain/repositories/tag_repository.dart' as _i627;
import '../../domain/services/encryption_service.dart' as _i13;
import '../../domain/services/search_service.dart' as _i396;
import '../../domain/usecases/create_diary_entry_usecase.dart' as _i828;
import '../../domain/usecases/get_diary_entries_usecase.dart' as _i817;
import '../../domain/usecases/search_diary_usecase.dart' as _i423;
import '../../domain/usecases/tag_management_usecase.dart' as _i575;
import '../../domain/usecases/update_delete_diary_entry_usecase.dart' as _i378;
import '../services/app_config_service.dart' as _i639;
import '../services/database_key_service.dart' as _i901;
import '../services/impl/database_key_service_secure.dart' as _i902;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i639.AppConfigService>(() => _i639.AppConfigService());
    gh.lazySingleton<_i901.DatabaseKeyService>(
      () => _i902.SecureDatabaseKeyService(),
    );
    gh.lazySingleton<_i160.AppDatabase>(
      () => _i160.AppDatabase(keyService: gh<_i901.DatabaseKeyService>()),
    );
    // SearchResult 为值对象，不注册工厂以避免泛型边界问题
    gh.lazySingleton<_i13.EncryptionService>(
      () => _i608.EncryptionServiceImpl(),
    );
    gh.factory<_i828.CreateDiaryEntryParams>(
      () => _i828.CreateDiaryEntryParams(
        title: gh<String>(),
        content: gh<String>(),
        isFavorite: gh<bool>(),
        moodScore: gh<int>(),
        weather: gh<String>(),
        location: gh<String>(),
        tagNames: gh<List<String>>(),
        defaultTagColor: gh<String>(),
      ),
    );
    gh.factory<_i817.DiaryStatistics>(
      () => _i817.DiaryStatistics(
        totalCount: gh<int>(),
        favoriteCount: gh<int>(),
        monthlyCount: gh<int>(),
      ),
    );
    gh.lazySingleton<_i627.TagRepository>(
      () => _i165.TagRepositoryImpl(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i725.DiaryEntryRepository>(
      () => _i21.DiaryEntryRepositoryImpl(gh<_i160.AppDatabase>()),
    );
    gh.factory<_i575.CreateTagParams>(
      () => _i575.CreateTagParams(
        name: gh<String>(),
        color: gh<String>(),
        description: gh<String>(),
      ),
    );
    gh.factory<_i817.GetDiaryEntriesUseCase>(
      () => _i817.GetDiaryEntriesUseCase(gh<_i725.DiaryEntryRepository>()),
    );
    gh.factory<_i575.TagManagementUseCase>(
      () => _i575.TagManagementUseCase(gh<_i627.TagRepository>()),
    );
    gh.lazySingleton<_i396.SearchService>(
      () => _i195.SearchServiceImpl(
        gh<_i725.DiaryEntryRepository>(),
        gh<_i627.TagRepository>(),
      ),
    );
    gh.factory<_i575.TagStatistics>(
      () => _i575.TagStatistics(
        totalCount: gh<int>(),
        usedCount: gh<int>(),
        monthlyCreatedCount: gh<int>(),
      ),
    );
    gh.factory<_i378.UpdateDiaryEntryParams>(
      () => _i378.UpdateDiaryEntryParams(
        id: gh<int>(),
        title: gh<String>(),
        content: gh<String>(),
        isFavorite: gh<bool>(),
        moodScore: gh<int>(),
        weather: gh<String>(),
        location: gh<String>(),
        tagNames: gh<List<String>>(),
        defaultTagColor: gh<String>(),
      ),
    );
    gh.factory<_i828.CreateDiaryEntryUseCase>(
      () => _i828.CreateDiaryEntryUseCase(
        gh<_i725.DiaryEntryRepository>(),
        gh<_i627.TagRepository>(),
      ),
    );
    gh.factory<_i378.UpdateDiaryEntryUseCase>(
      () => _i378.UpdateDiaryEntryUseCase(
        gh<_i725.DiaryEntryRepository>(),
        gh<_i627.TagRepository>(),
      ),
    );
    gh.factory<_i378.DeleteDiaryEntryUseCase>(
      () => _i378.DeleteDiaryEntryUseCase(
        gh<_i725.DiaryEntryRepository>(),
        gh<_i627.TagRepository>(),
      ),
    );
    gh.factory<_i423.AdvancedSearchParams>(
      () => _i423.AdvancedSearchParams(
        titleQuery: gh<String>(),
        contentQuery: gh<String>(),
        tagIds: gh<List<int>>(),
        startDate: gh<DateTime>(),
        endDate: gh<DateTime>(),
        isFavorite: gh<bool>(),
        moodScore: gh<int>(),
      ),
    );
    gh.factory<_i575.UpdateTagParams>(
      () => _i575.UpdateTagParams(
        id: gh<int>(),
        name: gh<String>(),
        color: gh<String>(),
        description: gh<String>(),
      ),
    );
    gh.factory<_i423.SearchDiaryUseCase>(
      () => _i423.SearchDiaryUseCase(gh<_i396.SearchService>()),
    );
    return this;
  }
}
