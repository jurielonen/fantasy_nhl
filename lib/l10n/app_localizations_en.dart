// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fantasy NHL';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRename => 'Rename';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonNew => 'New';

  @override
  String get commonToday => 'Today';

  @override
  String get commonVersion => 'Version';

  @override
  String commonPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count players',
      one: '1 player',
      zero: '0 players',
    );
    return '$_temp0';
  }

  @override
  String get commonAddToWatchlist => 'Add to watchlist';

  @override
  String get commonInWatchlist => 'In watchlist';

  @override
  String get navWatchlist => 'Watchlist';

  @override
  String get navExplore => 'Explore';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navSettings => 'Settings';

  @override
  String get watchlistTitle => 'Watchlist';

  @override
  String get watchlistSortBy => 'Sort by';

  @override
  String get watchlistSortCustom => 'Custom Order';

  @override
  String get watchlistSortName => 'Name';

  @override
  String get watchlistSortPosition => 'Position';

  @override
  String get watchlistSortPoints => 'Points (Season)';

  @override
  String get watchlistSortRecentForm => 'Recent Form';

  @override
  String get watchlistSortGameTime => 'Game Time';

  @override
  String get watchlistFailedToLoad => 'Failed to load watchlist';

  @override
  String get watchlistPlayerRemoved => 'Player removed';

  @override
  String get watchlistUndo => 'Undo';

  @override
  String get watchlistCreateAnother => 'Create another watchlist first';

  @override
  String watchlistMovedTo(String watchlistName) {
    return 'Moved to \"$watchlistName\"';
  }

  @override
  String get watchlistEmptyTitle => 'No players yet';

  @override
  String get watchlistEmptySubtitle =>
      'Search and add players to your watchlist to track their stats and games.';

  @override
  String get watchlistEmptyAction => 'Find Players';

  @override
  String get watchlistRenameTitle => 'Rename Watchlist';

  @override
  String get watchlistNameHint => 'Watchlist name';

  @override
  String get watchlistDeleteTitle => 'Delete Watchlist';

  @override
  String watchlistDeleteConfirm(String watchlistName, int count) {
    return 'Delete \"$watchlistName\" and its $count players? This cannot be undone.';
  }

  @override
  String get watchlistNewTitle => 'New Watchlist';

  @override
  String get watchlistMove => 'Move';

  @override
  String get watchlistRemove => 'Remove';

  @override
  String get watchlistNoGameToday => 'No game today';

  @override
  String watchlistFinalScore(String score) {
    return 'Final: $score';
  }

  @override
  String get watchlistLive => 'LIVE';

  @override
  String watchlistAlreadyIn(String playerName, String watchlistName) {
    return '$playerName already in \"$watchlistName\"';
  }

  @override
  String watchlistAddedTo(String playerName, String watchlistName) {
    return '$playerName added to \"$watchlistName\"';
  }

  @override
  String watchlistRemovedFrom(String playerName, String watchlistName) {
    return '$playerName removed from \"$watchlistName\"';
  }

  @override
  String movePlayerTo(String playerName) {
    return 'Move $playerName to...';
  }

  @override
  String get movePlayerNoOther =>
      'No other watchlists available. Create one first.';

  @override
  String addPlayerTo(String playerName) {
    return 'Add $playerName to...';
  }

  @override
  String get exploreTitle => 'Explore';

  @override
  String get exploreSearchHint => 'Search players...';

  @override
  String get exploreSpotlight => 'Player Spotlight';

  @override
  String get exploreSpotlightEmpty => 'No spotlight players available';

  @override
  String exploreSpotlightError(String error) {
    return 'Failed to load spotlight: $error';
  }

  @override
  String get exploreSkaterLeaders => 'Skater Leaders';

  @override
  String get exploreGoalieLeaders => 'Goalie Leaders';

  @override
  String get exploreSeeAll => 'See All';

  @override
  String get exploreShowLess => 'Show Less';

  @override
  String exploreFailedToLoad(String error) {
    return 'Failed to load: $error';
  }

  @override
  String get exploreBrowseByTeam => 'Browse by Team';

  @override
  String get exploreSearchNoResults => 'No players found';

  @override
  String get exploreSearchNoResultsHint => 'Try a different search term';

  @override
  String exploreSearchFailed(String error) {
    return 'Search failed: $error';
  }

  @override
  String teamRosterTitle(String teamAbbrev) {
    return '$teamAbbrev Roster';
  }

  @override
  String get teamRosterEmpty => 'No players found';

  @override
  String teamRosterError(String error) {
    return 'Failed to load roster: $error';
  }

  @override
  String get playerDetailTitle => 'Player Detail';

  @override
  String get playerDetailLoading => 'Loading...';

  @override
  String get playerDetailFailedToLoad => 'Failed to load player';

  @override
  String get playerDetailNoTeam => 'No team assigned';

  @override
  String get playerDetailTrendError => 'Could not load trend data';

  @override
  String get playerDetailTabOverview => 'Overview';

  @override
  String get playerDetailTabGameLog => 'Game Log';

  @override
  String get playerDetailTabSchedule => 'Schedule';

  @override
  String get playerDetailTabCareer => 'Career';

  @override
  String playerDetailAge(int age) {
    return 'Age $age';
  }

  @override
  String playerDetailWeight(int weight) {
    return '$weight lbs';
  }

  @override
  String get playerDetailShootsLeft => 'Left';

  @override
  String get playerDetailShootsRight => 'Right';

  @override
  String playerDetailDraftLabel(String details) {
    return 'Draft: $details';
  }

  @override
  String playerDetailDraftRound(int round) {
    return 'Round $round';
  }

  @override
  String playerDetailDraftPick(int pick) {
    return 'Pick $pick';
  }

  @override
  String playerDetailDraftOverall(int overall) {
    return '#$overall overall';
  }

  @override
  String playerDetailDraftBy(String team) {
    return 'by $team';
  }

  @override
  String get seasonStatsTitle => 'Season Stats';

  @override
  String get seasonStatsEmpty => 'No stats available';

  @override
  String get careerStatsTitle => 'Career Stats';

  @override
  String get careerStatsEmpty => 'No career stats available';

  @override
  String get careerStatsNhlOnly => 'NHL Only';

  @override
  String get careerStatsColumnSeason => 'Season';

  @override
  String get careerStatsColumnTeam => 'Team';

  @override
  String get gameLogFailedToLoad => 'Failed to load game log';

  @override
  String get gameLogEmpty => 'No games played yet';

  @override
  String get gameLogDate => 'Date';

  @override
  String get gameLogOpp => 'Opp';

  @override
  String get gameLogDec => 'Dec';

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get scheduleFailedToLoad => 'Failed to load schedule';

  @override
  String get scheduleNoGames => 'No games scheduled';

  @override
  String get scheduleNoGamesHint => 'Try a different date';

  @override
  String get scheduleUpcomingEmpty => 'No upcoming games scheduled';

  @override
  String get scheduleUpcomingError => 'Failed to load schedule';

  @override
  String get scheduleBackToBack => 'B2B';

  @override
  String get schedulePreviousDay => 'Previous day';

  @override
  String get scheduleNextDay => 'Next day';

  @override
  String scheduleDateDisplay(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat(
      'E, MMM d',
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get scheduleLive => 'LIVE';

  @override
  String get scheduleFinal => 'Final';

  @override
  String get scheduleTbd => 'TBD';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDisclaimer => 'Disclaimer';

  @override
  String get settingsDisclaimerText =>
      'This app uses unofficial NHL API data. Not affiliated with or endorsed by the NHL.';

  @override
  String get settingsClearCache => 'Clear Cache';

  @override
  String settingsCacheCount(int count) {
    return '$count cached entries';
  }

  @override
  String settingsCacheCleared(int count) {
    return 'Cleared $count cache entries';
  }

  @override
  String get statTrendTitle => 'Stat Trend';

  @override
  String get statTrendEmpty => 'No game data available';

  @override
  String get statTrendPoints => 'Points';

  @override
  String get statTrendGoals => 'Goals';

  @override
  String get statTrendAssists => 'Assists';

  @override
  String get statTrendShots => 'Shots';
}
