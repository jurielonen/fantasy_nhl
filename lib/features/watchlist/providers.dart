import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/database_provider.dart';
import 'data/repositories/watchlist_repository_impl.dart';
import 'domain/repositories/watchlist_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
WatchlistRepository watchlistRepository(Ref ref) =>
    WatchlistRepositoryImpl(dao: ref.watch(watchlistDaoProvider));
