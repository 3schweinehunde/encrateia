import 'dart:math';
import '/models/event.dart';
import '/models/plot_point.dart';

class PowerDuration {
  PowerDuration({required List<Event> records}) {
    final Map<int, EnergyPoint> powerSum = <int, EnergyPoint>{};

    for (int index = 1; index <= records.length - 1; index++) {
      final int power = records[index].power!;
      final int duration = records[index]
          .timeStamp!
          .difference(records[index - 1].timeStamp!)
          .inSeconds;

      powerSum.forEach((int start, EnergyPoint energyPoint) {
        final int newEnergy = energyPoint.energy + power * duration;
        final int newDuration = energyPoint.duration + duration;

        powerSum[start] = EnergyPoint(
          energy: newEnergy,
          duration: newDuration,
        );

        final double newPower = newEnergy / newDuration;
        if (newPower > (powerMap[newDuration] ?? 0)) {
          for (int durationIndex = newDuration;
              durationIndex > 0;
              durationIndex--) {
            if (newPower <= (powerMap[durationIndex] ?? 0)) {
              break;
            }
            powerMap[durationIndex] = newPower;
          }
        }
      });

      powerSum[index - 1] = EnergyPoint(
        energy: power * duration,
        duration: duration,
      );

      if (power > (powerMap[duration] ?? 0)) {
        for (int durationIndex = duration; durationIndex > 0; durationIndex--) {
          if (power <= (powerMap[durationIndex] ?? 0)) {
            break;
          }
          powerMap[durationIndex] = power.toDouble();
        }
      }
    }
  }

  Map<int, double> powerMap = <int, double>{};

  List<DoublePlotPoint> asList() {
    final List<DoublePlotPoint> plotPoints = <DoublePlotPoint>[];

    powerMap.forEach((int duration, double power) {
      plotPoints.add(DoublePlotPoint(
        domain: scaled(seconds: duration),
        measure: power,
      ));
    });

    plotPoints.sort(
        (DoublePlotPoint a, DoublePlotPoint b) => a.domain.compareTo(b.domain));
    return plotPoints;
  }

  PowerDuration normalize() {
    powerMap.forEach((int duration, double power) =>
        powerMap[duration] = power * pow(3600 / duration, -0.07));
    return this;
  }

  static int scaled({required int seconds}) => (200 * log(seconds)).round();
}
