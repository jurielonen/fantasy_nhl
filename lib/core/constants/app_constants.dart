class AppConstants {
  AppConstants._();

  static const appName = 'Fantasy NHL';
  static const cacheDefaultTtlMinutes = 15;
  static const searchDebounceMs = 300;
  static const maxRetries = 3;
  static const recentGamesCount = 10;
  static const upcomingGamesCount = 5;
  static const trendGamesCount = 30;

  static const teamCodes = [
    'ANA', 'ARI', 'BOS', 'BUF', 'CGY', 'CAR', 'CHI', 'COL',
    'CBJ', 'DAL', 'DET', 'EDM', 'FLA', 'LAK', 'MIN', 'MTL',
    'NSH', 'NJD', 'NYI', 'NYR', 'OTT', 'PHI', 'PIT', 'SJS',
    'SEA', 'STL', 'TBL', 'TOR', 'UTA', 'VAN', 'VGK', 'WPG', 'WSH',
  ];

  static const positions = ['C', 'LW', 'RW', 'D', 'G'];
}
