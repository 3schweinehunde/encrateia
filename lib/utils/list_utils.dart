import 'dart:math' as math;
import 'package:encrateia/models/event.dart';

extension StatisticFunctions on Iterable {
  double mean() {
    var sum = fold(0, (a, b) => a + b);
    var number = length;
    return sum / number;
  }

  double sdev() {
    var mean = toList().mean();

    var sumOfErrorSquares =
        this.fold(0.0, (double sum, next) => sum + math.pow(next - mean, 2));
    var variance = sumOfErrorSquares / length;
    return math.sqrt(variance);
  }

  int min() {
    List<int> values = toList();
    return values.reduce(math.min);
  }

  int max() {
    List<int> values = toList();
    return values.reduce(math.max);
  }

  List<int> nonZeroInts() {
    List<int> values = toList();
    var nonZeroValues = values.where((value) => value != null && value != 0);
    return nonZeroValues.toList();
  }

  List<double> nonZeroDoubles() {
    List<double> values = toList();
    var nonZeroValues = values.where((value) => value != null && value != 0);
    return nonZeroValues.toList();
  }

  Iterable<Event> everyNth(int n) sync* {
    List<Event> values = toList();
    int i = 0;
    for (var e in values) if (i++ % n == 0) yield e;
  }
}
