import 'nhl_team.dart';

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
    NhlTeam('ANA'),
    NhlTeam('BOS'),
    NhlTeam('BUF'),
    NhlTeam('CGY'),
    NhlTeam('CAR'),
    NhlTeam('CHI'),
    NhlTeam('COL'),
    NhlTeam('CBJ'),
    NhlTeam('DAL'),
    NhlTeam('DET'),
    NhlTeam('EDM'),
    NhlTeam('FLA'),
    NhlTeam('LAK'),
    NhlTeam('MIN'),
    NhlTeam('MTL'),
    NhlTeam('NSH'),
    NhlTeam('NJD'),
    NhlTeam('NYI'),
    NhlTeam('NYR'),
    NhlTeam('OTT'),
    NhlTeam('PHI'),
    NhlTeam('PIT'),
    NhlTeam('SJS'),
    NhlTeam('SEA'),
    NhlTeam('STL'),
    NhlTeam('TBL'),
    NhlTeam('TOR'),
    NhlTeam('UTA'),
    NhlTeam('VAN'),
    NhlTeam('VGK'),
    NhlTeam('WPG'),
    NhlTeam('WSH'),
  ];

  static const positions = ['C', 'LW', 'RW', 'D', 'G'];
}
