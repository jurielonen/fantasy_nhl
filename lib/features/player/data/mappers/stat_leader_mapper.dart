import '../../domain/entities/stat_leader.dart';
import '../dtos/leader_entry_dto.dart';
import '../dtos/skater_leaders_dto.dart';
import '../dtos/goalie_leaders_dto.dart';

extension LeaderEntryDtoMapper on LeaderEntryDto {
  StatLeader toEntity(String category) => StatLeader(
        playerId: id ?? 0,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        teamAbbrev: teamAbbrev,
        headshot: headshot,
        position: position,
        statValue: value ?? 0,
        statCategory: category,
      );
}

extension SkaterLeadersDtoMapper on SkaterLeadersDto {
  List<StatLeader> toLeaders(String category) {
    final entries = switch (category) {
      'goals' => goals,
      'assists' => assists,
      'points' => points,
      'plusMinus' => plusMinus,
      'penaltyMins' => penaltyMins,
      'toi' => toi,
      _ => goals,
    };
    return (entries ?? []).map((e) => e.toEntity(category)).toList();
  }
}

extension GoalieLeadersDtoMapper on GoalieLeadersDto {
  List<StatLeader> toLeaders(String category) {
    final entries = switch (category) {
      'wins' => wins,
      'gaa' => gaa,
      'savePctg' => savePctg,
      'shutouts' => shutouts,
      _ => wins,
    };
    return (entries ?? []).map((e) => e.toEntity(category)).toList();
  }
}
