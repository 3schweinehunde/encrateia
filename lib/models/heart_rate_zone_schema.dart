import 'package:flutter/material.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import '/model/model.dart' show DbHeartRateZone, DbHeartRateZoneSchema;
import '/models/athlete.dart';
import '/models/heart_rate_zone.dart';

class HeartRateZoneSchema {
  HeartRateZoneSchema({@required Athlete athlete}) {
    _db = DbHeartRateZoneSchema()
      ..athletesId = athlete.id
      ..base = 180
      ..name = 'My Schema'
      ..date = DateTime.now();
  }
  HeartRateZoneSchema._fromDb(this._db);

  HeartRateZoneSchema.likeGarmin({Athlete athlete}) {
    _db = DbHeartRateZoneSchema()
      ..athletesId = athlete.id
      ..name = 'max HR based'
      ..date = DateTime.now()
      ..base = 180;
  }

  HeartRateZoneSchema.likeStefanDillinger({Athlete athlete}) {
    _db = DbHeartRateZoneSchema()
      ..athletesId = athlete.id
      ..name = 'threshold heart rate based'
      ..date = DateTime.now()
      ..base = 165;
  }

  DbHeartRateZoneSchema _db;

  int get id => _db?.id;
  DateTime get date => _db.date;
  String get name => _db.name;
  int get base => _db.base;

  set id(int value) => _db.id = value;
  set base(int value) => _db.base = value;
  set date(DateTime value) => _db.date = value;
  set name(String value) => _db.name = value;

  Future<List<HeartRateZone>> get heartRateZones async {
    final List<DbHeartRateZone> dbHeartRateZoneList =
        await _db.getDbHeartRateZones().orderBy('lowerLimit').toList();
    final List<HeartRateZone> heartRateZones =
        dbHeartRateZoneList.map(HeartRateZone.exDb).toList();
    return heartRateZones;
  }

  Future<void> addGarminZones() async {
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Warmup',
      lowerPercentage: 50,
      upperPercentage: 60,
      color: Colors.grey.value,
    ).save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Easy',
      lowerPercentage: 60,
      upperPercentage: 70,
      color: Colors.blue.value,
    ).save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Aerobic',
      lowerPercentage: 70,
      upperPercentage: 80,
      color: Colors.green.value,
    ).save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Threshold',
      lowerPercentage: 80,
      upperPercentage: 90,
      color: Colors.orange.value,
    ).save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Maximum',
      lowerPercentage: 90,
      upperPercentage: 100,
      color: Colors.red.value,
    ).save();
  }

  Future<void> addStefanDillingerZones() async {
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z1',
      lowerPercentage: 70,
      upperPercentage: 80,
      color: Colors.grey.value,
    ).save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z2',
      lowerPercentage: 80,
      upperPercentage: 88,
      color: Colors.blue.value,
    ).save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z3',
      lowerPercentage: 88,
      upperPercentage: 95,
      color: Colors.green.value,
    ).save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z4',
      lowerPercentage: 95,
      upperPercentage: 100,
      color: Colors.orange.value,
    ).save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z5/6',
      lowerPercentage: 100,
      upperPercentage: 115,
      color: Colors.red.value,
    ).save();
  }

  @override
  String toString() => '< HeartRateZoneSchema | $name | $date >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Future<HeartRateZoneSchema> getBy({
    int athletesId,
    DateTime date,
  }) async {
    List<DbHeartRateZoneSchema> dbHeartRateZoneSchemas;
    dbHeartRateZoneSchemas = await DbHeartRateZoneSchema()
        .select()
        .athletesId
        .equals(athletesId)
        .and
        .date
        .lessThanOrEquals(date)
        .orderByDesc('date')
        .top(1)
        .toList();
    if (dbHeartRateZoneSchemas.isNotEmpty)
      return HeartRateZoneSchema._fromDb(dbHeartRateZoneSchemas.first);
    else
      dbHeartRateZoneSchemas = await DbHeartRateZoneSchema()
          .select()
          .athletesId
          .equals(athletesId)
          .orderBy('date')
          .top(1)
          .toList();
    return (dbHeartRateZoneSchemas.isNotEmpty)
        ? HeartRateZoneSchema._fromDb(dbHeartRateZoneSchemas.first)
        : null;
  }

  static HeartRateZoneSchema exDb(DbHeartRateZoneSchema db) =>
      HeartRateZoneSchema._fromDb(db);
}
