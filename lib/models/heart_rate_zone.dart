import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbHeartRateZone;
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class HeartRateZone {
  HeartRateZone(
      {@required HeartRateZoneSchema heartRateZoneSchema,
      String name,
      int lowerPercentage,
      int upperPercentage,
      int lowerLimit,
      int upperLimit,
      int color}) {
    _db = DbHeartRateZone()
      ..heartRateZoneSchemataId = heartRateZoneSchema.id
      ..name = name ?? 'My Zone'
      ..lowerLimit = lowerLimit ?? 70
      ..upperLimit = upperLimit ?? 100
      ..lowerPercentage = lowerPercentage ?? 0
      ..upperPercentage = upperPercentage ?? 0
      ..color = color ?? 0xFFFFc107;

    if (lowerPercentage != null)
      lowerLimit = (lowerPercentage * heartRateZoneSchema.base / 100).round();
    if (upperPercentage != null)
      upperLimit = (upperPercentage * heartRateZoneSchema.base / 100).round();
  }
  HeartRateZone._fromDb(this._db);

  DbHeartRateZone _db;

  int get id => _db?.id;
  int get color => _db.color;
  String get name => _db.name;
  int get lowerLimit => _db.lowerLimit;
  int get upperLimit => _db.upperLimit;
  int get lowerPercentage => _db.lowerPercentage;
  int get upperPercentage => _db.upperPercentage;
  set color(int value) => _db.color = value;
  set name(String value) => _db.name = value;
  set lowerLimit(int value) => _db.lowerLimit = value;
  set upperLimit(int value) => _db.upperLimit = value;
  set lowerPercentage(int value) => _db.lowerPercentage = value;
  set upperPercentage(int value) => _db.upperPercentage = value;
  set heartRateZoneSchemataId(int value) => _db.heartRateZoneSchemataId = value;
  set id(int value) => _db.id = value;

  @override
  String toString() => '< HeartRateZone | $name | $lowerLimit >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Future<BoolCommitResult> upsertAll(
      List<HeartRateZone> heartRateZones) async {
    return await DbHeartRateZone().upsertAll(heartRateZones
        .map((HeartRateZone heartRateZone) => heartRateZone._db)
        .toList());
  }

  static HeartRateZone exDb(DbHeartRateZone db) => HeartRateZone._fromDb(db);
}
