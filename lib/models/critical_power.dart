import 'dart:math';
import '/models/event.dart';
import '/models/plot_point.dart';
import '/models/power_duration.dart';

class CriticalPower extends PowerDuration {
  CriticalPower({required List<Event> records}) : super(records: records);

  List<DoublePlotPoint> asWorkList() {
    final List<DoublePlotPoint> plotPoints = <DoublePlotPoint>[];

    powerMap.forEach((int duration, double power) {
      if (duration > 60 && duration < 1200) {
        plotPoints.add(DoublePlotPoint(
          domain: duration,
          measure: power,
        ));
      }
    });

    plotPoints.sort((DoublePlotPoint a, DoublePlotPoint b) =>
        a.domain!.compareTo(b.domain!));
    return plotPoints;
  }

  double xbar() =>
      powerMap.keys.reduce((int a, int b) => a + b) / powerMap.length;

  double ybar() =>
      powerMap.values.reduce((double a, double b) => a + b) / powerMap.length;

  double pCrit() {
    final double xbar = this.xbar();
    final double ybar = this.ybar();
    double numerator = 0;
    double denominator = 0;

    powerMap.forEach((int duration, double power) =>
        numerator += (duration.toDouble() - xbar) * (power - ybar));
    powerMap
        .forEach((int duration, _) => denominator += pow(duration - xbar, 2));
    return numerator / denominator;
  }

  double wPrime() => ybar() - (pCrit() * xbar());

  double rSquared() {
    final double xbar = this.xbar();
    final double ybar = this.ybar();
    double numerator = 0;
    double denominatorOne = 0;
    double denominatorTwo = 0;
    double counter = 0;

    powerMap.forEach((int duration, double power) {
      counter++;
      numerator += pow((duration * power) - (counter * xbar * ybar), 2);
    });

    powerMap.forEach((int duration, double power) {
      counter++;
      denominatorOne += (duration * duration) - (counter * xbar * xbar);
    });

    powerMap.forEach((int duration, double power) {
      counter++;
      denominatorTwo += (power * power) - (counter * ybar * ybar);
    });

    return numerator / denominatorOne / denominatorTwo;
  }

  CriticalPower workify() {
    powerMap.forEach(
        (int duration, double power) => powerMap[duration] = power * duration);
    return this;
  }

  static int scaled({required int seconds}) => (200 * log(seconds)).round();
}
