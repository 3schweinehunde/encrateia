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

  int min() {
    final List<int> values = toList().cast<int>();
    return values.reduce(math.min);
  }

  int max() {
    final List<int> values = toList().cast<int>();
    return values.reduce(math.max);
  }

  List<int> nonZeroInts() {
    final List<int> values = toList().cast<int>();
    final Iterable<int> nonZeroValues =
        values.where((int value) => value != null && value != 0);
    return nonZeroValues.toList();
  }

  List<double> nonZeroDoubles() {
    final List<double> values = toList().cast<double>();
    final Iterable<double> nonZeroValues =
        values.where((double value) => value != null && value != 0);
    return nonZeroValues.toList();
  }
}
