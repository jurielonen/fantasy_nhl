class ApiConstants {
  ApiConstants._();

  static const nhlWebApiBaseUrl = 'https://api-web.nhle.com';
  static const nhlStatsApiBaseUrl = 'https://api.nhle.com/stats/rest';

  static const defaultTimeout = Duration(seconds: 10);
  static const defaultStatsLimit = 100;

  // Common Cayenne expression fragments for Stats API
  static const currentSeason = '20242025';
  static const regularSeason = '2';
  static const playoffs = '3';

  static String seasonFilter(String season) => 'seasonId=$season';
  static String regularSeasonFilter(String season) =>
      'seasonId=$season and gameTypeId=2';
}
