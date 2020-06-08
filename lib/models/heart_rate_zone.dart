import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbHeartRateZone;
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class HeartRateZone extends ChangeNotifier {
  HeartRateZone(
      {@required HeartRateZoneSchema heartRateZoneSchema,
      String name,
      int lowerPercentage,
      int upperPercentage,
      int lowerLimit,
      int upperLimit,
      int color}) {
    db = DbHeartRateZone()
      ..heartRateZoneSchemataId = heartRateZoneSchema.db.id
      ..name = name ?? 'My Zone'
      ..lowerLimit = lowerLimit ?? 70
      ..upperLimit = upperLimit ?? 100
      ..lowerPercentage = lowerPercentage ?? 0
      ..upperPercentage = upperPercentage ?? 0
      ..color = color ?? 0xFFFFc107;

    if (lowerPercentage != null)
      db.lowerLimit =
          (lowerPercentage * heartRateZoneSchema.db.base / 100).round();
    if (upperPercentage != null)
      db.upperLimit =
          (upperPercentage * heartRateZoneSchema.db.base / 100).round();
  }
  HeartRateZone.fromDb(this.db);

  DbHeartRateZone db;

  @override
  String toString() => '< HeartRateZone | ${db.name} | ${db.lowerLimit} >';

  Future<BoolResult> delete() async => await db.delete();

  static Future<List<HeartRateZone>> all(
      {@required HeartRateZoneSchema heartRateZoneSchema}) async {
    final List<DbHeartRateZone> dbHeartRateZoneList = await heartRateZoneSchema
        .db
        .getDbHeartRateZones()
        .orderByDesc('lowerlimit')
        .toList();
    final List<HeartRateZone> heartRateZones = dbHeartRateZoneList
        .map((DbHeartRateZone dbHeartRateZone) =>
            HeartRateZone.fromDb(dbHeartRateZone))
        .toList();
    return heartRateZones;
  }
}
