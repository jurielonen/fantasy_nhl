import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache_meta_model.freezed.dart';
part 'cache_meta_model.g.dart';

@freezed
abstract class CacheMetaModel with _$CacheMetaModel {
  const factory CacheMetaModel({
    required String lastFetched,
    @Default(15) int ttlMinutes,
  }) = _CacheMetaModel;

  factory CacheMetaModel.fromJson(Map<String, dynamic> json) =>
      _$CacheMetaModelFromJson(json);
}
