# AI Prompt: Fantasy NHL Companion App in Flutter

---

## Prompt

Build a cross-platform mobile application using **Flutter** for fantasy NHL league players. The app helps users discover, track, and evaluate NHL players they may want to pick up, trade for, or monitor in their fantasy leagues.

---

## Project Overview

**App Name:** (TBD — suggest a name)  
**Platform:** Flutter (iOS, Android)
**Primary Data Source:** NHL Official API (`https://api-web.nhle.com/`)  
**Target User:** Experienced fantasy hockey players who want a fast, clean way to track players of interest across the NHL.

---

## Core Feature: Player Watchlist / Favorites

### Functional Requirements

1. **Player Search & Discovery**
    - Search NHL players by name with debounced text input
    - Browse players by team, position (C, LW, RW, D, G), or stat category
    - Display player cards showing: name, team, position, headshot, key stats (GP, G, A, P, +/-, TOI for skaters; W, GAA, SV% for goalies)

2. **Watchlist Management**
    - Add/remove players to a personal watchlist with a single tap
    - Persist watchlist locally using **Drift** (SQLite)
    - Support multiple named watchlists (e.g., "Trade Targets", "Waiver Wire", "Keep an Eye On")
    - Reorder players within a watchlist via drag-and-drop

3. **Player Detail Screen**
    - Full season stats table (current + previous seasons)
    - Game log: last 10 games with per-game stat lines
    - Upcoming schedule (next 5 games with opponents and home/away)
    - Simple stat trend visualization (goals, assists, points over last 15–30 games) using `fl_chart`

4. **Watchlist Dashboard**
    - At-a-glance view of all watchlisted players with their tonight's game status (playing / off / game time)
    - Sort watchlist by: points, goals, recent hot streak, or position
    - Visual indicator for players who played today, with quick stat summary of their latest game

---

## Technical Requirements

### Architecture & State Management
- Use **clean architecture** with clear separation: `data` → `domain` → `presentation` layers
- State management: **Riverpod** (recommend `riverpod` with `code_generation` or `flutter_riverpod` with `StateNotifier`/`AsyncNotifier`)
- Repository pattern for all data access
- Use `freezed` for immutable data models and union types
- Use `dio` as the HTTP client with interceptors for logging, error handling, and cache headers
- Use **Retrofit** (`retrofit` + `retrofit_generator`) for type-safe, code-generated API client classes built on top of Dio
- Define all API endpoints as abstract methods in Retrofit client interfaces, annotated with `@GET`, `@Path`, etc.
- Generate the implementation via `build_runner`

### NHL API Integration

There are **two** NHL APIs. Use both via separate Retrofit clients:

#### API 1: NHL Web API — `https://api-web.nhle.com/`
Create Retrofit client: `NhlWebApiClient`

**Player Endpoints (Priority: HIGH)**
- `@GET("/v1/player/{playerId}/landing")` → Full player profile, bio, current & career stats, awards. **Primary source for player detail screen.**
- `@GET("/v1/player/{playerId}/game-log/now")` → Current season game log (redirects to current season/game-type).
- `@GET("/v1/player/{playerId}/game-log/{season}/{gameType}")` → Game log for specific season. `season` is `YYYYYYYY` format (e.g., `20242025`). `gameType`: `2` = regular season, `3` = playoffs.
- `@GET("/v1/player-spotlight")` → Trending/featured players. **Use for the Explore/Discovery screen.**

**Skater & Goalie Leaders (Priority: HIGH)**
- `@GET("/v1/skater-stats-leaders/current")` → Current skater stat leaders. Supports `@Query("categories")` (e.g., `"goals"`, `"assists"`, `"points"`) and `@Query("limit")` (`-1` = all). **Essential for Explore screen rankings.**
- `@GET("/v1/skater-stats-leaders/{season}/{gameType}")` → Skater leaders for a specific season. Same query params.
- `@GET("/v1/goalie-stats-leaders/current")` → Current goalie stat leaders. Supports `@Query("categories")` (e.g., `"wins"`, `"gaa"`, `"savePctg"`) and `@Query("limit")`.
- `@GET("/v1/goalie-stats-leaders/{season}/{gameType}")` → Goalie leaders for a specific season.

**Team & Roster Endpoints (Priority: HIGH)**
- `@GET("/v1/roster/{team}/current")` → Current team roster. `team` is 3-letter code (e.g., `"TOR"`, `"EDM"`). **Used for browse-by-team player discovery.**
- `@GET("/v1/roster/{team}/{season}")` → Roster for a specific season.
- `@GET("/v1/prospects/{team}")` → Team prospects.
- `@GET("/v1/club-stats/{team}/now")` → Current club stats (all skater/goalie stats for team).
- `@GET("/v1/club-stats/{team}/{season}/{gameType}")` → Club stats by season.

**Standings (Priority: MEDIUM)**
- `@GET("/v1/standings/now")` → Current standings.
- `@GET("/v1/standings/{date}")` → Standings for a date (`YYYY-MM-DD`).

**League Schedule (Priority: HIGH)**
- `@GET("/v1/schedule/now")` → Today's full league schedule. **Needed for watchlist "playing tonight" indicators.**
- `@GET("/v1/schedule/{date}")` → Schedule for a specific date.
- `@GET("/v1/schedule-calendar/now")` → Schedule calendar (which dates have games).

**Team Schedule (Priority: HIGH)**
- `@GET("/v1/club-schedule/{team}/week/now")` → Current week schedule for a team. **Use for "upcoming games" on player detail.**
- `@GET("/v1/club-schedule/{team}/week/{date}")` → Week schedule for a specific date.
- `@GET("/v1/club-schedule/{team}/month/now")` → Current month schedule.
- `@GET("/v1/club-schedule/{team}/month/{month}")` → Month schedule (`YYYY-MM`).
- `@GET("/v1/club-schedule-season/{team}/now")` → Full season schedule.

**Scores & Scoreboard (Priority: MEDIUM)**
- `@GET("/v1/score/now")` → Today's scores. **Use on watchlist dashboard to show live/final scores for tracked players.**
- `@GET("/v1/score/{date}")` → Scores for a specific date.
- `@GET("/v1/scoreboard/now")` → Overall scoreboard.
- `@GET("/v1/scoreboard/{team}/now")` → Team-specific scoreboard.

**Game Detail (Priority: LOW — for future expansion)**
- `@GET("/v1/gamecenter/{gameId}/boxscore")` → Full boxscore.
- `@GET("/v1/gamecenter/{gameId}/landing")` → Game landing/summary.
- `@GET("/v1/gamecenter/{gameId}/play-by-play")` → Play-by-play.

#### API 2: NHL Stats API — `https://api.nhle.com/stats/rest`
Create Retrofit client: `NhlStatsApiClient`

**Player Search (Priority: HIGH)**
- `@GET("/en/players")` → **Primary player search endpoint.** Supports `@Query("cayenneExp")` for filtering (e.g., `"currentTeamId=7"`), `@Query("sort")`, `@Query("dir")`, `@Query("start")`, `@Query("limit")` (`-1` = all). Note: default limit is 5, always override. **This is the only searchable player index across both APIs.**

**Skater Stats (Priority: MEDIUM)**
- `@GET("/en/skater/{report}")` → Skater stats by report type (e.g., `"summary"`, `"bpiostats"`, `"faceoffpercentages"`, `"realtime"`, etc.). Requires `@Query("cayenneExp")` (e.g., `"seasonId=20242025"`). Supports `sort`, `dir`, `start`, `limit`.

**Goalie Stats (Priority: MEDIUM)**
- `@GET("/en/goalie/{report}")` → Goalie stats by report type. Same query params as skater stats.

**Team Info (Priority: MEDIUM)**
- `@GET("/en/team")` → All teams list. **Cache this — it rarely changes. Use for team picker/filter UI.**

**Configuration (Priority: LOW — useful for bootstrapping)**
- `@GET("/en/config")` → API configuration (available report types, sort fields, etc.). Useful for understanding valid query params dynamically.

### Retrofit Implementation Notes
- Split into two Retrofit client interfaces: `NhlWebApiClient` (web API) and `NhlStatsApiClient` (stats API), each with its own Dio instance and base URL
- All endpoint return types should be `Future<ResponseDto>` using `freezed`/`json_serializable` DTOs
- Use `@Path`, `@Query`, and `@Queries` annotations as needed
- Season format is always `YYYYYYYY` (e.g., `20242025`) in the Web API and `seasonId=20242025` as a cayenne expression in the Stats API
- The Stats API uses a Cayenne expression query language for filtering — document common expressions as constants (e.g., `"seasonId=20242025 and gameTypeId=2"`)
- Implement a caching layer backed by the Drift `ApiCache` table to avoid redundant API calls
- Handle API rate limits gracefully; add retry logic with exponential backoff via a Dio interceptor
- Both APIs are unofficial/undocumented — add defensive JSON parsing and null-safety throughout all DTOs

### Data Models (generate with `freezed`)
- `Player` — id, name, team, position, headshot URL, current season stats
- `GameLog` — date, opponent, stats per game
- `Watchlist` — id, name, list of player IDs, sort order
- `Schedule` — game ID, teams, date/time, venue
- `TeamRoster` — team info, list of players

### Local Storage (Drift / SQLite)
- Use **Drift** (`drift` + `drift_flutter`) as the local persistence layer for all storage needs
- The single `AppDatabase` instance is created at app startup and provided via `appDatabaseProvider` (overridden in `main.dart`); all DAO providers derive from it
- Database tables:
  - `Watchlists` — id (PK), name, sortOrder, createdAt
  - `WatchlistPlayers` — auto-increment PK, watchlistId (FK → Watchlists with cascade delete), playerId, position; unique on (watchlistId, playerId)
  - `CachedPlayers` — id (PK), firstName, lastName, teamAbbrev, teamName, position, sweaterNumber, headshot, isActive
  - `ApiCache` — cacheKey (PK), data (JSON string), fetchedAt (ISO-8601), ttlMinutes; expiry checked via `ApiCacheDao.isExpired()`
  - `Settings` — key (PK), value; used for simple key-value settings (e.g., theme mode stored under `settings:theme_mode`)
- DAOs live in `lib/core/database/daos/` and are exposed via Riverpod providers in `lib/core/database/database_provider.dart`
- `WatchlistDao.watchAllWatchlists()` returns a reactive `Stream<List<Watchlist>>` using a `customSelect('SELECT 1', readsFrom: {watchlists, watchlistPlayers})` trigger pattern — re-emits via `asyncMap` whenever either table changes
- Store API response JSON as strings in `ApiCache`; always check `isExpired()` before using a cached entry (default TTL: 15 minutes)
- Map between Drift row types and domain entities in the repository layer; DAOs return row types, repositories return domain entities

### UI / UX Guidelines
- **Design system:** Material 3 with a dark theme by default (hockey vibes — dark background, ice-blue accents, white text)
- Responsive layout: single-column on mobile, multi-pane on tablet
- Use `CachedNetworkImage` for player headshots
- Skeleton/shimmer loading states for all async content
- Pull-to-refresh on all list screens
- Smooth hero animations when navigating from player card → player detail
- Bottom navigation with tabs: **Watchlist**, **Explore**, **Schedule**, **Settings**

### Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   ├── network/          # Dio client setup, interceptors, Retrofit API clients
│   └── database/         # Drift AppDatabase, table definitions, DAOs, database_provider.dart
├── features/
│   ├── player/
│   │   ├── data/         # DTOs, data sources, repository impl
│   │   ├── domain/       # Entities, repository interface, use cases
│   │   └── presentation/ # Screens, widgets, providers
│   ├── watchlist/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── schedule/
│   └── settings/
├── shared/
│   └── widgets/          # Reusable components (player card, stat chip, etc.)
└── main.dart
```

### Key Packages
- `flutter_riverpod` / `riverpod_annotation` — state management
- `dio` — HTTP client (underlying transport for Retrofit)
- `retrofit` / `retrofit_generator` — code-generated, type-safe API clients
- `drift` / `drift_flutter` — SQLite-backed local persistence (watchlists, player cache, API cache, settings)
- `drift_dev` — code generation for Drift tables and DAOs (run via `build_runner`)
- `freezed` / `json_serializable` — data models & DTOs
- `fl_chart` — stat trend charts
- `go_router` — declarative routing
- `cached_network_image` — image caching
- `shimmer` — loading placeholders
- `flutter_slidable` — swipe actions on watchlist items

---

## Out of Scope (for now)
- User authentication / accounts
- Push notifications
- Live game score streaming
- Trade/pickup AI recommendations
- Social features or league syncing

---

## Additional Context (Include in ALL phases)
- I am an **advanced Flutter developer** — do not over-explain basics. Write production-quality, idiomatic Dart.
- Prefer declarative and functional patterns where appropriate.
- Write concise, well-typed code. Avoid `dynamic` and unnecessary null assertions.
- Include brief code comments only where logic is non-obvious.

---

## Localization (l10n) Rules

This project uses Flutter's built-in localization with ARB files. **Every user-facing string MUST be localized.** Never hardcode UI strings.

### How to use
- Access localized strings via `context.l10n.keyName` (extension defined in `core/utils/l10n_extension.dart`)
- ARB file location: `lib/l10n/app_en.arb`
- Generated output: `AppLocalizations` class via `flutter gen-l10n`

### Key naming convention
- Pure camelCase — **no underscores**
- Prefix with screen/section name: `exploreTitle`, `watchlistEmpty`, `playerDetailGameLog`, `settingsTheme`, `scheduleNoGames`
- Common/shared: `commonRetry`, `commonCancel`, `commonSave`
- Errors: `errorGeneric`, `errorNoConnection`, `errorLoadingFailed`

### Rules
- **Never use hardcoded strings** in `Text()`, `hintText`, `label`, `title`, `tooltip`, `semanticLabel`, snackbar messages, dialog content, or any other user-facing context
- **Always add new keys** to `app_en.arb` when creating new UI text, then run `flutter gen-l10n`
- **Use placeholders** for dynamic values: `"watchlistAddedTo": "Added to {watchlistName}"` with `@watchlistAddedTo` metadata
- **Use ICU plural format** for count-dependent strings: `"{count, plural, =0{No players} =1{1 player} other{{count} players}}"`
- **Do NOT localize**: stat abbreviations (GP, G, A, P, +/-, PIM, PPG, etc.), team abbreviations, player names, API-sourced data values
- **Use `intl` `DateFormat`** with the current locale for date/time formatting — never hardcode date formats