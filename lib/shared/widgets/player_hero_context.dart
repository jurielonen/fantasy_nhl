import '../../features/player/domain/entities/player.dart';

enum PlayerHeroContext {
  spotlight,
  statLeader,
  watchlist,
  teamRoster,
  searchResult,
}

extension PlayerHeroContextTag on PlayerHeroContext {
  String tag(int playerId) => 'player_${name}_$playerId';
}

class PlayerDetailExtra {
  final PlayerHeroContext heroContext;
  final Player? player;
  const PlayerDetailExtra({required this.heroContext, this.player});
}
