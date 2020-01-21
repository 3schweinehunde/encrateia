import 'dart:math';

extension StatisticFunctions on Iterable {
  double mean() {
    List<int> records = this.toList();
    var sum = records.reduce((a, b) => a + b);
    var number = records.length;
    return sum / number;
  }

  double sdev() {
    List<int> records = this.toList();
    var mean = records.mean();

    var sumOfErrorSquares =
        records.fold(0.0, (double sum, next) => sum + pow(next - mean, 2));
    var variance = sumOfErrorSquares / records.length;
    return sqrt(variance);
  }
}
