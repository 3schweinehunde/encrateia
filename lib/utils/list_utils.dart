import 'dart:math' as math;

extension StatisticFunctions on Iterable<dynamic> {
  double mean() {
    final double sum = fold(0, (double a, dynamic b) => a + (b as num));
    final int number = length;
    return sum / number;
  }

  double sdev() {
    final double mean = toList().mean();

    final double sumOfErrorSquares = fold(0.0,
        (double sum, dynamic next) => sum + math.pow((next as num) - mean, 2));
    final double variance = sumOfErrorSquares / length;
    return math.sqrt(variance);
  }

  List<num?> nonZeros() {
    final List<num> values = whereType<num>().toList();
    final Iterable<num?> nonZeroValues =
        values.where((num value) => value != 0);
    return nonZeroValues.toList();
  }
}
