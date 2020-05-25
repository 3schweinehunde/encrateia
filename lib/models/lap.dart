import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/lap_tagging.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/activity.dart';
import 'athlete.dart';
import 'heart_rate_zone_schema.dart';

class Lap {
  DbLap db;
  Activity activity;
  int index;
  List<Event> _records;
  PowerZoneSchema _powerZoneSchema;
  PowerZone _powerZone;
  HeartRateZone _heartRateZone;
  HeartRateZoneSchema _heartRateZoneSchema;

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
      db.avgPower = RecordList(await this.records).calculateAveragePower();
      await db.save();
    }
    return db.avgPower;
  }

  Future<double> get sdevPower async {
    if (db.sdevPower == null) {
      db.sdevPower = RecordList(await this.records).calculateSdevPower();
      await db.save();
    }
    return db.sdevPower;
  }

  Future<int> get minPower async {
    if (db.minPower == null) {
      db.minPower = RecordList(await this.records).calculateMinPower();
      await db.save();
    }
    return db.minPower;
  }

  Future<int> get maxPower async {
    if (db.maxPower == null) {
      db.maxPower = RecordList(await this.records).calculateMaxPower();
      await db.save();
    }
    return db.maxPower;
  }

  Future<double> get avgGroundTime async {
    if (db.avgGroundTime == null) {
      db.avgGroundTime =
          RecordList(await this.records).calculateAverageGroundTime();
      await db.save();
    }
    return db.avgGroundTime;
  }

  Future<double> get sdevGroundTime async {
    if (db.sdevGroundTime == null) {
      db.sdevGroundTime =
          RecordList(await this.records).calculateSdevGroundTime();
      await db.save();
    }
    return db.sdevGroundTime;
  }

  Future<double> get avgVerticalOscillation async {
    if (db.avgVerticalOscillation == null ||
        db.avgVerticalOscillation == 6553.5) {
      db.avgVerticalOscillation =
          RecordList(await this.records).calculateAverageVerticalOscillation();
      await db.save();
    }
    return db.avgVerticalOscillation;
  }

  Future<double> get sdevVerticalOscillation async {
    if (db.sdevVerticalOscillation == null) {
      db.sdevVerticalOscillation =
          RecordList(await this.records).calculateSdevVerticalOscillation();
      await db.save();
    }
    return db.sdevVerticalOscillation;
  }

  Future<double> get avgStrydCadence async {
    if (db.avgStrydCadence == null) {
      db.avgStrydCadence =
          RecordList(await this.records).calculateAverageStrydCadence();
      await db.save();
    }
    return db.avgStrydCadence;
  }

  Future<double> get sdevStrydCadence async {
    if (db.sdevStrydCadence == null) {
      db.sdevStrydCadence =
          RecordList(await this.records).calculateSdevStrydCadence();
      await db.save();
    }
    return db.sdevStrydCadence;
  }

  Future<double> get avgLegSpringStiffness async {
    if (db.avgLegSpringStiffness == null) {
      db.avgLegSpringStiffness =
          RecordList(await this.records).calculateAverageLegSpringStiffness();
      await db.save();
    }
    return db.avgLegSpringStiffness;
  }

  Future<double> get sdevLegSpringStiffness async {
    if (db.sdevLegSpringStiffness == null) {
      db.sdevLegSpringStiffness =
          RecordList(await this.records).calculateSdevLegSpringStiffness();
      await db.save();
    }
    return db.sdevLegSpringStiffness;
  }

  Future<double> get avgFormPower async {
    if (db.avgFormPower == null) {
      db.avgFormPower =
          RecordList(await this.records).calculateAverageFormPower();
      await db.save();
    }
    return db.avgFormPower;
  }

  Future<double> get sdevFormPower async {
    if (db.sdevFormPower == null) {
      db.sdevFormPower =
          RecordList(await this.records).calculateSdevFormPower();
      await db.save();
    }
    return db.sdevFormPower;
  }

  static Future<List<Lap>> all({Activity activity}) async {
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

  getPowerZoneSchema() async {
    if (_powerZoneSchema == null) {
      var dbActivity = await DbActivity().getById(db.activitiesId);

      _powerZoneSchema = await PowerZoneSchema.getBy(
        athletesId: dbActivity.athletesId,
        date: dbActivity.timeCreated,
      );
    }
    return _powerZoneSchema;
  }

  getHeartRateZoneSchema() async {
    if (_heartRateZoneSchema == null) {
      var dbActivity = await DbActivity().getById(db.activitiesId);

      _heartRateZoneSchema = await HeartRateZoneSchema.getBy(
        athletesId: dbActivity.athletesId,
        date: dbActivity.timeCreated,
      );
    }
    return _heartRateZoneSchema;
  }

  calculateAverages() async {
    var recordList = RecordList(await this.records);
    db
      ..avgPower = recordList.calculateAveragePower()
      ..avgFormPower = recordList.calculateAverageFormPower()
      ..avgHeartRate = recordList.calculateAverageHeartRate()
      ..avgSpeed = recordList.calculateAverageSpeed()
      ..avgGroundTime = recordList.calculateAverageGroundTime()
      ..avgStrydCadence = recordList.calculateAverageStrydCadence()
      ..avgLegSpringStiffness = recordList.calculateAverageLegSpringStiffness()
      ..avgStrideRatio = recordList.calculateAverageStrideRatio()
      ..avgPowerRatio = recordList.calculateAverageStrideRatio()
      ..avgVerticalOscillation =
          recordList.calculateAverageVerticalOscillation();
    await db.save();
  }

  getPowerZone() async {
    if (_powerZone == null) {
      var powerZoneSchema = await getPowerZoneSchema();
      var dbPowerZone = await DbPowerZone()
          .select()
          .powerZoneSchemataId
          .equals(powerZoneSchema.db.id)
          .and
          .lowerLimit
          .lessThanOrEquals(db.avgPower)
          .and
          .upperLimit
          .greaterThanOrEquals(db.avgPower)
          .toSingle();
      _powerZone = PowerZone.fromDb(dbPowerZone);
    }
    return _powerZone;
  }

  getHeartRateZone() async {
    if (_heartRateZone == null) {
      var heartRateZoneSchema = await getHeartRateZoneSchema();
      var dbHeartRateZone = await DbHeartRateZone()
          .select()
          .heartRateZoneSchemataId
          .equals(heartRateZoneSchema.db.id)
          .and
          .lowerLimit
          .lessThanOrEquals(db.avgHeartRate)
          .and
          .upperLimit
          .greaterThanOrEquals(db.avgHeartRate)
          .toSingle();

      _heartRateZone = HeartRateZone.fromDb(dbHeartRateZone);
    }
    return _heartRateZone;
  }

  autoTagger({Athlete athlete}) async {
    PowerZone powerZone = await getPowerZone();
    if (powerZone.db != null) {
      Tag powerTag = await Tag.ensureAutoPowerTag(
        athlete: athlete,
        color: powerZone.db.color,
        name: powerZone.db.name,
      );
      await LapTagging.createBy(
        lap: this,
        tag: powerTag,
        system: true,
      );
    }

    HeartRateZone heartRateZone = await getHeartRateZone();
    if (heartRateZone.db != null) {
      Tag heartRateTag = await Tag.ensureAutoHeartRateTag(
        athlete: athlete,
        color: heartRateZone.db.color,
        name: heartRateZone.db.name,
      );
      await LapTagging.createBy(
        lap: this,
        tag: heartRateTag,
        system: true,
      );
    }
  }
}
