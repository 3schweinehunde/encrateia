import 'dart:math';
import '/models/event.dart';
import '/models/plot_point.dart';

class MinimumPowerDuration {
  MinimumPowerDuration({required List<Event> records}) {
    for (int index = 0; index < records.length - 1; index++) {
      final int power = records[index].power!;
      final DateTime nextLower = records
          .sublist(index + 1, records.length)
          .firstWhere((Event record) => record.power! < power,
              orElse: () => records.last)
          .timeStamp!;

      final DateTime recentLower = records
          .sublist(0, index)
          .lastWhere((Event record) => record.power! < power,
              orElse: () => records.first)
          .timeStamp!;

      final int persistedFor = nextLower.difference(recentLower).inSeconds;

      if (power > (powerMap[persistedFor] ?? 0)) {
        for (int durationIndex = persistedFor;
            durationIndex > 0;
            durationIndex--) {
          if (power <= (powerMap[durationIndex] ?? 0)) {
            break;
          }
          powerMap[durationIndex] = power;
        }
      }
    }
  }

  Map<int, int> powerMap = <int, int>{};

  List<IntPlotPoint> asList() {
    final List<IntPlotPoint> plotPoints = <IntPlotPoint>[];

    powerMap.forEach((int duration, int power) {
      plotPoints.add(IntPlotPoint(
        domain: scaled(seconds: duration),
        measure: power,
      ));
    });

    plotPoints
        .sort((IntPlotPoint a, IntPlotPoint b) => a.domain.compareTo(b.domain));
    return plotPoints;
  }

  static int scaled({required int seconds}) => (200 * log(seconds)).round();
}
