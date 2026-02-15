import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/providers.dart';
import '../../core/storage/local_storage_service.dart';
import 'data/repositories/player_repository_impl.dart';
import 'domain/repositories/player_repository.dart';

final playerRepositoryProvider = Provider<PlayerRepository>(
  (ref) => PlayerRepositoryImpl(
    webApiClient: ref.watch(nhlWebApiClientProvider),
    statsApiClient: ref.watch(nhlStatsApiClientProvider),
    storage: ref.watch(localStorageProvider),
  ),
);
