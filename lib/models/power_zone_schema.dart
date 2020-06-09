import 'package:encrateia/models/power_zone.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbPowerZone, DbPowerZoneSchema;
import 'package:encrateia/models/athlete.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class PowerZoneSchema {
  PowerZoneSchema({@required Athlete athlete}) {
    _db = DbPowerZoneSchema()
      ..athletesId = athlete.id
      ..base = 250
      ..name = 'My Schema'
      ..date = DateTime.now();
  }
  PowerZoneSchema._fromDb(this._db);

  PowerZoneSchema.likeStryd({Athlete athlete}) {
    _db = DbPowerZoneSchema()
      ..athletesId = athlete.id
      ..name = 'CP based'
      ..date = DateTime(1970, 01, 01)
      ..base = 250;
  }

  // https://www.velopress.com/jim-vances-running-power-zones/
  PowerZoneSchema.likeJimVance({Athlete athlete}) {
    _db = DbPowerZoneSchema()
      ..athletesId = athlete.id
      ..name = 'FTP based'
      ..date = DateTime(1970, 01, 01)
      ..base = 250;
  }

  PowerZoneSchema.likeStefanDillinger({Athlete athlete}) {
    _db = DbPowerZoneSchema()
      ..athletesId = athlete.id
      ..name = 'FTP based'
      ..date = DateTime(1970, 01, 01)
      ..base = 250;
  }

  DbPowerZoneSchema _db;

  int get id => _db?.id;
  DateTime get date => _db.date;
  String get name => _db.name;
  int get base => _db.base;

  set id(int value) => _db.id = value;
  set base(int value) => _db.base = value;
  set date(DateTime value) => _db.date = value;
  set name(String value) => _db.name = value;

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  Future<List<PowerZone>> get powerZones async {
    final List<DbPowerZone> dbPowerZoneList =
        await _db.getDbPowerZones().orderBy('lowerLimit').toList();
    return dbPowerZoneList
        .map(PowerZone.exDb)
        .toList();
  }

  Future<void> addStrydZones() async {
    await PowerZone(
      powerZoneSchema: this,
      name: 'Easy',
      lowerPercentage: 65,
      upperPercentage: 80,
      color: Colors.lightGreen.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Moderate',
      lowerPercentage: 80,
      upperPercentage: 90,
      color: Colors.lightBlue.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Threshold',
      lowerPercentage: 90,
      upperPercentage: 100,
      color: Colors.yellow.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Interval',
      lowerPercentage: 100,
      upperPercentage: 115,
      color: Colors.orange.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Repetition',
      lowerPercentage: 115,
      upperPercentage: 130,
      color: Colors.red.value,
    ).save();
  }

  Future<void> addJimVanceZones() async {
    await PowerZone(
      powerZoneSchema: this,
      name: 'Walking',
      lowerPercentage: 0,
      upperPercentage: 81,
      color: Colors.grey.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Endurance',
      lowerPercentage: 81,
      upperPercentage: 88,
      color: Colors.lightGreen.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Tempo',
      lowerPercentage: 88,
      upperPercentage: 95,
      color: Colors.lightBlue.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Threshold',
      lowerPercentage: 95,
      upperPercentage: 105,
      color: Colors.yellow.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'High Intensity',
      lowerPercentage: 105,
      upperPercentage: 115,
      color: Colors.orange.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'VO2',
      lowerPercentage: 115,
      upperPercentage: 128,
      color: Colors.red.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Peak',
      lowerPercentage: 128,
      upperPercentage: 150,
      color: Colors.purple.value,
    ).save();
  }

  Future<void> addStefanDillingerZones() async {
    await PowerZone(
      powerZoneSchema: this,
      name: 'Z1',
      lowerPercentage: 70,
      upperPercentage: 80,
      color: Colors.lightBlue.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Z2',
      lowerPercentage: 80,
      upperPercentage: 88,
      color: Colors.lightGreen.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Z3',
      lowerPercentage: 88,
      upperPercentage: 95,
      color: Colors.yellow.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Z4',
      lowerPercentage: 95,
      upperPercentage: 105,
      color: Colors.orange.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Z5',
      lowerPercentage: 105,
      upperPercentage: 115,
      color: Colors.red.value,
    ).save();
    await PowerZone(
      powerZoneSchema: this,
      name: 'Z6',
      lowerPercentage: 115,
      upperPercentage: 130,
      color: Colors.purple.value,
    ).save();
  }

  @override
  String toString() => '< PowerZoneSchema | $name | $date >';

  static Future<PowerZoneSchema> getBy({int athletesId, DateTime date}) async {
    final List<DbPowerZoneSchema> dbPowerZoneSchemas = await DbPowerZoneSchema()
        .select()
        .athletesId
        .equals(athletesId)
        .and
        .date
        .lessThanOrEquals(date)
        .orderByDesc('date')
        .top(1)
        .toList();
    if (dbPowerZoneSchemas.isNotEmpty)
      return PowerZoneSchema._fromDb(dbPowerZoneSchemas.first);
    return null;
  }

  static PowerZoneSchema exDb(DbPowerZoneSchema db) =>
      PowerZoneSchema._fromDb(db);
}
