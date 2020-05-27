import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/utils/enums.dart';

class RecordList<E> extends DelegatingList<E> {
  final List<Event> _records;

  RecordList(records)
      : _records = records,
        super(records);

  get sdevHeartRateString => _records
      .map((record) => record.db.heartRate)
      .nonZeroInts()
      .sdev()
      .toStringAsFixed(2);

  get minHeartRateString => _records
      .map((record) => record.db.heartRate)
      .nonZeroInts()
      .min()
      .toString();

  get avgHeartRateString => _records
      .map((record) => record.db.heartRate)
      .nonZeroInts()
      .mean()
      .toStringOrDashes(1);

  get maxHeartRateString => _records
      .map((record) => record.db.heartRate)
      .nonZeroInts()
      .max()
      .toString();

  calculateAveragePower() {
    var powers = _records
        .where((record) =>
            record.db.power != null &&
            record.db.power > 0 &&
            record.db.power < 2000)
        .map((record) => record.db.power);

    if (powers.length > 0) {
      return powers.mean();
    } else
      return -1;
  }

  calculateSdevPower() => _records
      .where((record) =>
          record.db.power != null &&
          record.db.power > 0 &&
          record.db.power < 2000)
      .map((record) => record.db.power)
      .sdev();

  calculateMinPower() {
    var powers = _records.map((record) => record.db.power).nonZeroInts();
    if (powers.length > 0)
      return powers.min();
    else
      return 0;
  }

  calculateMaxPower() {
    var powers = _records.map((record) => record.db.power).nonZeroInts();
    if (powers.length > 0)
      return powers.max();
    else
      return 0;
  }

  calculateAverageHeartRate() {
    var heartRates = _records
        .where((record) =>
            record.db.heartRate != null &&
            record.db.heartRate > 0 &&
            record.db.heartRate < 2000)
        .map((record) => record.db.heartRate);

    if (heartRates.length > 0) {
      return heartRates.mean().round();
    } else
      return -1;
  }

  calculateSdevHeartRate() => _records
      .where((record) =>
          record.db.heartRate != null &&
          record.db.heartRate > 0 &&
          record.db.heartRate < 2000)
      .map((record) => record.db.heartRate)
      .sdev();

  calculateMinHeartRate() {
    var heartRates =
        _records.map((record) => record.db.heartRate).nonZeroInts();

    if (heartRates.length > 0)
      return heartRates.min();
    else
      return 0;
  }

  calculateMaxHeartRate() {
    var heartRates =
        _records.map((record) => record.db.heartRate).nonZeroInts();

    if (heartRates.length > 0)
      return heartRates.max();
    else
      return 0;
  }

  calculateAverageSpeed() {
    var speeds = _records.map((record) => record.db.speed).nonZeroDoubles();

    if (speeds.length > 0) {
      return speeds.mean();
    } else
      return -1;
  }

  calculateAverageGroundTime() {
    var groundTimes =
        _records.map((record) => record.db.groundTime).nonZeroDoubles();

    if (groundTimes.length > 0) {
      return groundTimes.mean();
    } else
      return -1;
  }

  calculateSdevGroundTime() =>
      _records.map((record) => record.db.groundTime).nonZeroDoubles().sdev();

  calculateAverageStrydCadence() {
    var strydCadences = _records
        .map((record) => record.db.strydCadence ?? 0.0 * 2)
        .nonZeroDoubles();

    if (strydCadences.length > 0) {
      return strydCadences.mean();
    } else
      return -1;
  }

  calculateSdevStrydCadence() => _records
      .map((record) => record.db.strydCadence ?? 0.0 * 2)
      .nonZeroDoubles()
      .sdev();

  calculateAverageLegSpringStiffness() {
    var legSpringStiffnesses =
        _records.map((record) => record.db.legSpringStiffness).nonZeroDoubles();

    if (legSpringStiffnesses.length > 0) {
      return legSpringStiffnesses.mean();
    } else
      return -1;
  }

  calculateSdevLegSpringStiffness() => _records
      .map((record) => record.db.legSpringStiffness)
      .nonZeroDoubles()
      .sdev();

  calculateAverageVerticalOscillation() {
    var verticalOscillation = _records
        .map((record) => record.db.verticalOscillation)
        .nonZeroDoubles();

    if (verticalOscillation.length > 0) {
      return verticalOscillation.mean();
    } else
      return -1;
  }

  calculateSdevVerticalOscillation() => _records
      .map((record) => record.db.verticalOscillation)
      .nonZeroDoubles()
      .sdev();

  calculateAverageFormPower() {
    var formPowers = _records
        .where((record) =>
            record.db.formPower != null && record.db.formPower < 200)
        .map((record) => record.db.formPower);

    if (formPowers.length > 0) {
      return formPowers.mean();
    } else
      return -1;
  }

  calculateSdevFormPower() => _records
      .where(
          (record) => record.db.formPower != null && record.db.formPower < 200)
      .map((record) => record.db.formPower)
      .sdev();

  calculateAveragePowerRatio() {
    var powerRatios = _records
        .where((record) =>
            record.db.power != null &&
            record.db.power != 0 &&
            record.db.formPower != null &&
            record.db.formPower != 0)
        .map((record) =>
            (record.db.power - record.db.formPower) / record.db.power * 100);

    if (powerRatios.length > 0) {
      return powerRatios.mean();
    } else
      return -1;
  }

  calculateSdevPowerRatio() => _records
      .where((record) =>
          record.db.power != null &&
          record.db.power != 0 &&
          record.db.formPower != null &&
          record.db.formPower != 0)
      .map((record) =>
          (record.db.power - record.db.formPower) / record.db.power * 100)
      .sdev();

  calculateAverageStrideRatio() {
    var powerRatios = _records
        .where((record) =>
            record.db.speed != null &&
            record.db.strydCadence != null &&
            record.db.strydCadence != 0 &&
            record.db.verticalOscillation != null &&
            record.db.verticalOscillation != 0)
        .map((record) =>
            10000 /
            6 *
            record.db.speed /
            record.db.strydCadence /
            record.db.verticalOscillation);

    if (powerRatios.length > 0) {
      return powerRatios.mean();
    } else
      return -1;
  }

  calculateSdevStrideRatio() => _records
      .where((record) =>
          record.db.speed != null &&
          record.db.strydCadence != null &&
          record.db.strydCadence != 0 &&
          record.db.verticalOscillation != null &&
          record.db.verticalOscillation != 0)
      .map((record) =>
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
    List<IntPlotPoint> plotPoints = [];
    int sum = 0;

    for (var record in _records) {
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
    List<DoublePlotPoint> plotPoints = [];
    double sum = 0.0;

    for (var record in _records) {
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
}
