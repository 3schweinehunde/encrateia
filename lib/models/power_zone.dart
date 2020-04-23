import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/power_zone_schema.dart';

class PowerZone extends ChangeNotifier {
  DbPowerZone db;

  PowerZone(
      {PowerZoneSchema powerZoneSchema,
      String name,
      int lowerPercentage,
      int upperPercentage,
      int lowerLimit,
      int upperLimit}) {
    db = DbPowerZone()
      ..powerZoneSchemataId = powerZoneSchema.db.id
      ..lowerLimit = lowerLimit ?? 0
      ..upperLimit = upperLimit ?? 0
      ..lowerPercentage = lowerPercentage ?? 0
      ..upperPercentage = upperPercentage ?? 0;

    if (lowerPercentage != null)
      db.lowerLimit = (lowerPercentage * powerZoneSchema.db.base / 100).round();
    if (upperPercentage != null)
      db.upperLimit = (upperPercentage * powerZoneSchema.db.base / 100).round();
  }
  PowerZone.fromDb(this.db);

  String toString() => '$db.date $db.name';

  delete() async {
    await this.db.delete();
  }

  static Future<List<PowerZone>> all(
      {@required PowerZoneSchema powerZoneSchema}) async {
    var dbPowerZoneList = await powerZoneSchema.db
        .getDbPowerZones()
        .orderByDesc('lowerlimit')
        .toList();
    var powerZones = dbPowerZoneList
        .map((dbPowerZone) => PowerZone.fromDb(dbPowerZone))
        .toList();
    return powerZones;
  }
}
