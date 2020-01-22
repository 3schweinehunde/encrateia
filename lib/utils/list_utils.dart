import 'dart:math' as math;
import 'package:encrateia/models/event.dart';

extension StatisticFunctions on Iterable {
  double mean(){
    List<int> values = this;
    var sum = values.reduce((a, b) => a + b);
    var number = this.length;
    return sum / number;
  }

  double sdev() {
    var mean = this.toList().mean();

    var sumOfErrorSquares =
        this.fold(0.0, (double sum, next) => sum + math.pow(next - mean, 2));
    var variance = sumOfErrorSquares / this.length;
    return math.sqrt(variance);
  }

  int min() {
    List<int> values = this.toList();
    return values.reduce(math.min);
  }

  int max() {
    List<int> values = this.toList();
    return values.reduce(math.max);
  }

  List<int> nonZero() {
    List<int> values = this.toList();
    var nonZeroValues = values.where((value) => value != null && value != 0);
    return nonZeroValues.toList();
  }

  Iterable<Event> everyNth(int n) sync* {
    List<Event> values = this.toList();
    int i = 0;
    for (var e in values) if (i++ % n == 0) yield e;
  }
}
