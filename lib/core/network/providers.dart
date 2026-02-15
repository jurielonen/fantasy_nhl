import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_factory.dart';
import 'nhl_stats_api_client.dart';
import 'nhl_web_api_client.dart';

final webApiDioProvider = Provider<Dio>(
  (ref) => DioFactory.createWebApiDio(),
);

final statsApiDioProvider = Provider<Dio>(
  (ref) => DioFactory.createStatsApiDio(),
);

final nhlWebApiClientProvider = Provider<NhlWebApiClient>(
  (ref) => NhlWebApiClient(ref.watch(webApiDioProvider)),
);

final nhlStatsApiClientProvider = Provider<NhlStatsApiClient>(
  (ref) => NhlStatsApiClient(ref.watch(statsApiDioProvider)),
);
