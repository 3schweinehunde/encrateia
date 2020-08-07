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
  DateTime get startTime => _db.startTime;
  DateTime get timeStamp => _db.timeStamp;
  String get event => _db.event;
  String get eventType => _db.eventType;
  String get lapTrigger => _db.lapTrigger;
  String get sport => _db.sport;
  String get subSport => _db.subSport;
  double get avgFormPower => _db.avgFormPower;
  double get avgFractionalCadence => _db.avgFractionalCadence;
  double get avgGroundTime => _db.avgGroundTime;
  double get avgLegSpringStiffness => _db.avgLegSpringStiffness;
  double get avgPower => _db.avgPower;
  double get avgRunningCadence => _db.avgRunningCadence;
  double get avgSpeed => _db.avgSpeed;
  double get avgSpeedByMeasurements => _db.avgSpeedByMeasurements;
  double get avgSpeedByTime => _db.avgSpeedByTime;
  double get avgSpeedByDistance => _db.avgSpeedByDistance;
  double get avgStanceTime => _db.avgStanceTime;
  double get avgStanceTimePercent => _db.avgStanceTimePercent;
  double get avgStrydCadence => _db.avgStrydCadence;
  double get avgVerticalOscillation => _db.avgVerticalOscillation;
  double get cp => _db.cp;
  double get ftp => _db.ftp;
  double get endPositionLat => _db.endPositionLat;
  double get endPositionLong => _db.endPositionLong;
  double get maxFractionalCadence => _db.maxFractionalCadence;
  double get maxSpeed => _db.maxSpeed;
  double get minSpeed => _db.minSpeed;
  double get sdevFormPower => _db.sdevFormPower;
  double get sdevGroundTime => _db.sdevGroundTime;
  double get sdevHeartRate => _db.sdevHeartRate;
  double get sdevLegSpringStiffness => _db.sdevLegSpringStiffness;
  double get sdevPace => _db.sdevPace;
  double get sdevPower => _db.sdevPower;
  double get sdevSpeed => _db.sdevSpeed;
  double get sdevStrydCadence => _db.sdevStrydCadence;
  double get sdevVerticalOscillation => _db.sdevVerticalOscillation;
  double get startPositionLat => _db.startPositionLat;
  double get startPositionLong => _db.startPositionLong;
  double get totalFractionalCycles => _db.totalFractionalCycles;
  int get activitiesId => _db.activitiesId;
  int get avgHeartRate => _db.avgHeartRate;
  int get avgTemperature => _db.avgTemperature;
  int get eventGroup => _db.eventGroup;
  int get intensity => _db.intensity;
  int get maxHeartRate => _db.maxHeartRate;
  int get maxPower => _db.maxPower;
  int get maxRunningCadence => _db.maxRunningCadence;
  int get maxTemperature => _db.maxTemperature;
  int get minHeartRate => _db.minHeartRate;
  int get minPower => _db.minPower;
  int get totalAscent => _db.totalAscent;
  int get totalCalories => _db.totalCalories;
  int get totalDescent => _db.totalDescent;
  int get totalDistance => _db.totalDistance;
  int get totalElapsedTime => _db.totalElapsedTime;
  int get totalStrides => _db.totalStrides;
  int get totalTimerTime => _db.totalTimerTime;

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
      ..avgPower = recordList.avgPower()
      ..sdevPower = recordList.sdevPower()
      ..minPower = recordList.minPower()
      ..maxPower = recordList.maxPower()
      ..avgHeartRate = recordList.avgHeartRate()
      ..sdevHeartRate = recordList.sdevHeartRate()
      ..minHeartRate = recordList.minHeartRate()
      ..maxHeartRate = recordList.maxHeartRate()
      ..avgSpeedByMeasurements = recordList.avgSpeedByMeasurements()
      ..avgSpeedByTime = recordList.avgSpeedByTime()
      ..avgSpeedByDistance = recordList.avgSpeedByDistance()
      ..sdevSpeed = recordList.sdevSpeed()
      ..sdevPace = recordList.sdevPace()
      ..minSpeed = recordList.minSpeed()
      ..maxSpeed = recordList.maxSpeed()
      ..avgGroundTime = recordList.avgGroundTime()
      ..sdevGroundTime = recordList.sdevGroundTime()
      ..avgStrydCadence = recordList.avgStrydCadence()
      ..sdevStrydCadence = recordList.sdevStrydCadence()
      ..avgLegSpringStiffness = recordList.avgLegSpringStiffness()
      ..sdevLegSpringStiffness = recordList.sdevLegSpringStiffness()
      ..avgVerticalOscillation =
      recordList.avgVerticalOscillation()
      ..sdevVerticalOscillation = recordList.sdevVerticalOscillation()
      ..avgFormPower = recordList.avgFormPower()
      ..sdevFormPower = recordList.sdevFormPower()
      ..avgPowerRatio = recordList.avgPowerRatio()
      ..sdevPowerRatio = recordList.sdevPowerRatio()
      ..avgStrideRatio = recordList.avgStrideRatio()
      ..sdevStrideRatio = recordList.sdevStrideRatio();
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
