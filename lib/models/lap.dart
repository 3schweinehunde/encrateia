import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/num_utils.dart';

class Lap {
  DbLap db;
  Activity activity;
  int index;
  List<Event> _records;

  Lap() {
    db = DbLap();
  }

  Lap.fromDb(this.db);

  static Lap fromLap({
    DataMessage dataMessage,
    Activity activity,
    Lap lap,
  }) {
    lap.db
      ..activitiesId = activity.db.id
      ..avgSpeed = dataMessage.get('avg_speed')
      ..maxSpeed = dataMessage.get('max_speed')
      ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
      ..startTime = dateTimeFromStrava(dataMessage.get('start_time'))
      ..startPositionLat = dataMessage.get('start_position_lat')
      ..startPositionLong = dataMessage.get('start_position_long')
      ..endPositionLat = dataMessage.get('end_position_lat')
      ..endPositionLong = dataMessage.get('end_position_long')
      ..startPositionLat = dataMessage.get('end_position_lat')
      ..avgHeartRate = dataMessage.get('avg_heart_rate')?.round()
      ..maxHeartRate = dataMessage.get('max_heart_rate')?.round()
      ..avgRunningCadence = dataMessage.get('avg_running_cadence')
      ..event = dataMessage.get('event')
      ..eventType = dataMessage.get('event_type')
      ..eventGroup = dataMessage.get('event_group')?.round()
      ..sport = dataMessage.get('sport')
      ..subSport = dataMessage.get('sub_sport')
      ..avgVerticalOscillation = dataMessage.get('avg_vertical_oscillation')
      ..totalElapsedTime = dataMessage.get('total_elapsed_time')?.round()
      ..totalTimerTime = dataMessage.get('total_timer_time')?.round()
      ..totalDistance = dataMessage.get('total_distance')?.round()
      ..totalStrides = dataMessage.get('total_strides')?.round()
      ..totalCalories = dataMessage.get('total_calories')?.round()
      ..totalAscent = dataMessage.get('total_ascent')?.round()
      ..totalDescent = dataMessage.get('total_descent')?.round()
      ..avgStanceTimePercent = dataMessage.get('avg_stance_time_percent')
      ..avgStanceTime = dataMessage.get('avg_stance_time')
      ..maxRunningCadence = dataMessage.get('max_running_cadence')?.round()
      ..intensity = dataMessage.get('intensity')?.round()
      ..lapTrigger = dataMessage.get('lap_trigger')
      ..avgTemperature = dataMessage.get('avg_temperature')?.round()
      ..maxTemperature = dataMessage.get('max_temperature')?.round()
      ..avgFractionalCadence = dataMessage.get('avg_fractional_cadence')
      ..maxFractionalCadence = dataMessage.get('max_fractional_cadence')
      ..totalFractionalCycles = dataMessage.get('total_fractional_cycles');
    return lap;
  }

  Future<List<Event>> get records async {
    if (_records == null) {
      _records = await Event.recordsByLap(lap: this);
    }
    return _records;
  }

  Future<double> get avgPower async {
    if (db.avgPower == null) {
      List<Event> records = await this.records;
      db.avgPower = calculateAveragePower(records: records);
      await db.save();
    }
    return db.avgPower;
  }

  Future<double> get sdevPower async {
    if (db.sdevPower == null) {
      List<Event> records = await this.records;
      db.sdevPower = calculateSdevPower(records: records);
      await db.save();
    }
    return db.sdevPower;
  }

  Future<int> get minPower async {
    if (db.minPower == null) {
      List<Event> records = await this.records;
      db.minPower = calculateMinPower(records: records);
      await db.save();
    }
    return db.minPower;
  }

  Future<int> get maxPower async {
    if (db.maxPower == null) {
      List<Event> records = await this.records;
      db.maxPower = calculateMaxPower(records: records);
      await db.save();
    }
    return db.maxPower;
  }

  Future<double> get avgGroundTime async {
    if (db.avgGroundTime == null) {
      List<Event> records = await this.records;
      db.avgGroundTime = calculateAverageGroundTime(records: records);
      await db.save();
    }
    return db.avgGroundTime;
  }

  Future<double> get sdevGroundTime async {
    if (db.sdevGroundTime == null) {
      List<Event> records = await this.records;
      db.sdevGroundTime = calculateSdevGroundTime(records: records);
      await db.save();
    }
    return db.sdevGroundTime;
  }

  Future<double> get avgVerticalOscillation async {
    if (db.avgVerticalOscillation == null ||
        db.avgVerticalOscillation == 6553.5) {
      List<Event> records = await this.records;
      db.avgVerticalOscillation =
          calculateAverageVerticalOscillation(records: records);
      await db.save();
    }
    return db.avgVerticalOscillation;
  }

  Future<double> get sdevVerticalOscillation async {
    if (db.sdevVerticalOscillation == null) {
      List<Event> records = await this.records;
      db.sdevVerticalOscillation =
          calculateSdevVerticalOscillation(records: records);
      await db.save();
    }
    return db.sdevVerticalOscillation;
  }

  Future<double> get avgStrydCadence async {
    if (db.avgStrydCadence == null) {
      List<Event> records = await this.records;
      db.avgStrydCadence = calculateAverageStrydCadence(records: records);
      await db.save();
    }
    return db.avgStrydCadence;
  }

  Future<double> get sdevStrydCadence async {
    if (db.sdevStrydCadence == null) {
      List<Event> records = await this.records;
      db.sdevStrydCadence = calculateSdevStrydCadence(records: records);
      await db.save();
    }
    return db.sdevStrydCadence;
  }

  Future<double> get avgLegSpringStiffness async {
    if (db.avgLegSpringStiffness == null) {
      List<Event> records = await this.records;
      db.avgLegSpringStiffness =
          calculateAverageLegSpringStiffness(records: records);
      await db.save();
    }
    return db.avgLegSpringStiffness;
  }

  Future<double> get sdevLegSpringStiffness async {
    if (db.sdevLegSpringStiffness == null) {
      List<Event> records = await this.records;
      db.sdevLegSpringStiffness =
          calculateSdevLegSpringStiffness(records: records);
      await db.save();
    }
    return db.sdevLegSpringStiffness;
  }

  Future<double> get avgFormPower async {
    if (db.avgFormPower == null) {
      List<Event> records = await this.records;
      db.avgFormPower = calculateAverageFormPower(records: records);
      await db.save();
    }
    return db.avgFormPower;
  }

  Future<double> get sdevFormPower async {
    if (db.sdevFormPower == null) {
      List<Event> records = await this.records;
      db.sdevFormPower = calculateSdevFormPower(records: records);
      await db.save();
    }
    return db.sdevFormPower;
  }

  static Future<List<Lap>> by({Activity activity}) async {
    int counter = 1;

    List<DbLap> dbLapList = await activity.db.getDbLaps().toList();
    var lapList = dbLapList.map((dbLap) => Lap.fromDb(dbLap)).toList();

    for (Lap lap in lapList) {
      lap
        ..activity = activity
        ..index = counter;
      counter = counter + 1;
    }
    return lapList;
  }

  static String sdevHeartRate({List<Event> records}) {
    var heartRates = records.map((record) => record.db.heartRate).nonZeroInts();
    return heartRates.sdev().toStringAsFixed(2);
  }

  static String minHeartRate({List<Event> records}) {
    var heartRates = records.map((record) => record.db.heartRate).nonZeroInts();
    return heartRates.min().toString();
  }

  static String avgHeartRate({List<Event> records}) {
    var heartRates = records.map((record) => record.db.heartRate).nonZeroInts();
    return heartRates.mean().toStringOrDashes(1);
  }

  static String maxHeartRate({List<Event> records}) {
    var heartRates = records.map((record) => record.db.heartRate).nonZeroInts();
    return heartRates.max().toString();
  }

  static double calculateAveragePower({List<Event> records}) {
    var powers = records
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

  static double calculateSdevPower({List<Event> records}) {
    var powers = records
        .where((record) =>
            record.db.power != null &&
            record.db.power > 0 &&
            record.db.power < 2000)
        .map((record) => record.db.power);
    return powers.sdev();
  }

  static int calculateMinPower({List<Event> records}) {
    var powers = records.map((record) => record.db.power).nonZeroInts();
    if (powers.length > 0)
      return powers.min();
    else
      return 0;
  }

  static int calculateMaxPower({List<Event> records}) {
    var powers = records.map((record) => record.db.power).nonZeroInts();
    if (powers.length > 0)
      return powers.max();
    else
      return 0;
  }

  static double calculateAverageSpeed({List<Event> records}) {
    var speeds = records.map((record) => record.db.speed).nonZeroDoubles();
    if (speeds.length > 0) {
      return speeds.mean();
    } else
      return -1;
  }

  static double calculateAverageGroundTime({List<Event> records}) {
    var groundTimes =
        records.map((record) => record.db.groundTime).nonZeroDoubles();
    if (groundTimes.length > 0) {
      return groundTimes.mean();
    } else
      return -1;
  }

  static double calculateSdevGroundTime({List<Event> records}) {
    var groundTimes =
        records.map((record) => record.db.groundTime).nonZeroDoubles();
    return groundTimes.sdev();
  }

  static double calculateAverageStrydCadence({List<Event> records}) {
    var strydCadences = records
        .map((record) => record.db.strydCadence ?? 0.0 * 2)
        .nonZeroDoubles();
    if (strydCadences.length > 0) {
      return strydCadences.mean();
    } else
      return -1;
  }

  static double calculateSdevStrydCadence({List<Event> records}) {
    var strydCadences = records
        .map((record) => record.db.strydCadence ?? 0.0 * 2)
        .nonZeroDoubles();
    return strydCadences.sdev();
  }

  static double calculateAverageLegSpringStiffness({List<Event> records}) {
    var legSpringStiffnesses =
        records.map((record) => record.db.legSpringStiffness).nonZeroDoubles();
    if (legSpringStiffnesses.length > 0) {
      return legSpringStiffnesses.mean();
    } else
      return -1;
  }

  static double calculateSdevLegSpringStiffness({List<Event> records}) {
    var legSpringStiffnesses =
        records.map((record) => record.db.legSpringStiffness).nonZeroDoubles();
    return legSpringStiffnesses.sdev();
  }

  static double calculateAverageVerticalOscillation({List<Event> records}) {
    var verticalOscillation =
        records.map((record) => record.db.verticalOscillation).nonZeroDoubles();
    if (verticalOscillation.length > 0) {
      return verticalOscillation.mean();
    } else
      return -1;
  }

  static double calculateSdevVerticalOscillation({List<Event> records}) {
    var verticalOscillation =
        records.map((record) => record.db.verticalOscillation).nonZeroDoubles();
    return verticalOscillation.sdev();
  }

  static double calculateAverageFormPower({List<Event> records}) {
    var formPowers = records
        .where((record) =>
            record.db.formPower != null && record.db.formPower < 200)
        .map((record) => record.db.formPower);

    if (formPowers.length > 0) {
      return formPowers.mean();
    } else
      return -1;
  }

  static double calculateSdevFormPower({List<Event> records}) {
    var formPowers = records
        .where((record) =>
            record.db.formPower != null && record.db.formPower < 200)
        .map((record) => record.db.formPower);
    return formPowers.sdev();
  }

  static double calculateAveragePowerRatio({List<Event> records}) {
    var powerRatios = records
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

  static double calculateSdevPowerRatio({List<Event> records}) {
    var powerRatios = records
        .where((record) =>
            record.db.power != null &&
            record.db.power != 0 &&
            record.db.formPower != null &&
            record.db.formPower != 0)
        .map((record) =>
            (record.db.power - record.db.formPower) / record.db.power * 100);
    return powerRatios.sdev();
  }

  static double calculateAverageStrideRatio({List<Event> records}) {
    var powerRatios = records
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

  static double calculateSdevStrideRatio({List<Event> records}) {
    var powerRatios = records
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
    return powerRatios.sdev();
  }

  getPowerZoneSchema() async {
    var dbActivity = await DbActivity().getById(db.activitiesId);

    var powerZoneSchema = await PowerZoneSchema.getBy(
      athletesId: dbActivity.athletesId,
      date: dbActivity.timeCreated,
    );
    return powerZoneSchema;
  }
}
