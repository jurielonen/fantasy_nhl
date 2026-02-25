import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/database_provider.dart';
import '../../core/network/providers.dart';
import 'data/repositories/schedule_repository_impl.dart';
import 'domain/repositories/schedule_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
ScheduleRepository scheduleRepository(Ref ref) => ScheduleRepositoryImpl(
      webApiClient: ref.watch(nhlWebApiClientProvider),
      apiCacheDao: ref.watch(apiCacheDaoProvider),
    );
