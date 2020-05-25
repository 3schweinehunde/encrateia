import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:collection/collection.dart';

class RecordList<E> extends DelegatingList<E> {
  final List<Event> _recordList;

  RecordList(recordList)
      : _recordList = recordList,
        super(recordList);

  String sdevHeartRate() => _recordList
      .map((record) => record.db.heartRate)
      .nonZeroInts()
      .sdev()
      .toStringAsFixed(2);

  String minHeartRate() => _recordList
      .map((record) => record.db.heartRate)
      .nonZeroInts()
      .min()
      .toString();

  String avgHeartRate() => _recordList
      .map((record) => record.db.heartRate)
      .nonZeroInts()
      .mean()
      .toStringOrDashes(1);

  String maxHeartRate() => _recordList
      .map((record) => record.db.heartRate)
      .nonZeroInts()
      .max()
      .toString();

  double calculateAveragePower() {
    var powers = _recordList
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

  double calculateSdevPower() => _recordList
      .where((record) =>
          record.db.power != null &&
          record.db.power > 0 &&
          record.db.power < 2000)
      .map((record) => record.db.power)
      .sdev();

  int calculateMinPower() {
    var powers = _recordList.map((record) => record.db.power).nonZeroInts();
    if (powers.length > 0)
      return powers.min();
    else
      return 0;
  }

  int calculateMaxPower() {
    var powers = _recordList.map((record) => record.db.power).nonZeroInts();
    if (powers.length > 0)
      return powers.max();
    else
      return 0;
  }

  int calculateAverageHeartRate() {
    var heartRates = _recordList
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

  double calculateSdevHeartRate() => _recordList
      .where((record) =>
          record.db.heartRate != null &&
          record.db.heartRate > 0 &&
          record.db.heartRate < 2000)
      .map((record) => record.db.heartRate)
      .sdev();

  int calculateMinHeartRate() {
    var heartRates =
        _recordList.map((record) => record.db.heartRate).nonZeroInts();

    if (heartRates.length > 0)
      return heartRates.min();
    else
      return 0;
  }

  int calculateMaxHeartRate() {
    var heartRates =
        _recordList.map((record) => record.db.heartRate).nonZeroInts();

    if (heartRates.length > 0)
      return heartRates.max();
    else
      return 0;
  }

  double calculateAverageSpeed() {
    var speeds = _recordList.map((record) => record.db.speed).nonZeroDoubles();

    if (speeds.length > 0) {
      return speeds.mean();
    } else
      return -1;
  }

  double calculateAverageGroundTime() {
    var groundTimes =
        _recordList.map((record) => record.db.groundTime).nonZeroDoubles();

    if (groundTimes.length > 0) {
      return groundTimes.mean();
    } else
      return -1;
  }

  double calculateSdevGroundTime() =>
      _recordList.map((record) => record.db.groundTime).nonZeroDoubles().sdev();

  double calculateAverageStrydCadence() {
    var strydCadences = _recordList
        .map((record) => record.db.strydCadence ?? 0.0 * 2)
        .nonZeroDoubles();

    if (strydCadences.length > 0) {
      return strydCadences.mean();
    } else
      return -1;
  }

  double calculateSdevStrydCadence() => _recordList
      .map((record) => record.db.strydCadence ?? 0.0 * 2)
      .nonZeroDoubles()
      .sdev();

  double calculateAverageLegSpringStiffness() {
    var legSpringStiffnesses = _recordList
        .map((record) => record.db.legSpringStiffness)
        .nonZeroDoubles();

    if (legSpringStiffnesses.length > 0) {
      return legSpringStiffnesses.mean();
    } else
      return -1;
  }

  double calculateSdevLegSpringStiffness() => _recordList
      .map((record) => record.db.legSpringStiffness)
      .nonZeroDoubles()
      .sdev();

  double calculateAverageVerticalOscillation() {
    var verticalOscillation = _recordList
        .map((record) => record.db.verticalOscillation)
        .nonZeroDoubles();

    if (verticalOscillation.length > 0) {
      return verticalOscillation.mean();
    } else
      return -1;
  }

  double calculateSdevVerticalOscillation() => _recordList
      .map((record) => record.db.verticalOscillation)
      .nonZeroDoubles()
      .sdev();

  double calculateAverageFormPower() {
    var formPowers = _recordList
        .where((record) =>
            record.db.formPower != null && record.db.formPower < 200)
        .map((record) => record.db.formPower);

    if (formPowers.length > 0) {
      return formPowers.mean();
    } else
      return -1;
  }

  double calculateSdevFormPower() => _recordList
      .where(
          (record) => record.db.formPower != null && record.db.formPower < 200)
      .map((record) => record.db.formPower)
      .sdev();

  double calculateAveragePowerRatio() {
    var powerRatios = _recordList
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

  double calculateSdevPowerRatio() => _recordList
      .where((record) =>
          record.db.power != null &&
          record.db.power != 0 &&
          record.db.formPower != null &&
          record.db.formPower != 0)
      .map((record) =>
          (record.db.power - record.db.formPower) / record.db.power * 100)
      .sdev();

  double calculateAverageStrideRatio() {
    var powerRatios = _recordList
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

  double calculateSdevStrideRatio() => _recordList
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
}
