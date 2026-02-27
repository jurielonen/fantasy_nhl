import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/database_provider.dart';
import '../../core/network/providers.dart';
import 'data/repositories/player_repository_impl.dart';
import 'domain/repositories/player_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
PlayerRepository playerRepository(Ref ref) => PlayerRepositoryImpl(
  webApiClient: ref.watch(nhlWebApiClientProvider),
  statsApiClient: ref.watch(nhlStatsApiClientProvider),
  playerCacheDao: ref.watch(playerCacheDaoProvider),
  apiCacheDao: ref.watch(apiCacheDaoProvider),
);
