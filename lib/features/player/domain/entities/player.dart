class Player {
  final int id;
  final String firstName;
  final String lastName;
  final String? teamAbbrev;
  final String? teamName;
  final String position;
  final int? sweaterNumber;
  final String? headshot;
  final bool isActive;

  const Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.teamAbbrev,
    this.teamName,
    required this.position,
    this.sweaterNumber,
    this.headshot,
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName';
}
