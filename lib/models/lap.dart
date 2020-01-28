import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/models/event.dart';
import 'activity.dart';

class Lap {
  DbLap db;
  Activity activity;
  int index;
  List<Event> _records;

  Lap({DataMessage dataMessage, this.activity, int eventId}) {
    db = DbLap()
      ..activitiesId = activity.db.id
      ..eventsId = eventId
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
      ..avgSpeed = dataMessage.get('avg_speed')
      ..maxSpeed = dataMessage.get('max_speed')
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
      ..totalFractionalCycles = dataMessage.get('total_fractional_cycles')
      ..save();
  }
  Lap.fromDb(this.db);

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

  Future<double> get avgLegSpringStiffness async {
    if (db.avgLegSpringStiffness == null) {
      List<Event> records = await this.records;
      db.avgLegSpringStiffness = calculateAverageLegSpringStiffness(records: records);
      await db.save();
    }
    return db.avgLegSpringStiffness;
  }

  Future<double> get sdevLegSpringStiffness async {
    if (db.sdevLegSpringStiffness == null) {
      List<Event> records = await this.records;
      db.sdevLegSpringStiffness = calculateSdevLegSpringStiffness(records: records);
      await db.save();
    }
    return db.sdevLegSpringStiffness;
  }

  Future<int> firstEventId() async {
    if (index > 1) {
      var lapList = await activity.laps;
      DbEvent firstEvent = await lapList
          .firstWhere((lap) => lap.index == index - 1)
          .db
          .getDbEvent();
      return firstEvent.id;
    } else {
      return 0;
    }
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

  static double calculateAveragePower({List<Event> records}) {
    var powers = records.map((record) => record.db.power).nonZeroInts();
    if (powers.length > 0) {
      return powers.mean();
    } else
      return -1;
  }

  static double calculateSdevPower({List<Event> records}) {
    var powers = records.map((record) => record.db.power).nonZeroInts();
    return powers.sdev();
  }

  static int calculateMinPower({List<Event> records}) {
    var powers = records.map((record) => record.db.power).nonZeroInts();
    return powers.min();
  }

  static int calculateMaxPower({List<Event> records}) {
    var powers = records.map((record) => record.db.power).nonZeroInts();
    return powers.max();
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

  static double calculateAverageFormPower({List<Event> records}) {
    var legSpringStiffnesses =
    records.map((record) => record.db.formPower).nonZeroInts();
    if (legSpringStiffnesses.length > 0) {
      return legSpringStiffnesses.mean();
    } else
      return -1;
  }

  static double calculateSdevFormPower({List<Event> records}) {
    var legSpringStiffnesses =
    records.map((record) => record.db.formPower).nonZeroInts();
    return legSpringStiffnesses.sdev();
  }
}
