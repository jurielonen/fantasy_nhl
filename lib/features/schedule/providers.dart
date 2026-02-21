import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import '../../core/network/providers.dart';
import 'data/repositories/schedule_repository_impl.dart';
import 'domain/repositories/schedule_repository.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>(
  (ref) => ScheduleRepositoryImpl(
    webApiClient: ref.watch(nhlWebApiClientProvider),
    apiCacheDao: ref.watch(apiCacheDaoProvider),
  ),
);
