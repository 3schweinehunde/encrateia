import 'dart:math' as math;

extension StatisticFunctions on Iterable {
  double mean() {
    var nonZeroValues = this.nonZero();
    var sum = nonZeroValues.reduce((a, b) => a + b);
    var number = nonZeroValues.length;
    return sum / number;
  }

  double sdev() {
    var nonZeroValues = this.nonZero();
    var mean = nonZeroValues.mean();

    var sumOfErrorSquares = nonZeroValues.fold(
        0.0, (double sum, next) => sum + math.pow(next - mean, 2));
    var variance = sumOfErrorSquares / nonZeroValues.length;
    return math.sqrt(variance);
  }

  int min() {
    return this.nonZero().reduce(math.min);
  }

  int max() {
    return this.nonZero().reduce(math.max);
  }

  List<int> nonZero() {
    List<int> values = this.toList();
    var nonZeroValues = values.where((value) => value != null && value != 0);
    return nonZeroValues.toList();
  }
}
