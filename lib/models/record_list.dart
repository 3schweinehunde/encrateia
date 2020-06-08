import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/utils/enums.dart';
import 'bar_zone.dart';
import 'heart_rate_zone.dart';
import 'heart_rate_zone_schema.dart';

class RecordList<E> extends DelegatingList<E> {
  RecordList(List<E> records)
      : _records = records as List<Event>,
        super(records);

  final List<Event> _records;

  String get sdevHeartRateString => _records
      .map((Event record) => record.db.heartRate)
      .nonZeroInts()
      .sdev()
      .toStringAsFixed(2);

  String get minHeartRateString => _records
      .map((Event record) => record.db.heartRate)
      .nonZeroInts()
      .min()
      .toString();

  String get avgHeartRateString => _records
      .map((Event record) => record.db.heartRate)
      .nonZeroInts()
      .mean()
      .toStringOrDashes(1);

  String get maxHeartRateString => _records
      .map((Event record) => record.db.heartRate)
      .nonZeroInts()
      .max()
      .toString();

  double calculateAveragePower() {
    final Iterable<int> powers = _records
        .where((Event record) =>
            record.db.power != null &&
            record.db.power > 0 &&
            record.db.power < 2000)
        .map((Event record) => record.db.power);

    if (powers.isNotEmpty) {
      return powers.mean();
    } else
      return -1;
  }

  double calculateSdevPower() => _records
      .where((Event record) =>
          record.db.power != null &&
          record.db.power > 0 &&
          record.db.power < 2000)
      .map((Event record) => record.db.power)
      .sdev();

  int calculateMinPower() {
    final List<int> powers =
        _records.map((Event record) => record.db.power).nonZeroInts();
    if (powers.isNotEmpty)
      return powers.min();
    else
      return 0;
  }

  int calculateMaxPower() {
    final List<int> powers =
        _records.map((Event record) => record.db.power).nonZeroInts();
    if (powers.isNotEmpty)
      return powers.max();
    else
      return 0;
  }

  int calculateAverageHeartRate() {
    final Iterable<int> heartRates = _records
        .where((Event record) =>
            record.db.heartRate != null &&
            record.db.heartRate > 0 &&
            record.db.heartRate < 2000)
        .map((Event record) => record.db.heartRate);

    if (heartRates.isNotEmpty) {
      return heartRates.mean().round();
    } else
      return -1;
  }

  double calculateSdevHeartRate() => _records
      .where((Event record) =>
          record.db.heartRate != null &&
          record.db.heartRate > 0 &&
          record.db.heartRate < 2000)
      .map((Event record) => record.db.heartRate)
      .sdev();

  int calculateMinHeartRate() {
    final List<int> heartRates =
        _records.map((Event record) => record.db.heartRate).nonZeroInts();

    if (heartRates.isNotEmpty)
      return heartRates.min();
    else
      return 0;
  }

  int calculateMaxHeartRate() {
    final List<int> heartRates =
        _records.map((Event record) => record.db.heartRate).nonZeroInts();

    if (heartRates.isNotEmpty)
      return heartRates.max();
    else
      return 0;
  }

  double calculateAverageSpeed() {
    final List<double> speeds =
        _records.map((Event record) => record.db.speed).nonZeroDoubles();

    if (speeds.isNotEmpty) {
      return speeds.mean();
    } else
      return -1;
  }

  double calculateAverageGroundTime() {
    final List<double> groundTimes =
        _records.map((Event record) => record.db.groundTime).nonZeroDoubles();

    if (groundTimes.isNotEmpty) {
      return groundTimes.mean();
    } else
      return -1;
  }

  double calculateSdevGroundTime() => _records
      .map((Event record) => record.db.groundTime)
      .nonZeroDoubles()
      .sdev();

  double calculateAverageStrydCadence() {
    final List<double> strydCadences = _records
        .map((Event record) => record.db.strydCadence ?? 0.0 * 2)
        .nonZeroDoubles();

    if (strydCadences.isNotEmpty) {
      return strydCadences.mean();
    } else
      return -1;
  }

  double calculateSdevStrydCadence() => _records
      .map((Event record) => record.db.strydCadence ?? 0.0 * 2)
      .nonZeroDoubles()
      .sdev();

  double calculateAverageLegSpringStiffness() {
    final List<double> legSpringStiffnesses = _records
        .map((Event record) => record.db.legSpringStiffness)
        .nonZeroDoubles();

    if (legSpringStiffnesses.isNotEmpty) {
      return legSpringStiffnesses.mean();
    } else
      return -1;
  }

  double calculateSdevLegSpringStiffness() => _records
      .map((Event record) => record.db.legSpringStiffness)
      .nonZeroDoubles()
      .sdev();

  double calculateAverageVerticalOscillation() {
    final List<double> verticalOscillation = _records
        .map((Event record) => record.db.verticalOscillation)
        .nonZeroDoubles();

    if (verticalOscillation.isNotEmpty) {
      return verticalOscillation.mean();
    } else
      return -1;
  }

  double calculateSdevVerticalOscillation() => _records
      .map((Event record) => record.db.verticalOscillation)
      .nonZeroDoubles()
      .sdev();

  double calculateAverageFormPower() {
    final Iterable<int> formPowers = _records
        .where((Event record) =>
            record.db.formPower != null && record.db.formPower < 200)
        .map((Event record) => record.db.formPower);

    if (formPowers.isNotEmpty) {
      return formPowers.mean();
    } else
      return -1;
  }

  double calculateSdevFormPower() => _records
      .where((Event record) =>
          record.db.formPower != null && record.db.formPower < 200)
      .map((Event record) => record.db.formPower)
      .sdev();

  double calculateAveragePowerRatio() {
    final Iterable<double> powerRatios = _records
        .where((Event record) =>
            record.db.power != null &&
            record.db.power != 0 &&
            record.db.formPower != null &&
            record.db.formPower != 0)
        .map((Event record) =>
            (record.db.power - record.db.formPower) / record.db.power * 100);

    if (powerRatios.isNotEmpty) {
      return powerRatios.mean();
    } else
      return -1;
  }

  double calculateSdevPowerRatio() => _records
      .where((Event record) =>
          record.db.power != null &&
          record.db.power != 0 &&
          record.db.formPower != null &&
          record.db.formPower != 0)
      .map((Event record) =>
          (record.db.power - record.db.formPower) / record.db.power * 100)
      .sdev();

  double calculateAverageStrideRatio() {
    final Iterable<double> powerRatios = _records
        .where((Event record) =>
            record.db.speed != null &&
            record.db.strydCadence != null &&
            record.db.strydCadence != 0 &&
            record.db.verticalOscillation != null &&
            record.db.verticalOscillation != 0)
        .map((Event record) =>
            10000 /
            6 *
            record.db.speed /
            record.db.strydCadence /
            record.db.verticalOscillation);

    if (powerRatios.isNotEmpty) {
      return powerRatios.mean();
    } else
      return -1;
  }

  double calculateSdevStrideRatio() => _records
      .where((Event record) =>
          record.db.speed != null &&
          record.db.strydCadence != null &&
          record.db.strydCadence != 0 &&
          record.db.verticalOscillation != null &&
          record.db.verticalOscillation != 0)
      .map((Event record) =>
          10000 /
          6 *
          record.db.speed /
          record.db.strydCadence /
          record.db.verticalOscillation)
      .sdev();

  List<IntPlotPoint> toIntDataPoints({
    int amount,
    @required LapIntAttr attribute,
  }) {
    int index = 0;
    final List<IntPlotPoint> plotPoints = <IntPlotPoint>[];
    int sum = 0;

    for (final Event record in _records) {
      switch (attribute) {
        case LapIntAttr.power:
          sum = sum + record.db.power;
          break;
        case LapIntAttr.formPower:
          sum = sum + record.db.formPower;
          break;
        case LapIntAttr.heartRate:
          sum = sum + record.db.heartRate;
      }

      if (index++ % amount == amount - 1) {
        plotPoints.add(IntPlotPoint(
          domain: record.db.distance.round(),
          measure: (sum / amount).round(),
        ));
        sum = 0;
      }
    }

    return plotPoints;
  }

  List<DoublePlotPoint> toDoubleDataPoints({
    int amount,
    @required LapDoubleAttr attribute,
    double weight,
  }) {
    int index = 0;
    final List<DoublePlotPoint> plotPoints = <DoublePlotPoint>[];
    double sum = 0.0;

    for (final Event record in _records) {
      switch (attribute) {
        case LapDoubleAttr.powerPerHeartRate:
          sum = sum + (record.db.power / record.db.heartRate);
          break;
        case LapDoubleAttr.speedPerHeartRate:
          sum = sum + 100 * (record.db.speed / record.db.heartRate);
          break;
        case LapDoubleAttr.groundTime:
          sum = sum + record.db.groundTime;
          break;
        case LapDoubleAttr.strydCadence:
          sum = sum + 2 * record.db.strydCadence;
          break;
        case LapDoubleAttr.verticalOscillation:
          sum = sum + record.db.verticalOscillation;
          break;
        case LapDoubleAttr.legSpringStiffness:
          sum = sum + record.db.legSpringStiffness;
          break;
        case LapDoubleAttr.powerRatio:
          sum = sum +
              ((record.db.power - record.db.formPower) / record.db.power * 100);
          break;
        case LapDoubleAttr.strideRatio:
          sum = sum +
              (10000 /
                  6 *
                  record.db.speed /
                  record.db.strydCadence /
                  record.db.verticalOscillation);
          break;
        case LapDoubleAttr.ecor:
          sum = sum + (record.db.power / record.db.speed / weight);
      }

      if (index++ % amount == amount - 1) {
        plotPoints.add(DoublePlotPoint(
          domain: record.db.distance.round(),
          measure: sum / amount,
        ));
        sum = 0;
      }
    }

    return plotPoints;
  }

  Future<List<BarZone>> powerZoneCounts(
      {PowerZoneSchema powerZoneSchema}) async {
    final List<BarZone> distributions = <BarZone>[];
    double counter = 0.0;

    final List<PowerZone> powerZones = await powerZoneSchema.powerZones;

    for (final PowerZone powerZone in powerZones.reversed) {
      final int numberInZone = _records
          .where((Event event) =>
              (event.db.power >= powerZone.lowerLimit) &&
              (event.db.power <= powerZone.upperLimit))
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
      {HeartRateZoneSchema heartRateZoneSchema}) async {
    final List<BarZone> distributions = <BarZone>[];
    double counter = 0.0;

    final List<HeartRateZone> heartRateZones =
        await heartRateZoneSchema.heartRateZones;

    for (final HeartRateZone heartRateZone in heartRateZones.reversed) {
      final int numberInZone = _records
          .where((Event event) =>
              (event.db.heartRate >= heartRateZone.lowerLimit) &&
              (event.db.heartRate <= heartRateZone.upperLimit))
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
