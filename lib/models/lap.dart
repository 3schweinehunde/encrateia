import 'package:encrateia/model/model.dart'
    show DbLap, DbActivity, DbPowerZone, DbHeartRateZone;
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

import 'bar_zone.dart';

class Lap {
  Lap() {
    db = DbLap();
  }

  Lap.fromDb(this.db);

  DbLap db;
  Activity activity;
  int index;
  List<Event> _records;
  PowerZoneSchema _powerZoneSchema;
  PowerZone _powerZone;
  HeartRateZone _heartRateZone;
  HeartRateZoneSchema _heartRateZoneSchema;
  List<BarZone> powerDistributions;
  List<BarZone> heartRateDistributions;

  static Lap fromLap({
    DataMessage dataMessage,
    Activity activity,
    Lap lap,
  }) {
    lap.db
      ..activitiesId = activity.db.id
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
    _records ??= await Event.recordsByLap(lap: this);
    return _records;
  }

  Future<double> get avgPower async {
    if (db.avgPower == null) {
      db.avgPower = RecordList<Event>(await records).calculateAveragePower();
      await db.save();
    }
    return db.avgPower;
  }

  Future<double> get sdevPower async {
    if (db.sdevPower == null) {
      db.sdevPower = RecordList<Event>(await records).calculateSdevPower();
      await db.save();
    }
    return db.sdevPower;
  }

  Future<int> get minPower async {
    if (db.minPower == null) {
      db.minPower = RecordList<Event>(await records).calculateMinPower();
      await db.save();
    }
    return db.minPower;
  }

  Future<int> get maxPower async {
    if (db.maxPower == null) {
      db.maxPower = RecordList<Event>(await records).calculateMaxPower();
      await db.save();
    }
    return db.maxPower;
  }

  Future<double> get avgGroundTime async {
    if (db.avgGroundTime == null) {
      db.avgGroundTime =
          RecordList<Event>(await records).calculateAverageGroundTime();
      await db.save();
    }
    return db.avgGroundTime;
  }

  Future<double> get sdevGroundTime async {
    if (db.sdevGroundTime == null) {
      db.sdevGroundTime =
          RecordList<Event>(await records).calculateSdevGroundTime();
      await db.save();
    }
    return db.sdevGroundTime;
  }

  Future<double> get avgVerticalOscillation async {
    if (db.avgVerticalOscillation == null ||
        db.avgVerticalOscillation == 6553.5) {
      db.avgVerticalOscillation = RecordList<Event>(await records)
          .calculateAverageVerticalOscillation();
      await db.save();
    }
    return db.avgVerticalOscillation;
  }

  Future<double> get sdevVerticalOscillation async {
    if (db.sdevVerticalOscillation == null) {
      db.sdevVerticalOscillation =
          RecordList<Event>(await records).calculateSdevVerticalOscillation();
      await db.save();
    }
    return db.sdevVerticalOscillation;
  }

  Future<double> get avgStrydCadence async {
    if (db.avgStrydCadence == null) {
      db.avgStrydCadence =
          RecordList<Event>(await records).calculateAverageStrydCadence();
      await db.save();
    }
    return db.avgStrydCadence;
  }

  Future<double> get sdevStrydCadence async {
    if (db.sdevStrydCadence == null) {
      db.sdevStrydCadence =
          RecordList<Event>(await records).calculateSdevStrydCadence();
      await db.save();
    }
    return db.sdevStrydCadence;
  }

  Future<double> get avgLegSpringStiffness async {
    if (db.avgLegSpringStiffness == null) {
      db.avgLegSpringStiffness =
          RecordList<Event>(await records).calculateAverageLegSpringStiffness();
      await db.save();
    }
    return db.avgLegSpringStiffness;
  }

  Future<double> get sdevLegSpringStiffness async {
    if (db.sdevLegSpringStiffness == null) {
      db.sdevLegSpringStiffness =
          RecordList<Event>(await records).calculateSdevLegSpringStiffness();
      await db.save();
    }
    return db.sdevLegSpringStiffness;
  }

  Future<double> get avgFormPower async {
    if (db.avgFormPower == null) {
      db.avgFormPower =
          RecordList<Event>(await records).calculateAverageFormPower();
      await db.save();
    }
    return db.avgFormPower;
  }

  Future<double> get sdevFormPower async {
    if (db.sdevFormPower == null) {
      db.sdevFormPower =
          RecordList<Event>(await records).calculateSdevFormPower();
      await db.save();
    }
    return db.sdevFormPower;
  }

  static Future<List<Lap>> all({Activity activity}) async {
    int counter = 1;

    final List<DbLap> dbLapList = await activity.db.getDbLaps().toList();
    final List<Lap> lapList =
        dbLapList.map((DbLap dbLap) => Lap.fromDb(dbLap)).toList();

    for (final Lap lap in lapList) {
      lap
        ..activity = activity
        ..index = counter;
      counter = counter + 1;
    }
    return lapList;
  }

  Future<PowerZoneSchema> get powerZoneSchema async {
    if (_powerZoneSchema == null) {
      final DbActivity dbActivity = await DbActivity().getById(db.activitiesId);

      _powerZoneSchema = await PowerZoneSchema.getBy(
        athletesId: dbActivity.athletesId,
        date: dbActivity.timeCreated,
      );
    }
    return _powerZoneSchema;
  }

  Future<HeartRateZoneSchema> get heartRateZoneSchema async {
    if (_heartRateZoneSchema == null) {
      final DbActivity dbActivity = await DbActivity().getById(db.activitiesId);

      _heartRateZoneSchema = await HeartRateZoneSchema.getBy(
        athletesId: dbActivity.athletesId,
        date: dbActivity.timeCreated,
      );
    }
    return _heartRateZoneSchema;
  }

  Future<void> averages() async {
    final RecordList<Event> recordList = RecordList<Event>(await records);
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

  Future<PowerZone> get powerZone async {
    if (_powerZone == null) {
      final DbPowerZone dbPowerZone = await DbPowerZone()
          .select()
          .powerZoneSchemataId
          .equals((await powerZoneSchema).id)
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

  Future<HeartRateZone> get heartRateZone async {
    if (_heartRateZone == null) {
      final DbHeartRateZone dbHeartRateZone = await DbHeartRateZone()
          .select()
          .heartRateZoneSchemataId
          .equals((await heartRateZoneSchema).id)
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
        records.where((Event record) => record.db.power != null).toList();
    final List<BarZone> powerZoneCounts = await RecordList<Event>(powerRecords)
        .powerZoneCounts(powerZoneSchema: powerZoneSchema);
    return powerZoneCounts;
  }

  Future<List<BarZone>> heartRateZoneCounts() async {
    final HeartRateZoneSchema heartRateZoneSchema =
        await this.heartRateZoneSchema;
    final List<Event> records = await this.records;
    final List<Event> heartRateRecords =
        records.where((Event record) => record.db.heartRate != null).toList();
    final List<BarZone> heartRateZoneCounts =
        await RecordList<Event>(heartRateRecords)
            .heartRateZoneCounts(heartRateZoneSchema: heartRateZoneSchema);
    return heartRateZoneCounts;
  }
}
