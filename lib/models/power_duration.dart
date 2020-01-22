import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/plot_point.dart';

class PowerDuration {
  Map powerMap = {};

  PowerDuration({List<Event> records}) {
    int lastPower = 0;

    for (int index = 0; index < records.length - 1; index++) {
      int power = records[index].db.power;
      if (power > lastPower) {
        DateTime nextLower = records
            .sublist(index + 1, records.length)
            .firstWhere((record) => record.db.power < power,
                orElse: () => records.last)
            .db
            .timeStamp;
        int persistedFor =
            nextLower.difference(records[index].db.timeStamp).inSeconds;

        if (power > (powerMap[persistedFor] ?? 0)) {
          for (int durationIndex = persistedFor;
              durationIndex > 0;
              durationIndex--) {
            if (power > (powerMap[durationIndex] ?? 0)) {
              powerMap[durationIndex] = power;
            } else {
              break;
            }
          }
        }
      }
      lastPower = power;
    }
  }

  List<PlotPoint> asList() {
    List<PlotPoint> plotPoints = [];

    powerMap.forEach((duration, power) {
      plotPoints.add(PlotPoint(
        domain: duration,
        measure: power,
      ));
    });

    plotPoints.sort((a, b) => a.domain.compareTo(b.domain));
    return plotPoints;
  }
}
