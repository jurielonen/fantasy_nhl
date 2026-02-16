import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fantasy NHL'**
  String get appTitle;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get commonRename;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get commonNew;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get commonVersion;

  /// No description provided for @commonPlayers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 players} =1{1 player} other{{count} players}}'**
  String commonPlayers(int count);

  /// No description provided for @commonAddToWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Add to watchlist'**
  String get commonAddToWatchlist;

  /// No description provided for @commonInWatchlist.
  ///
  /// In en, this message translates to:
  /// **'In watchlist'**
  String get commonInWatchlist;

  /// No description provided for @navWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get navWatchlist;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @watchlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlistTitle;

  /// No description provided for @watchlistSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get watchlistSortBy;

  /// No description provided for @watchlistSortCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom Order'**
  String get watchlistSortCustom;

  /// No description provided for @watchlistSortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get watchlistSortName;

  /// No description provided for @watchlistSortPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get watchlistSortPosition;

  /// No description provided for @watchlistSortPoints.
  ///
  /// In en, this message translates to:
  /// **'Points (Season)'**
  String get watchlistSortPoints;

  /// No description provided for @watchlistSortRecentForm.
  ///
  /// In en, this message translates to:
  /// **'Recent Form'**
  String get watchlistSortRecentForm;

  /// No description provided for @watchlistSortGameTime.
  ///
  /// In en, this message translates to:
  /// **'Game Time'**
  String get watchlistSortGameTime;

  /// No description provided for @watchlistFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load watchlist'**
  String get watchlistFailedToLoad;

  /// No description provided for @watchlistPlayerRemoved.
  ///
  /// In en, this message translates to:
  /// **'Player removed'**
  String get watchlistPlayerRemoved;

  /// No description provided for @watchlistUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get watchlistUndo;

  /// No description provided for @watchlistCreateAnother.
  ///
  /// In en, this message translates to:
  /// **'Create another watchlist first'**
  String get watchlistCreateAnother;

  /// No description provided for @watchlistMovedTo.
  ///
  /// In en, this message translates to:
  /// **'Moved to \"{watchlistName}\"'**
  String watchlistMovedTo(String watchlistName);

  /// No description provided for @watchlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No players yet'**
  String get watchlistEmptyTitle;

  /// No description provided for @watchlistEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search and add players to your watchlist to track their stats and games.'**
  String get watchlistEmptySubtitle;

  /// No description provided for @watchlistEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Find Players'**
  String get watchlistEmptyAction;

  /// No description provided for @watchlistRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Watchlist'**
  String get watchlistRenameTitle;

  /// No description provided for @watchlistNameHint.
  ///
  /// In en, this message translates to:
  /// **'Watchlist name'**
  String get watchlistNameHint;

  /// No description provided for @watchlistDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Watchlist'**
  String get watchlistDeleteTitle;

  /// No description provided for @watchlistDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{watchlistName}\" and its {count} players? This cannot be undone.'**
  String watchlistDeleteConfirm(String watchlistName, int count);

  /// No description provided for @watchlistNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Watchlist'**
  String get watchlistNewTitle;

  /// No description provided for @watchlistMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get watchlistMove;

  /// No description provided for @watchlistRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get watchlistRemove;

  /// No description provided for @watchlistNoGameToday.
  ///
  /// In en, this message translates to:
  /// **'No game today'**
  String get watchlistNoGameToday;

  /// No description provided for @watchlistFinalScore.
  ///
  /// In en, this message translates to:
  /// **'Final: {score}'**
  String watchlistFinalScore(String score);

  /// No description provided for @watchlistLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get watchlistLive;

  /// No description provided for @watchlistAlreadyIn.
  ///
  /// In en, this message translates to:
  /// **'{playerName} already in \"{watchlistName}\"'**
  String watchlistAlreadyIn(String playerName, String watchlistName);

  /// No description provided for @watchlistAddedTo.
  ///
  /// In en, this message translates to:
  /// **'{playerName} added to \"{watchlistName}\"'**
  String watchlistAddedTo(String playerName, String watchlistName);

  /// No description provided for @watchlistRemovedFrom.
  ///
  /// In en, this message translates to:
  /// **'{playerName} removed from \"{watchlistName}\"'**
  String watchlistRemovedFrom(String playerName, String watchlistName);

  /// No description provided for @movePlayerTo.
  ///
  /// In en, this message translates to:
  /// **'Move {playerName} to...'**
  String movePlayerTo(String playerName);

  /// No description provided for @movePlayerNoOther.
  ///
  /// In en, this message translates to:
  /// **'No other watchlists available. Create one first.'**
  String get movePlayerNoOther;

  /// No description provided for @addPlayerTo.
  ///
  /// In en, this message translates to:
  /// **'Add {playerName} to...'**
  String addPlayerTo(String playerName);

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTitle;

  /// No description provided for @exploreSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search players...'**
  String get exploreSearchHint;

  /// No description provided for @exploreSpotlight.
  ///
  /// In en, this message translates to:
  /// **'Player Spotlight'**
  String get exploreSpotlight;

  /// No description provided for @exploreSpotlightEmpty.
  ///
  /// In en, this message translates to:
  /// **'No spotlight players available'**
  String get exploreSpotlightEmpty;

  /// No description provided for @exploreSpotlightError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load spotlight: {error}'**
  String exploreSpotlightError(String error);

  /// No description provided for @exploreSkaterLeaders.
  ///
  /// In en, this message translates to:
  /// **'Skater Leaders'**
  String get exploreSkaterLeaders;

  /// No description provided for @exploreGoalieLeaders.
  ///
  /// In en, this message translates to:
  /// **'Goalie Leaders'**
  String get exploreGoalieLeaders;

  /// No description provided for @exploreSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get exploreSeeAll;

  /// No description provided for @exploreShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get exploreShowLess;

  /// No description provided for @exploreFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String exploreFailedToLoad(String error);

  /// No description provided for @exploreBrowseByTeam.
  ///
  /// In en, this message translates to:
  /// **'Browse by Team'**
  String get exploreBrowseByTeam;

  /// No description provided for @exploreSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No players found'**
  String get exploreSearchNoResults;

  /// No description provided for @exploreSearchNoResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get exploreSearchNoResultsHint;

  /// No description provided for @exploreSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed: {error}'**
  String exploreSearchFailed(String error);

  /// No description provided for @teamRosterTitle.
  ///
  /// In en, this message translates to:
  /// **'{teamAbbrev} Roster'**
  String teamRosterTitle(String teamAbbrev);

  /// No description provided for @teamRosterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No players found'**
  String get teamRosterEmpty;

  /// No description provided for @teamRosterError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load roster: {error}'**
  String teamRosterError(String error);

  /// No description provided for @playerDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Player Detail'**
  String get playerDetailTitle;

  /// No description provided for @playerDetailLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get playerDetailLoading;

  /// No description provided for @playerDetailFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load player'**
  String get playerDetailFailedToLoad;

  /// No description provided for @playerDetailNoTeam.
  ///
  /// In en, this message translates to:
  /// **'No team assigned'**
  String get playerDetailNoTeam;

  /// No description provided for @playerDetailTrendError.
  ///
  /// In en, this message translates to:
  /// **'Could not load trend data'**
  String get playerDetailTrendError;

  /// No description provided for @playerDetailTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get playerDetailTabOverview;

  /// No description provided for @playerDetailTabGameLog.
  ///
  /// In en, this message translates to:
  /// **'Game Log'**
  String get playerDetailTabGameLog;

  /// No description provided for @playerDetailTabSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get playerDetailTabSchedule;

  /// No description provided for @playerDetailTabCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get playerDetailTabCareer;

  /// No description provided for @playerDetailAge.
  ///
  /// In en, this message translates to:
  /// **'Age {age}'**
  String playerDetailAge(int age);

  /// No description provided for @playerDetailWeight.
  ///
  /// In en, this message translates to:
  /// **'{weight} lbs'**
  String playerDetailWeight(int weight);

  /// No description provided for @playerDetailShootsLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get playerDetailShootsLeft;

  /// No description provided for @playerDetailShootsRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get playerDetailShootsRight;

  /// No description provided for @playerDetailDraftLabel.
  ///
  /// In en, this message translates to:
  /// **'Draft: {details}'**
  String playerDetailDraftLabel(String details);

  /// No description provided for @playerDetailDraftRound.
  ///
  /// In en, this message translates to:
  /// **'Round {round}'**
  String playerDetailDraftRound(int round);

  /// No description provided for @playerDetailDraftPick.
  ///
  /// In en, this message translates to:
  /// **'Pick {pick}'**
  String playerDetailDraftPick(int pick);

  /// No description provided for @playerDetailDraftOverall.
  ///
  /// In en, this message translates to:
  /// **'#{overall} overall'**
  String playerDetailDraftOverall(int overall);

  /// No description provided for @playerDetailDraftBy.
  ///
  /// In en, this message translates to:
  /// **'by {team}'**
  String playerDetailDraftBy(String team);

  /// No description provided for @seasonStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Season Stats'**
  String get seasonStatsTitle;

  /// No description provided for @seasonStatsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stats available'**
  String get seasonStatsEmpty;

  /// No description provided for @careerStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Career Stats'**
  String get careerStatsTitle;

  /// No description provided for @careerStatsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No career stats available'**
  String get careerStatsEmpty;

  /// No description provided for @careerStatsNhlOnly.
  ///
  /// In en, this message translates to:
  /// **'NHL Only'**
  String get careerStatsNhlOnly;

  /// No description provided for @careerStatsColumnSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get careerStatsColumnSeason;

  /// No description provided for @careerStatsColumnTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get careerStatsColumnTeam;

  /// No description provided for @gameLogFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load game log'**
  String get gameLogFailedToLoad;

  /// No description provided for @gameLogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No games played yet'**
  String get gameLogEmpty;

  /// No description provided for @gameLogDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get gameLogDate;

  /// No description provided for @gameLogOpp.
  ///
  /// In en, this message translates to:
  /// **'Opp'**
  String get gameLogOpp;

  /// No description provided for @gameLogDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get gameLogDec;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleTitle;

  /// No description provided for @scheduleFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load schedule'**
  String get scheduleFailedToLoad;

  /// No description provided for @scheduleNoGames.
  ///
  /// In en, this message translates to:
  /// **'No games scheduled'**
  String get scheduleNoGames;

  /// No description provided for @scheduleNoGamesHint.
  ///
  /// In en, this message translates to:
  /// **'Try a different date'**
  String get scheduleNoGamesHint;

  /// No description provided for @scheduleUpcomingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No upcoming games scheduled'**
  String get scheduleUpcomingEmpty;

  /// No description provided for @scheduleUpcomingError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load schedule'**
  String get scheduleUpcomingError;

  /// No description provided for @scheduleBackToBack.
  ///
  /// In en, this message translates to:
  /// **'B2B'**
  String get scheduleBackToBack;

  /// No description provided for @schedulePreviousDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get schedulePreviousDay;

  /// No description provided for @scheduleNextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get scheduleNextDay;

  /// No description provided for @scheduleDateDisplay.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String scheduleDateDisplay(DateTime date);

  /// No description provided for @scheduleLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get scheduleLive;

  /// No description provided for @scheduleFinal.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get scheduleFinal;

  /// No description provided for @scheduleTbd.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get scheduleTbd;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get settingsDisclaimer;

  /// No description provided for @settingsDisclaimerText.
  ///
  /// In en, this message translates to:
  /// **'This app uses unofficial NHL API data. Not affiliated with or endorsed by the NHL.'**
  String get settingsDisclaimerText;

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingsClearCache;

  /// No description provided for @settingsCacheCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cached entries'**
  String settingsCacheCount(int count);

  /// No description provided for @settingsCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared {count} cache entries'**
  String settingsCacheCleared(int count);

  /// No description provided for @statTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Stat Trend'**
  String get statTrendTitle;

  /// No description provided for @statTrendEmpty.
  ///
  /// In en, this message translates to:
  /// **'No game data available'**
  String get statTrendEmpty;

  /// No description provided for @statTrendPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get statTrendPoints;

  /// No description provided for @statTrendGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get statTrendGoals;

  /// No description provided for @statTrendAssists.
  ///
  /// In en, this message translates to:
  /// **'Assists'**
  String get statTrendAssists;

  /// No description provided for @statTrendShots.
  ///
  /// In en, this message translates to:
  /// **'Shots'**
  String get statTrendShots;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
