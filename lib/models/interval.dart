import 'package:sqfentity_gen/sqfentity_gen.dart';

import '../model/model.dart'
    show DbInterval, DbActivity, DbPowerZone, DbHeartRateZone, DbEvent;
import '../models/ftp.dart' as ftp_lib;
import '../models/tag.dart';
import 'activity.dart';
import 'athlete.dart';
import 'event.dart';
import 'heart_rate_zone.dart';
import 'heart_rate_zone_schema.dart';
import 'interval_tagging.dart';
import 'lap.dart';
import 'power_zone.dart';
import 'power_zone_schema.dart';
import 'record_list.dart';

class Interval {
  Interval() {
    _db = DbInterval();
  }

  Interval._fromDb(this._db);

  DbInterval? _db;
  Activity? activity;
  List<Event> _records = <Event>[];
  List<Tag> cachedTags = <Tag>[];
  double? firstDistance = 0;
  double? lastDistance = 0;
  int? index;
  double? weight;
  PowerZoneSchema? _powerZoneSchema;
  PowerZone? _powerZone;
  HeartRateZone? _heartRateZone;
  HeartRateZoneSchema? _heartRateZoneSchema;

  int? get id => _db?.id;
  DateTime? get timeStamp => _db!.timeStamp;

  double? get avgCadence => _db!.avgCadence;
  double? get avgFormPower => _db!.avgFormPower;
  double? get avgGroundTime => _db!.avgGroundTime;
  double? get avgLegSpringStiffness => _db!.avgLegSpringStiffness;
  double? get avgPower => _db!.avgPower;
  double? get avgSpeed => _db!.avgSpeed;
  double? get avgSpeedByMeasurements => _db!.avgSpeedByMeasurements;
  double? get avgSpeedByDistance => _db!.avgSpeedByDistance;
  double? get avgSpeedBySpeed => _db!.avgSpeedBySpeed;
  double? get avgStrydCadence => _db!.avgStrydCadence;
  double? get avgVerticalOscillation => _db!.avgVerticalOscillation;
  double? get cp => _db!.cp;
  double? get ftp => _db!.ftp;
  double? get maxCadence => _db!.maxCadence;
  double? get maxGroundTime => _db!.maxGroundTime;
  double? get maxLegSpringStiffness => _db!.maxLegSpringStiffness;
  double? get maxSpeed => _db!.maxSpeed;
  double? get maxStrydCadence => _db!.maxStrydCadence;
  double? get maxVerticalOscillation => _db!.maxVerticalOscillation;
  double? get minCadence => _db!.minCadence;
  double? get minGroundTime => _db!.minGroundTime;
  double? get minLegSpringStiffness => _db!.minLegSpringStiffness;
  double? get minSpeed => _db!.minSpeed;
  double? get minStrydCadence => _db!.minStrydCadence;
  double? get minVerticalOscillation => _db!.minVerticalOscillation;
  double? get sdevCadence => _db!.sdevCadence;
  double? get sdevFormPower => _db!.sdevFormPower;
  double? get sdevGroundTime => _db!.sdevGroundTime;
  double? get sdevHeartRate => _db!.sdevHeartRate;
  double? get sdevLegSpringStiffness => _db!.sdevLegSpringStiffness;
  double? get sdevPace => _db!.sdevPace;
  double? get sdevPower => _db!.sdevPower;
  double? get sdevSpeed => _db!.sdevSpeed;
  double? get sdevStrydCadence => _db!.sdevStrydCadence;
  double? get sdevVerticalOscillation => _db!.sdevVerticalOscillation;
  int? get activitiesId => _db!.activitiesId;
  int? get athletesId => _db!.athletesId;
  int? get firstRecordId => _db!.firstRecordId;
  int? get lastRecordId => _db!.lastRecordId;
  int? get avgHeartRate => _db!.avgHeartRate;
  int? get distance => _db!.distance;
  Duration get duration => Duration(seconds: _db!.duration ?? 0);
  int? get maxFormPower => _db!.maxFormPower;
  int? get maxHeartRate => _db!.maxHeartRate;
  int? get maxPower => _db!.maxPower;
  int? get minFormPower => _db!.minFormPower;
  int? get minHeartRate => _db!.minHeartRate;
  int? get minPower => _db!.minPower;
  int? get movingTime => _db!.movingTime;
  int? get totalAscent => _db!.totalAscent;
  int? get totalDescent => _db!.totalDescent;

  set timeStamp(DateTime? value) => _db!.timeStamp = value;
  set firstRecordId(int? value) => _db!.firstRecordId = value;
  set lastRecordId(int? value) => _db!.lastRecordId = value;
  set athletesId(int? value) => _db!.athletesId = value;
  set activitiesId(int? value) => _db!.activitiesId = value;
  set distance(int? value) => _db!.distance = value;
  set duration(Duration value) => _db!.duration = value.inSeconds;
  set ftp(double? value) => _db!.ftp = value;

  Future<BoolResult> delete() async => await _db!.delete();
  Future<int?> save() async => await _db!.save();

  Future<void> setValues() async {
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
      ..avgSpeedBySpeed = recordList.avgSpeedBySpeed()
      ..avgSpeedByDistance = recordList.avgSpeedByDistance()
      ..sdevSpeed = recordList.sdevSpeed()
      ..sdevPace = recordList.sdevPace()
      ..minSpeed = recordList.minSpeed()
      ..maxSpeed = recordList.maxSpeed()
      ..avgGroundTime = recordList.avgGroundTime()
      ..sdevGroundTime = recordList.sdevGroundTime()
      ..minGroundTime = recordList.minGroundTime()
      ..maxGroundTime = recordList.maxGroundTime()
      ..avgStrydCadence = recordList.avgStrydCadence()
      ..sdevStrydCadence = recordList.sdevStrydCadence()
      ..minStrydCadence = recordList.minStrydCadence()
      ..maxStrydCadence = recordList.maxStrydCadence()
      ..avgCadence = recordList.avgStrydCadence()
      ..sdevCadence = recordList.sdevStrydCadence()
      ..minCadence = recordList.minCadence()
      ..maxCadence = recordList.maxCadence()
      ..avgLegSpringStiffness = recordList.avgLegSpringStiffness()
      ..sdevLegSpringStiffness = recordList.sdevLegSpringStiffness()
      ..minLegSpringStiffness = recordList.minLegSpringStiffness()
      ..maxLegSpringStiffness = recordList.maxLegSpringStiffness()
      ..avgVerticalOscillation = recordList.avgVerticalOscillation()
      ..sdevVerticalOscillation = recordList.sdevVerticalOscillation()
      ..minVerticalOscillation = recordList.minVerticalOscillation()
      ..maxVerticalOscillation = recordList.maxVerticalOscillation()
      ..avgFormPower = recordList.avgFormPower()
      ..sdevFormPower = recordList.sdevFormPower()
      ..minFormPower = recordList.minFormPower()
      ..maxFormPower = recordList.maxFormPower()
      ..totalAscent = recordList.totalAscent().round()
      ..totalDescent = recordList.totalDescent().round()
      ..movingTime = recordList.movingTime();
    await save();
  }

  Future<List<Event>> get records async {
    final List<DbEvent> dbEvents = await DbEvent()
        .select()
        .id
        .greaterThanOrEquals(firstRecordId)
        .and
        .id
        .lessThanOrEquals(lastRecordId)
        .toList();
    final List<Event> events = dbEvents.map(Event.exDb).toList();
    _records = events.where((Event event) => event.event == 'record').toList();
    return _records;
  }

  // calculated from other attributes:
  double? get ecor {
    if (avgPower != null &&
        avgSpeed != null &&
        avgSpeed! > 0 &&
        weight != null &&
        weight! > 0) {
      return avgPower! / avgSpeed! / weight!;
    } else {
      return null;
    }
  }

  double? get avgPace {
    if (avgSpeedByDistance != null && avgSpeedByDistance != 0) {
      return 50 / 3 / avgSpeedByDistance!;
    } else {
      return null;
    }
  }

  double? get avgSpeedPerHeartRate {
    if (avgSpeed != null && avgHeartRate != null && avgHeartRate != 0) {
      return 100 * (avgSpeed! / avgHeartRate!);
    } else {
      return null;
    }
  }

  double? get avgPowerPerHeartRate {
    if (avgPower != null &&
        avgPower != -1 &&
        avgHeartRate != null &&
        avgHeartRate != null) {
      return avgPower! / avgHeartRate!;
    } else {
      return null;
    }
  }

  int? get elevationDifference {
    if (totalAscent != null && totalDescent != null) {
      return totalAscent! - totalDescent!;
    } else {
      return null;
    }
  }

  double? get avgDoubleStrydCadence {
    if (avgStrydCadence != null) {
      return avgStrydCadence! * 2;
    } else {
      return null;
    }
  }

  // easier check for data availability
  bool get powerAvailable => !<num?>[null, -1].contains(avgPower);
  bool get heartRateAvailable => !<num?>[null, -1].contains(avgHeartRate);
  bool get ascentAvailable => totalAscent != null && totalDescent != null;
  bool get cadenceAvailable => !<num?>[null, -1].contains(avgStrydCadence);
  bool get speedAvailable => !<num?>[null, 0, -1].contains(avgSpeedByDistance);
  bool get weightAvailable => !<num?>[null, 0].contains(weight);
  bool get paceAvailable => !<num?>[null, -1].contains(avgPace);
  bool get ecorAvailable => !<num?>[null, -1].contains(ecor);
  bool get groundTimeAvailable => !<num?>[null, -1].contains(avgGroundTime);
  bool get formPowerAvailable => !<num?>[null, -1].contains(avgFormPower);
  bool get verticalOscillationAvailable =>
      !<num?>[null, -1].contains(avgVerticalOscillation);
  bool get strideCadenceAvailable =>
      !<num?>[null, -1].contains(avgDoubleStrydCadence);
  bool get legSpringStiffnessAvailable =>
      !<num?>[null, -1].contains(avgLegSpringStiffness);

  Future<PowerZone?> get powerZone async {
    if (_powerZone == null) {
      final DbPowerZone? dbPowerZone = await DbPowerZone()
          .select()
          .powerZoneSchemataId
          .equals((await powerZoneSchema)!.id)
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

  Future<HeartRateZone?> get heartRateZone async {
    if (_heartRateZone == null) {
      final DbHeartRateZone? dbHeartRateZone = await DbHeartRateZone()
          .select()
          .heartRateZoneSchemataId
          .equals((await heartRateZoneSchema)!.id)
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

  Future<HeartRateZoneSchema?> get heartRateZoneSchema async {
    if (_heartRateZoneSchema == null) {
      final DbActivity dbActivity = await (DbActivity().getById(activitiesId) as FutureOr<DbActivity>);

      _heartRateZoneSchema = await HeartRateZoneSchema.getBy(
        athletesId: dbActivity.athletesId,
        date: dbActivity.timeCreated,
      );
    }
    return _heartRateZoneSchema;
  }

  Future<PowerZoneSchema?> get powerZoneSchema async {
    if (_powerZoneSchema == null) {
      final DbActivity dbActivity = await (DbActivity().getById(activitiesId) as FutureOr<DbActivity>);

      _powerZoneSchema = await PowerZoneSchema.getBy(
        athletesId: dbActivity.athletesId,
        date: dbActivity.timeCreated,
      );
    }
    return _powerZoneSchema;
  }

  Future<void> autoTagger({required Athlete? athlete}) async {
    final PowerZone powerZone = await (this.powerZone as FutureOr<PowerZone>);
    if (powerZone.id != null) {
      final Tag powerTag = await Tag.autoPowerTag(
        athlete: athlete!,
        sortOrder: powerZone.lowerLimit,
        color: powerZone.color,
        name: powerZone.name,
      );
      await IntervalTagging.createBy(
        interval: this,
        tag: powerTag,
        system: true,
      );
    }

    final HeartRateZone heartRateZone = await (this.heartRateZone as FutureOr<HeartRateZone>);
    if (heartRateZone.id != null) {
      final Tag heartRateTag = await Tag.autoHeartRateTag(
        athlete: athlete!,
        sortOrder: heartRateZone.lowerLimit,
        color: heartRateZone.color,
        name: heartRateZone.name,
      );
      await IntervalTagging.createBy(
        interval: this,
        tag: heartRateTag,
        system: true,
      );
    }
  }

  Future<void> calculateAndSave({required RecordList<Event> records}) async {
    distance = (records.last.distance! - records.first.distance!).round();
    duration = records.last.timeStamp!.difference(records.first.timeStamp!);
    ftp = ftp_lib.calculate(records: records);
    timeStamp = records.first.timeStamp;
    await setValues();
  }

  Future<void> copyTaggings({required Lap lap}) async {
    final List<Tag> tags = await Tag.allByLap(lap: lap);
    for (final Tag tag in tags) {
      await IntervalTagging(tag: tag, interval: this).save();
    }
  }

  Future<List<Tag>> get tags async {
    if (cachedTags.isEmpty) {
      cachedTags = await Tag.allByInterval(interval: this);
    }
    return cachedTags;
  }

  static Interval exDb(DbInterval db) => Interval._fromDb(db);
}
