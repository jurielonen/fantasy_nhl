import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage_service.dart';
import 'data/repositories/watchlist_repository_impl.dart';
import 'domain/repositories/watchlist_repository.dart';

final watchlistRepositoryProvider = Provider<WatchlistRepository>(
  (ref) => WatchlistRepositoryImpl(
    storage: ref.watch(localStorageProvider),
  ),
);
