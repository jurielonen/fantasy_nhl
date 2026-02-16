import '../entities/game_log_entry.dart';
import '../entities/player.dart';
import '../entities/player_detail.dart';
import '../entities/stat_leader.dart';

abstract class PlayerRepository {
  Future<List<Player>> searchPlayers(String query);
  Future<PlayerDetail> getPlayerDetail(int id);
  Future<List<GameLogEntry>> getGameLog(int id);
  Future<List<Player>> getTeamRoster(String teamAbbrev);
  Future<List<StatLeader>> getSkaterLeaders(String category, {int? limit});
  Future<List<StatLeader>> getGoalieLeaders(String category, {int? limit});
  Future<List<Player>> getSpotlightPlayers();
  Player? getCachedPlayer(int id);
  Future<Player> getPlayerBasicInfo(int id);
}
