import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import '../../core/network/providers.dart';
import 'data/repositories/player_repository_impl.dart';
import 'domain/repositories/player_repository.dart';

final playerRepositoryProvider = Provider<PlayerRepository>(
  (ref) => PlayerRepositoryImpl(
    webApiClient: ref.watch(nhlWebApiClientProvider),
    statsApiClient: ref.watch(nhlStatsApiClientProvider),
    playerCacheDao: ref.watch(playerCacheDaoProvider),
    apiCacheDao: ref.watch(apiCacheDaoProvider),
  ),
);
