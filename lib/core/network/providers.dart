import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_factory.dart';
import 'nhl_stats_api_client.dart';
import 'nhl_web_api_client.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Dio webApiDio(Ref ref) => DioFactory.createWebApiDio();

@Riverpod(keepAlive: true)
Dio statsApiDio(Ref ref) => DioFactory.createStatsApiDio();

@Riverpod(keepAlive: true)
NhlWebApiClient nhlWebApiClient(Ref ref) =>
    NhlWebApiClient(ref.watch(webApiDioProvider));

@Riverpod(keepAlive: true)
NhlStatsApiClient nhlStatsApiClient(Ref ref) =>
    NhlStatsApiClient(ref.watch(statsApiDioProvider));
