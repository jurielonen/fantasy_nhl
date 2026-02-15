class StatLeader {
  final int playerId;
  final String firstName;
  final String lastName;
  final String? teamAbbrev;
  final String? headshot;
  final String? position;
  final double statValue;
  final String statCategory;

  const StatLeader({
    required this.playerId,
    required this.firstName,
    required this.lastName,
    this.teamAbbrev,
    this.headshot,
    this.position,
    required this.statValue,
    required this.statCategory,
  });

  String get fullName => '$firstName $lastName';
}
