class StatFormatter {
  StatFormatter._();

  static String plusMinus(int value) => value >= 0 ? '+$value' : '$value';

  static String timeOnIce(double minutes) {
    final mins = minutes.floor();
    final secs = ((minutes - mins) * 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  static String savePercentage(double pct) =>
      pct >= 1 ? pct.toStringAsFixed(3) : '.${(pct * 1000).round()}';

  static String gaa(double value) => value.toStringAsFixed(2);
}
