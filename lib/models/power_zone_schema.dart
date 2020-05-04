import 'package:encrateia/models/power_zone.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';

class PowerZoneSchema extends ChangeNotifier {
  DbPowerZoneSchema db;

  PowerZoneSchema({@required Athlete athlete}) {
    db = DbPowerZoneSchema()
      ..athletesId = athlete.db.id
      ..base = 250
      ..name = "MySchema"
      ..date = DateTime.now();
  }
  PowerZoneSchema.fromDb(this.db);

  get powerZones => PowerZone.all(powerZoneSchema: this);

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
      color: Colors.lightGreen.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Moderate",
      lowerPercentage: 80,
      upperPercentage: 90,
      color: Colors.lightBlue.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Threshold",
      lowerPercentage: 90,
      upperPercentage: 100,
      color: Colors.yellow.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Interval",
      lowerPercentage: 100,
      upperPercentage: 115,
      color: Colors.orange.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Repetition",
      lowerPercentage: 115,
      upperPercentage: 130,
      color: Colors.red.value,
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
      color: Colors.grey.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Endurance",
      lowerPercentage: 81,
      upperPercentage: 88,
      color: Colors.lightGreen.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Tempo",
      lowerPercentage: 88,
      upperPercentage: 95,
      color: Colors.lightBlue.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Threshold",
      lowerPercentage: 95,
      upperPercentage: 105,
      color: Colors.yellow.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "High Intensity",
      lowerPercentage: 105,
      upperPercentage: 115,
      color: Colors.orange.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "VO2",
      lowerPercentage: 115,
      upperPercentage: 128,
      color: Colors.red.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Peak",
      lowerPercentage: 128,
      upperPercentage: 150,
      color: Colors.purple.value,
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
      name: "Z1",
      lowerPercentage: 70,
      upperPercentage: 80,
      color: Colors.lightBlue.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Z2",
      lowerPercentage: 80,
      upperPercentage: 88,
      color: Colors.lightGreen.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Z3",
      lowerPercentage: 88,
      upperPercentage: 95,
      color: Colors.yellow.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Z4",
      lowerPercentage: 95,
      upperPercentage: 105,
      color: Colors.orange.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Z5",
      lowerPercentage: 105,
      upperPercentage: 115,
      color: Colors.red.value,
    ).db.save();
    await PowerZone(
      powerZoneSchema: this,
      name: "Z6",
      lowerPercentage: 115,
      upperPercentage: 130,
      color: Colors.purple.value,
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

  static getBy({
    int athletesId,
    DateTime date,
  }) async {
    var dbPowerZoneSchemas = await DbPowerZoneSchema()
        .select()
        .athletesId
        .equals(athletesId)
        .and
        .date
        .lessThanOrEquals(date)
        .orderByDesc("date")
        .top(1)
        .toList();
    if (dbPowerZoneSchemas.length != 0)
      return PowerZoneSchema.fromDb(dbPowerZoneSchemas.first);
    else return null;
  }
}
