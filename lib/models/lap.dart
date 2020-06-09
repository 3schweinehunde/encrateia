import 'package:encrateia/model/model.dart'
    show DbLap, DbActivity, DbPowerZone, DbHeartRateZone, DbEvent;
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
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import 'bar_zone.dart';

class Lap {
  Lap() {
    _db = DbLap();
  }

  Lap._fromDb(this._db);

  DbLap _db;
  Activity activity;
  int index;
  List<Event> _records;
  PowerZoneSchema _powerZoneSchema;
  PowerZone _powerZone;
  HeartRateZone _heartRateZone;
  HeartRateZoneSchema _heartRateZoneSchema;
  List<BarZone> powerDistributions;
  List<BarZone> heartRateDistributions;

  int get id => _db?.id;
  int get activitiesId => _db.activitiesId;
  int get avgHeartRate => _db.avgHeartRate;
  int get totalDistance => _db.totalDistance;
  String get event => _db.event;
  String get sport => _db.sport;
  DateTime get startTime => _db.startTime;
  String get subSport => _db.subSport;
  String get eventType => _db.eventType;
  int get eventGroup => _db.eventGroup;
  int get totalElapsedTime => _db.totalElapsedTime;
  int get totalTimerTime => _db.totalTimerTime;
  double get avgStanceTimePercent => _db.avgStanceTimePercent;
  double get avgStanceTime => _db.avgStanceTime;
  String get lapTrigger => _db.lapTrigger;
  double get totalFractionalCycles => _db.totalFractionalCycles;
  double get startPositionLong => _db.startPositionLong;
  double get startPositionLat => _db.startPositionLat;
  double get endPositionLong => _db.endPositionLong;
  double get endPositionLat => _db.endPositionLat;
  int get intensity => _db.intensity;
  double get avgSpeed => _db.avgSpeed;
  double get maxSpeed => _db.maxSpeed;
  int get totalCalories => _db.totalCalories;
  int get totalAscent => _db.totalAscent;
  int get totalDescent => _db.totalDescent;
  double get avgRunningCadence => _db.avgRunningCadence;
  int get totalStrides => _db.totalStrides;
  DateTime get timeStamp => _db.timeStamp;
  int get avgTemperature => _db.avgTemperature;
  int get maxTemperature => _db.maxTemperature;
  double get avgFractionalCadence => _db.avgFractionalCadence;
  double get maxFractionalCadence => _db.maxFractionalCadence;
  int get maxHeartRate => _db.maxHeartRate;
  double get avgPower => _db.avgPower;
  double get avgVerticalOscillation => _db.avgVerticalOscillation;
  int get maxRunningCadence => _db.maxRunningCadence;
  double get avgGroundTime => _db.avgGroundTime;
  double get avgStrydCadence => _db.avgStrydCadence;
  double get avgLegSpringStiffness => _db.avgLegSpringStiffness;
  double get avgFormPower => _db.avgFormPower;

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Lap fromLap({
    DataMessage dataMessage,
    Activity activity,
    Lap lap,
  }) {
    lap._db
      ..activitiesId = activity.id
      ..avgSpeed = dataMessage.get('avg_speed') as double
      ..maxSpeed = dataMessage.get('max_speed') as double
      ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp') as double)
      ..startTime = dateTimeFromStrava(dataMessage.get('start_time') as double)
      ..startPositionLat = dataMessage.get('start_position_lat') as double
      ..startPositionLong = dataMessage.get('start_position_long') as double
      ..endPositionLat = dataMessage.get('end_position_lat') as double
      ..endPositionLong = dataMessage.get('end_position_long') as double
      ..startPositionLat = dataMessage.get('end_position_lat') as double
      ..avgHeartRate = (dataMessage.get('avg_heart_rate') as double)?.round()
      ..maxHeartRate = (dataMessage.get('max_heart_rate') as double)?.round()
      ..avgRunningCadence = dataMessage.get('avg_running_cadence') as double
      ..event = dataMessage.get('event') as String
      ..eventType = dataMessage.get('event_type') as String
      ..eventGroup = (dataMessage.get('event_group') as double)?.round()
      ..sport = dataMessage.get('sport') as String
      ..subSport = dataMessage.get('sub_sport') as String
      ..avgVerticalOscillation =
          dataMessage.get('avg_vertical_oscillation') as double
      ..totalElapsedTime =
          (dataMessage.get('total_elapsed_time') as double)?.round()
      ..totalTimerTime =
          (dataMessage.get('total_timer_time') as double)?.round()
      ..totalDistance = (dataMessage.get('total_distance') as double)?.round()
      ..totalStrides = (dataMessage.get('total_strides') as double)?.round()
      ..totalCalories = (dataMessage.get('total_calories') as double)?.round()
      ..totalAscent = (dataMessage.get('total_ascent') as double)?.round()
      ..totalDescent = (dataMessage.get('total_descent') as double)?.round()
      ..avgStanceTimePercent =
          dataMessage.get('avg_stance_time_percent') as double
      ..avgStanceTime = dataMessage.get('avg_stance_time') as double
      ..maxRunningCadence =
          (dataMessage.get('max_running_cadence') as double)?.round()
      ..intensity = dataMessage.get('intensity') as int
      ..lapTrigger = dataMessage.get('lap_trigger') as String
      ..avgTemperature = (dataMessage.get('avg_temperature') as double)?.round()
      ..maxTemperature = (dataMessage.get('max_temperature') as double)?.round()
      ..avgFractionalCadence =
          dataMessage.get('avg_fractional_cadence') as double
      ..maxFractionalCadence =
          dataMessage.get('max_fractional_cadence') as double
      ..totalFractionalCycles =
          dataMessage.get('total_fractional_cycles') as double;
    return lap;
  }

  Future<List<Event>> get records async {
    _records ??= await Event.recordsByLap(this);
    return _records;
  }

  Future<double> get sdevPower async {
    if (_db.sdevPower == null) {
      _db.sdevPower = RecordList<Event>(await records).calculateSdevPower();
      await save();
    }
    return _db.sdevPower;
  }

  Future<int> get minPower async {
    if (_db.minPower == null) {
      _db.minPower = RecordList<Event>(await records).calculateMinPower();
      await save();
    }
    return _db.minPower;
  }

  Future<int> get maxPower async {
    if (_db.maxPower == null) {
      _db.maxPower = RecordList<Event>(await records).calculateMaxPower();
      await save();
    }
    return _db.maxPower;
  }

  Future<double> get sdevGroundTime async {
    if (_db.sdevGroundTime == null) {
      _db.sdevGroundTime =
          RecordList<Event>(await records).calculateSdevGroundTime();
      await save();
    }
    return _db.sdevGroundTime;
  }

  Future<double> get sdevVerticalOscillation async {
    if (_db.sdevVerticalOscillation == null) {
      _db.sdevVerticalOscillation =
          RecordList<Event>(await records).calculateSdevVerticalOscillation();
      await save();
    }
    return _db.sdevVerticalOscillation;
  }

  Future<double> get sdevStrydCadence async {
    if (_db.sdevStrydCadence == null) {
      _db.sdevStrydCadence =
          RecordList<Event>(await records).calculateSdevStrydCadence();
      await save();
    }
    return _db.sdevStrydCadence;
  }

  Future<double> get sdevLegSpringStiffness async {
    if (_db.sdevLegSpringStiffness == null) {
      _db.sdevLegSpringStiffness =
          RecordList<Event>(await records).calculateSdevLegSpringStiffness();
      await save();
    }
    return _db.sdevLegSpringStiffness;
  }

  Future<double> get sdevFormPower async {
    if (_db.sdevFormPower == null) {
      _db.sdevFormPower =
          RecordList<Event>(await records).calculateSdevFormPower();
      await save();
    }
    return _db.sdevFormPower;
  }

  Future<PowerZoneSchema> get powerZoneSchema async {
    if (_powerZoneSchema == null) {
      final DbActivity dbActivity = await DbActivity().getById(activitiesId);

      _powerZoneSchema = await PowerZoneSchema.getBy(
        athletesId: dbActivity.athletesId,
        date: dbActivity.timeCreated,
      );
    }
    return _powerZoneSchema;
  }

  Future<HeartRateZoneSchema> get heartRateZoneSchema async {
    if (_heartRateZoneSchema == null) {
      final DbActivity dbActivity = await DbActivity().getById(activitiesId);

      _heartRateZoneSchema = await HeartRateZoneSchema.getBy(
        athletesId: dbActivity.athletesId,
        date: dbActivity.timeCreated,
      );
    }
    return _heartRateZoneSchema;
  }

  Future<void> setAverages() async {
    final RecordList<Event> recordList = RecordList<Event>(await records);
    _db
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
    await save();
  }

  Future<PowerZone> get powerZone async {
    if (_powerZone == null) {
      final DbPowerZone dbPowerZone = await DbPowerZone()
          .select()
          .powerZoneSchemataId
          .equals((await powerZoneSchema).id)
          .and
          .lowerLimit
          .lessThanOrEquals(avgPower)
          .and
          .upperLimit
          .greaterThanOrEquals(avgPower)
          .toSingle();
      _powerZone = PowerZone.exDb(dbPowerZone);
    }
    return _powerZone;
  }

  Future<HeartRateZone> get heartRateZone async {
    if (_heartRateZone == null) {
      final DbHeartRateZone dbHeartRateZone = await DbHeartRateZone()
          .select()
          .heartRateZoneSchemataId
          .equals((await heartRateZoneSchema).id)
          .and
          .lowerLimit
          .lessThanOrEquals(avgHeartRate)
          .and
          .upperLimit
          .greaterThanOrEquals(avgHeartRate)
          .toSingle();

      _heartRateZone = HeartRateZone.exDb(dbHeartRateZone);
    }
    return _heartRateZone;
  }

  Future<void> autoTagger({@required Athlete athlete}) async {
    final PowerZone powerZone = await this.powerZone;
    if (powerZone.id != null) {
      final Tag powerTag = await Tag.autoPowerTag(
        athlete: athlete,
        sortOrder: powerZone.lowerLimit,
        color: powerZone.color,
        name: powerZone.name,
      );
      await LapTagging.createBy(
        lap: this,
        tag: powerTag,
        system: true,
      );
    }

    final HeartRateZone heartRateZone = await this.heartRateZone;
    if (heartRateZone.id != null) {
      final Tag heartRateTag = await Tag.autoHeartRateTag(
        athlete: athlete,
        sortOrder: heartRateZone.lowerLimit,
        color: heartRateZone.color,
        name: heartRateZone.name,
      );
      await LapTagging.createBy(
        lap: this,
        tag: heartRateTag,
        system: true,
      );
    }
  }

  Future<List<BarZone>> powerZoneCounts() async {
    final PowerZoneSchema powerZoneSchema = await this.powerZoneSchema;
    final List<Event> records = await this.records;
    final List<Event> powerRecords =
        records.where((Event record) => record.power != null).toList();
    final List<BarZone> powerZoneCounts = await RecordList<Event>(powerRecords)
        .powerZoneCounts(powerZoneSchema: powerZoneSchema);
    return powerZoneCounts;
  }

  Future<List<BarZone>> heartRateZoneCounts() async {
    final HeartRateZoneSchema heartRateZoneSchema =
        await this.heartRateZoneSchema;
    final List<Event> records = await this.records;
    final List<Event> heartRateRecords =
        records.where((Event record) => record.heartRate != null).toList();
    final List<BarZone> heartRateZoneCounts =
        await RecordList<Event>(heartRateRecords)
            .heartRateZoneCounts(heartRateZoneSchema: heartRateZoneSchema);
    return heartRateZoneCounts;
  }

  Future<List<Event>> get events async {
    final List<DbEvent> dbEvents = await _db.getDbEvents().toList();
    return dbEvents.map(Event.exDb).toList();
  }

  static Lap exDb(DbLap db) => Lap._fromDb(db);
}
