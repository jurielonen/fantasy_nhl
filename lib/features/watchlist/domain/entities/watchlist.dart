class Watchlist {
  final String id;
  final String name;
  final List<int> playerIds;
  final int sortOrder;
  final DateTime createdAt;

  const Watchlist({
    required this.id,
    required this.name,
    this.playerIds = const [],
    this.sortOrder = 0,
    required this.createdAt,
  });
}
