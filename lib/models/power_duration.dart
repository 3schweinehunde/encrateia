import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/plot_point.dart';
import 'dart:math';

class PowerDuration {
  Map powerMap = {};

  PowerDuration({List<Event> records}) {
    for (int index = 0; index < records.length - 1; index++) {
      int power = records[index].db.power;
      DateTime nextLower = records
          .sublist(index + 1, records.length)
          .firstWhere((record) => record.db.power < power,
              orElse: () => records.last)
          .db
          .timeStamp;

      DateTime recentLower = records
          .sublist(0, index)
          .lastWhere((record) => record.db.power < power,
              orElse: () => records.first)
          .db
          .timeStamp;

      int persistedFor = nextLower.difference(recentLower).inSeconds;

      if (power > (powerMap[persistedFor] ?? 0)) {
        for (int durationIndex = persistedFor;
            durationIndex > 0;
            durationIndex--) {
          if (power <= (powerMap[durationIndex] ?? 0)) break;
          powerMap[durationIndex] = power;
        }
      }
    }
  }

  asList() {
    List<IntPlotPoint> plotPoints = [];

    powerMap.forEach((duration, power) {
      plotPoints.add(IntPlotPoint(
        domain: scaled(seconds: duration),
        measure: power,
      ));
    });

    plotPoints.sort((a, b) => a.domain.compareTo(b.domain));
    return plotPoints;
  }

  static scaled({int seconds}) => (200 * log(seconds)).round();
}
