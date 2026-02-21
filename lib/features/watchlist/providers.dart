import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import 'data/repositories/watchlist_repository_impl.dart';
import 'domain/repositories/watchlist_repository.dart';

final watchlistRepositoryProvider = Provider<WatchlistRepository>(
  (ref) => WatchlistRepositoryImpl(
    dao: ref.watch(watchlistDaoProvider),
  ),
);
