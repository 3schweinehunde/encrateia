import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbPowerZone;
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class PowerZone {
  PowerZone(
      {@required PowerZoneSchema powerZoneSchema,
      String name,
      int lowerPercentage,
      int upperPercentage,
      int lowerLimit,
      int upperLimit,
      int color}) {
    db = DbPowerZone()
      ..powerZoneSchemataId = powerZoneSchema.id
      ..name = name ?? 'My Zone'
      ..lowerLimit = lowerLimit ?? 70
      ..upperLimit = upperLimit ?? 100
      ..lowerPercentage = lowerPercentage ?? 0
      ..upperPercentage = upperPercentage ?? 0
      ..color = color ?? 0xFFFFc107;

    if (lowerPercentage != null)
      db.lowerLimit = (lowerPercentage * powerZoneSchema.base / 100).round();
    if (upperPercentage != null)
      db.upperLimit = (upperPercentage * powerZoneSchema.base / 100).round();
  }

  PowerZone.fromDb(this.db);

  DbPowerZone db;

  @override
  String toString() => '< PowerZone | ${db.name} | ${db.lowerLimit} >';

  Future<BoolResult> delete() async => await db.delete();
}
