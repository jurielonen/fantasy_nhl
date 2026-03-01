import 'package:flutter/material.dart';

/// NHL team value object. Carries the team abbreviation and optional query
/// parameters (e.g. `season=20252026`) to append to logo asset URLs.
class NhlTeam {
  final String abbrev;
  final Map<String, String> queryParams;

  static const _logoBase = 'https://assets.nhle.com/logos/nhl/svg';

  const NhlTeam(this.abbrev, {this.queryParams = const <String, String>{}});

  /// Parses query parameters from a full NHL logo URL returned by the API.
  /// e.g. "https://assets.nhle.com/logos/nhl/svg/UTA_light.svg?season=20252026"
  factory NhlTeam.fromLogoUrl(String abbrev, String logoUrl) {
    final params = Uri.parse(logoUrl).queryParameters;
    return NhlTeam(abbrev, queryParams: params);
  }

  /// Logo URL for the given theme brightness.
  /// Format: https://assets.nhle.com/logos/nhl/svg/{abbrev}_{light|dark}.svg[?params]
  String logoUrl(Brightness brightness) {
    final theme = brightness == Brightness.dark ? 'dark' : 'light';
    var uri = Uri.parse('$_logoBase/${abbrev}_$theme.svg');
    if (queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
    return uri.toString();
  }
}
