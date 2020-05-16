import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';

class HeartRateZone extends ChangeNotifier {
  DbHeartRateZone db;

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
      ..name = name ?? "My Zone"
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

  String toString() => '< HeartRateZone | ${db.name} | ${db.lowerLimit} >';

  delete() async {
    await this.db.delete();
  }

  static Future<List<HeartRateZone>> all(
      {@required HeartRateZoneSchema heartRateZoneSchema}) async {
    var dbHeartRateZoneList = await heartRateZoneSchema.db
        .getDbHeartRateZones()
        .orderByDesc('lowerlimit')
        .toList();
    var heartRateZones = dbHeartRateZoneList
        .map((dbHeartRateZone) => HeartRateZone.fromDb(dbHeartRateZone))
        .toList();
    return heartRateZones;
  }
}
