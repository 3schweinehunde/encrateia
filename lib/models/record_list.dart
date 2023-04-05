import 'package:collection/collection.dart';
import '/models/event.dart';
import '/models/plot_point.dart';
import '/models/power_zone.dart';
import '/models/power_zone_schema.dart';
import '/utils/enums.dart';
import '/utils/list_utils.dart';
import '/utils/map_utils.dart';
import 'bar_zone.dart';
import 'heart_rate_zone.dart';
import 'heart_rate_zone_schema.dart';

class RecordList<E> extends DelegatingList<E> {
  RecordList(List<E> records)
      : _records = records as List<Event>,
        super(records);

  final List<Event> _records;

  // AVERAGES:
  // Power
  double avgPower() {
    final Iterable<int?> powers = _records
        .where((Event record) =>
            record.power != null && record.power! > 0 && record.power! < 2000)
        .map((Event record) => record.power);
    return powers.isNotEmpty ? powers.mean() : -1;
  }

  double sdevPower() => _records
      .where((Event record) =>
          record.power != null && record.power! > 0 && record.power! < 2000)
      .map((Event record) => record.power)
      .sdev();

  int movingTime() {
    int movingTime = 0;
    DateTime? lastTimestamp;
    double? lastSpeed = 0;

    for (final Event record in _records) {
      if (record.event == 'record') {
        if (record.speed != null && record.timeStamp != null) {
          if (record.speed! > 0) {
            if (lastSpeed! > 0) {
              movingTime +=
                  record.timeStamp!.difference(lastTimestamp!).inSeconds;
            } else {
              movingTime += 1;
            }
          }
          lastTimestamp = record.timeStamp;
          lastSpeed = record.speed;
        }
      } else if (record.event == 'timer' && record.eventType == 'start') {
        lastTimestamp = record.timeStamp;
      }
    }

    return movingTime;
  }

  int minPower() {
    final List<int> powers =
        _records.map((Event record) => record.power).nonZeros().cast<int>();
    return powers.isNotEmpty ? powers.min : 0;
  }

  int maxPower() {
    final List<int> powers =
        _records.map((Event record) => record.power).nonZeros().cast<int>();
    return powers.isNotEmpty ? powers.max : 0;
  }

  // Heart Rate
  int avgHeartRate() {
    final Iterable<int?> heartRates = _records
        .where((Event record) =>
            record.heartRate != null &&
            record.heartRate! > 0 &&
            record.heartRate! < 2000)
        .map((Event record) => record.heartRate);

    return heartRates.isNotEmpty ? heartRates.mean().round() : -1;
  }

  double sdevHeartRate() => _records
      .where((Event record) =>
          record.heartRate != null &&
          record.heartRate! > 0 &&
          record.heartRate! < 2000)
      .map((Event record) => record.heartRate)
      .sdev();

  int minHeartRate() {
    final List<int> heartRates =
        _records.map((Event record) => record.heartRate).nonZeros().cast<int>();
    return heartRates.isNotEmpty ? heartRates.min : 0;
  }

  int maxHeartRate() {
    final List<int> heartRates =
        _records.map((Event record) => record.heartRate).nonZeros().cast<int>();
    return heartRates.isNotEmpty ? heartRates.max : 0;
  }

  // Speed
  double avgSpeedByMeasurements() {
    final List<double> speeds =
        _records.map((Event record) => record.speed).nonZeros().cast<double>();

    return speeds.isNotEmpty ? speeds.mean() : -1;
  }

  double avgSpeedBySpeed() {
    final Map<DateTime?, double?> speedMap = <DateTime?, double?>{
      for (final Event record in _records) record.timeStamp: record.speed
    };
    return speedMap.meanUsingSpeed();
  }

  double avgSpeedByDistance() {
    final Map<DateTime?, double?> speedMap = <DateTime?, double?>{
      for (final Event record in _records) record.timeStamp: record.distance,
    };
    return speedMap.meanUsingDistance();
  }

  double sdevSpeed() => _records
      .where((Event record) => record.speed != null)
      .map((Event record) => record.speed)
      .sdev();

  double sdevPace() => _records
      .where((Event record) => record.speed != null && record.speed! > 1)
      .map((Event record) => 50 / 3 / record.speed!)
      .sdev();

  double minSpeed() {
    final List<double> speeds =
        _records.map((Event record) => record.speed).nonZeros().cast<double>();
    return speeds.isNotEmpty ? speeds.min : 0;
  }

  double maxSpeed() {
    final List<double> speeds =
        _records.map((Event record) => record.speed).nonZeros().cast<double>();
    return speeds.isNotEmpty ? speeds.max : 0;
  }

  // Ground Time
  double avgGroundTime() {
    final List<double> groundTimes = _records
        .map((Event record) => record.groundTime)
        .nonZeros()
        .cast<double>();

    return groundTimes.isNotEmpty ? groundTimes.mean() : -1;
  }

  double sdevGroundTime() =>
      _records.map((Event record) => record.groundTime).nonZeros().sdev();

  double minGroundTime() {
    final List<double> groundTimes = _records
        .map((Event record) => record.groundTime)
        .nonZeros()
        .cast<double>();
    return groundTimes.isNotEmpty ? groundTimes.min : 0;
  }

  double maxGroundTime() {
    final List<double> groundTimes = _records
        .map((Event record) => record.groundTime)
        .nonZeros()
        .cast<double>();
    return groundTimes.isNotEmpty ? groundTimes.max : 0;
  }

  // Stryd Cadence
  double avgStrydCadence() {
    final List<double> strydCadences = _records
        .map((Event record) => record.strydCadence ?? 0.0)
        .nonZeros()
        .cast<double>();
    return strydCadences.isNotEmpty ? strydCadences.mean() : -1;
  }

  double sdevStrydCadence() => _records
      .map((Event record) => record.strydCadence ?? 0.0)
      .nonZeros()
      .sdev();

  double minStrydCadence() {
    final List<double> strydCadences = _records
        .map((Event record) => record.strydCadence)
        .nonZeros()
        .cast<double>();
    return strydCadences.isNotEmpty ? strydCadences.min : 0;
  }

  double maxStrydCadence() {
    final List<double> strydCadences = _records
        .map((Event record) => record.strydCadence)
        .nonZeros()
        .cast<double>();
    return strydCadences.isNotEmpty ? strydCadences.max : 0;
  }

  // Cadence
  double avgCadence() {
    final List<double> cadences = _records
        .map((Event record) => record.cadence ?? 0.0 * 2)
        .nonZeros()
        .cast<double>();
    return cadences.isNotEmpty ? cadences.mean() : -1;
  }

  double sdevCadence() => _records
      .map((Event record) => record.cadence ?? 0.0 * 2)
      .nonZeros()
      .sdev();

  double minCadence() {
    final List<double> cadences = _records
        .map((Event record) => record.cadence)
        .nonZeros()
        .cast<double>();
    return cadences.isNotEmpty ? cadences.min : 0;
  }

  double maxCadence() {
    final List<double> cadences = _records
        .map((Event record) => record.cadence)
        .nonZeros()
        .cast<double>();
    return cadences.isNotEmpty ? cadences.max : 0;
  }

  // Leg Spring Stiffness
  double avgLegSpringStiffness() {
    final List<double> legSpringStiffnesses = _records
        .map((Event record) => record.legSpringStiffness)
        .nonZeros()
        .cast<double>();
    return legSpringStiffnesses.isNotEmpty ? legSpringStiffnesses.mean() : -1;
  }

  double sdevLegSpringStiffness() => _records
      .map((Event record) => record.legSpringStiffness)
      .nonZeros()
      .sdev();

  double minLegSpringStiffness() {
    final List<double> legSpringStiffnesses = _records
        .map((Event record) => record.legSpringStiffness)
        .nonZeros()
        .cast<double>();
    return legSpringStiffnesses.isNotEmpty ? legSpringStiffnesses.min : 0;
  }

  double maxLegSpringStiffness() {
    final List<double> legSpringStiffnesses = _records
        .map((Event record) => record.legSpringStiffness)
        .nonZeros()
        .cast<double>();
    return legSpringStiffnesses.isNotEmpty ? legSpringStiffnesses.max : 0;
  }

  // Vertical Oscillation
  double avgVerticalOscillation() {
    final List<double> verticalOscillation = _records
        .map((Event record) => record.verticalOscillation)
        .nonZeros()
        .cast<double>();
    return verticalOscillation.isNotEmpty ? verticalOscillation.mean() : -1;
  }

  double sdevVerticalOscillation() => _records
      .map((Event record) => record.verticalOscillation)
      .nonZeros()
      .sdev();

  double minVerticalOscillation() {
    final List<double> verticalOscillations = _records
        .map((Event record) => record.verticalOscillation)
        .nonZeros()
        .cast<double>();
    return verticalOscillations.isNotEmpty ? verticalOscillations.min : 0;
  }

  double maxVerticalOscillation() {
    final List<double> verticalOscillations = _records
        .map((Event record) => record.verticalOscillation)
        .nonZeros()
        .cast<double>();
    return verticalOscillations.isNotEmpty ? verticalOscillations.max : 0;
  }

  // Form Power
  double avgFormPower() {
    final Iterable<int?> formPowers = _records
        .where((Event record) =>
            record.formPower != null && record.formPower! < 200)
        .map((Event record) => record.formPower);
    return formPowers.isNotEmpty ? formPowers.mean() : -1;
  }

  double sdevFormPower() => _records
      .where(
          (Event record) => record.formPower != null && record.formPower! < 200)
      .map((Event record) => record.formPower)
      .sdev();

  int minFormPower() {
    final List<int> formPowers =
        _records.map((Event record) => record.formPower).nonZeros().cast<int>();
    return formPowers.isNotEmpty ? formPowers.min : 0;
  }

  int maxFormPower() {
    final List<int> formPowers =
        _records.map((Event record) => record.formPower).nonZeros().cast<int>();
    return formPowers.isNotEmpty ? formPowers.max : 0;
  }

  // Power Ratio
  double avgPowerRatio() {
    final Iterable<double> powerRatios = _records
        .where((Event record) =>
            record.power != null &&
            record.power != 0 &&
            record.formPower != null &&
            record.formPower != 0)
        .map((Event record) =>
            (record.power! - record.formPower!) / record.power! * 100);

    return powerRatios.isNotEmpty ? powerRatios.mean() : -1;
  }

  double sdevPowerRatio() => _records
      .where((Event record) =>
          record.power != null &&
          record.power != 0 &&
          record.formPower != null &&
          record.formPower != 0)
      .map((Event record) =>
          (record.power! - record.formPower!) / record.power! * 100)
      .sdev();

  // Stride Ratio
  double avgStrideRatio() {
    final Iterable<double> strydRatios = _records
        .where((Event record) =>
            record.speed != null &&
            record.strydCadence != null &&
            record.strydCadence != 0 &&
            record.verticalOscillation != null &&
            record.verticalOscillation != 0)
        .map((Event record) =>
            10000 /
            6 *
            record.speed! /
            record.strydCadence! /
            record.verticalOscillation!);

    return strydRatios.isNotEmpty ? strydRatios.mean() : -1;
  }

  double sdevStrideRatio() => _records
      .where((Event record) =>
          record.speed != null &&
          record.strydCadence != null &&
          record.strydCadence != 0 &&
          record.verticalOscillation != null &&
          record.verticalOscillation != 0)
      .map((Event record) =>
          10000 /
          6 *
          record.speed! /
          record.strydCadence! /
          record.verticalOscillation!)
      .sdev();

  // Ascend and descend
  double totalAscent() {
    double lastAltitude = 0;
    double sumOfAscents = 0;
    final List<double> altitudes = _records
        .map((Event record) => record.altitude)
        .nonZeros()
        .cast<double>();

    for (final double altitude in altitudes) {
      if (lastAltitude != 0 && altitude > lastAltitude) {
        sumOfAscents += altitude - lastAltitude;
      }
      lastAltitude = altitude;
    }
    return sumOfAscents;
  }

  double totalDescent() {
    double lastAltitude = 0;
    double sumOfDescents = 0;
    final List<double> altitudes = _records
        .map((Event record) => record.altitude)
        .nonZeros()
        .cast<double>();

    for (final double altitude in altitudes) {
      if (lastAltitude != 0 && altitude < lastAltitude) {
        sumOfDescents += lastAltitude - altitude;
      }
      lastAltitude = altitude;
    }
    return sumOfDescents;
  }

  // END OF AVERAGES

  List<IntPlotPoint> toIntDataPoints({
    int? amount,
    required LapIntAttr attribute,
  }) {
    int index = 0;
    final List<IntPlotPoint> plotPoints = <IntPlotPoint>[];
    int sum = 0;

    for (final Event record in _records) {
      switch (attribute) {
        case LapIntAttr.power:
          sum += record.power!;
          break;
        case LapIntAttr.formPower:
          sum += record.formPower!;
          break;
        case LapIntAttr.heartRate:
          sum += record.heartRate!;
      }

      if (index++ % amount! == amount - 1) {
        plotPoints.add(IntPlotPoint(
          domain: record.distance!.round(),
          measure: (sum / amount).round(),
        ));
        sum = 0;
      }
    }
    return plotPoints;
  }

  List<DoublePlotPoint> toDoubleDataPoints({
    int? amount,
    required LapDoubleAttr attribute,
    double? weight,
  }) {
    int index = 0;
    final List<DoublePlotPoint> plotPoints = <DoublePlotPoint>[];
    double sum = 0.0;

    for (final Event record in _records) {
      switch (attribute) {
        case LapDoubleAttr.powerPerHeartRate:
          sum = sum + (record.power! / record.heartRate!);
          break;
        case LapDoubleAttr.speedPerHeartRate:
          sum = sum + 60 * (record.speed! / record.heartRate!);
          break;
        case LapDoubleAttr.groundTime:
          sum = sum + record.groundTime!;
          break;
        case LapDoubleAttr.strydCadence:
          sum = sum + 2 * record.strydCadence!;
          break;
        case LapDoubleAttr.verticalOscillation:
          sum = sum + record.verticalOscillation!;
          break;
        case LapDoubleAttr.legSpringStiffness:
          sum = sum + record.legSpringStiffness!;
          break;
        case LapDoubleAttr.powerRatio:
          sum =
              sum + ((record.power! - record.formPower!) / record.power! * 100);
          break;
        case LapDoubleAttr.strideRatio:
          sum = sum +
              (10000 /
                  6 *
                  record.speed! /
                  record.strydCadence! /
                  record.verticalOscillation!);
          break;
        case LapDoubleAttr.ecor:
          sum = sum + (record.power! / record.speed! / weight!);
          break;
        case LapDoubleAttr.pace:
          sum = sum + (50 / 3 / record.speed!);
          break;
        case LapDoubleAttr.speed:
          sum = sum + record.speed! * 3.6;
          break;
        case LapDoubleAttr.altitude:
          sum = sum + record.altitude!;
      }

      if (index++ % amount! == amount - 1) {
        plotPoints.add(DoublePlotPoint(
          domain: record.distance!.round(),
          measure: sum / amount,
        ));
        sum = 0;
      }
    }
    return plotPoints;
  }

  Future<List<BarZone>> powerZoneCounts(
      {required PowerZoneSchema powerZoneSchema}) async {
    final List<BarZone> distributions = <BarZone>[];
    double counter = 0.0;

    final List<PowerZone> powerZones = await powerZoneSchema.powerZones;

    for (final PowerZone powerZone in powerZones) {
      final int numberInZone = _records
          .where((Event event) =>
              (event.power! >= powerZone.lowerLimit!) &&
              (event.power! <= powerZone.upperLimit!))
          .length;
      distributions.add(BarZone(
        lower: counter,
        upper: counter + numberInZone,
        color: powerZone.color,
      ));
      counter = counter + numberInZone;
    }
    return distributions;
  }

  Future<List<BarZone>> heartRateZoneCounts(
      {required HeartRateZoneSchema heartRateZoneSchema}) async {
    final List<BarZone> distributions = <BarZone>[];
    double counter = 0.0;

    final List<HeartRateZone> heartRateZones =
        await heartRateZoneSchema.heartRateZones;

    for (final HeartRateZone heartRateZone in heartRateZones) {
      final int numberInZone = _records
          .where((Event event) =>
              (event.heartRate! >= heartRateZone.lowerLimit!) &&
              (event.heartRate! <= heartRateZone.upperLimit!))
          .length;
      distributions.add(BarZone(
        lower: counter,
        upper: counter + numberInZone,
        color: heartRateZone.color,
      ));
      counter = counter + numberInZone;
    }
    return distributions;
  }
}
