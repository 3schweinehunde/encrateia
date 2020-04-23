import 'package:encrateia/models/power_zone.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';

class PowerZoneSchema extends ChangeNotifier {
  DbPowerZoneSchema db;

  PowerZoneSchema() {
    db = DbPowerZoneSchema();
  }
  PowerZoneSchema.fromDb(this.db);

  PowerZoneSchema.likeStryd({Athlete athlete}) {
    db = DbPowerZoneSchema()
      ..athletesId = athlete.db.id
      ..name = "like Stryd"
      ..date = DateTime(1970, 01, 01)
      ..base = 250;
  }

  addStrydZones() async {
    await PowerZone(
      powerZoneSchema: this,
      name: "Easy",
      lowerPercentage: 65,
      upperPercentage: 80,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Moderate",
      lowerPercentage: 80,
      upperPercentage: 90,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Threshold",
      lowerPercentage: 90,
      upperPercentage: 100,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Interval",
      lowerPercentage: 100,
      upperPercentage: 115,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Repetition",
      lowerPercentage: 115,
      upperPercentage: 130,
    ).db.save();
  }

  // https://www.velopress.com/jim-vances-running-power-zones/
  PowerZoneSchema.likeJimVance({Athlete athlete}) {
    db = DbPowerZoneSchema()
      ..athletesId = athlete.db.id
      ..name = "like Jim Vance"
      ..date = DateTime(1970, 01, 01)
      ..base = 250;
  }

  addJimVanceZones() async {
    await PowerZone(
      powerZoneSchema: this,
      name: "Walking",
      lowerPercentage: 0,
      upperPercentage: 81,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Endurance",
      lowerPercentage: 81,
      upperPercentage: 88,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Tempo",
      lowerPercentage: 88,
      upperPercentage: 95,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Threshold",
      lowerPercentage: 95,
      upperPercentage: 105,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "High Intensity",
      lowerPercentage: 105,
      upperPercentage: 115,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "VO2",
      lowerPercentage: 115,
      upperPercentage: 128,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Peak",
      lowerPercentage: 128,
      upperPercentage: 150,
    ).db.save();
  }

  PowerZoneSchema.likeStefanDillinger({Athlete athlete}) {
    db = DbPowerZoneSchema()
      ..athletesId = athlete.db.id
      ..name = "like Stefan Dillinger"
      ..date = DateTime(1970, 01, 01)
      ..base = 250;
  }

  addStefanDillingerZones() async {
    await PowerZone(
      powerZoneSchema: this,
      name: "GA1",
      lowerPercentage: 70,
      upperPercentage: 80,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "GA2",
      lowerPercentage: 80,
      upperPercentage: 90,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "SL",
      lowerPercentage: 90,
      upperPercentage: 100,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Int",
      lowerPercentage: 100,
      upperPercentage: 110,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "FSB",
      lowerPercentage: 110,
      upperPercentage: 120,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "MRT",
      lowerPercentage: 85,
      upperPercentage: 90,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "HMRT",
      lowerPercentage: 90,
      upperPercentage: 98,
    ).db.save();
  }

  String toString() => '$db.date $db.name';

  delete() async {
    await this.db.delete();
  }

  static Future<List<PowerZoneSchema>> all({@required Athlete athlete}) async {
    var dbPowerZoneSchemaList =
        await athlete.db.getDbPowerZoneSchemas().orderByDesc('date').toList();
    var powerZoneSchemas = dbPowerZoneSchemaList
        .map((dbPowerZoneSchema) => PowerZoneSchema.fromDb(dbPowerZoneSchema))
        .toList();
    return powerZoneSchemas;
  }
}
