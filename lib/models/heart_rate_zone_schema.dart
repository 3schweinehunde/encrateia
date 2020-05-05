import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';

class HeartRateZoneSchema extends ChangeNotifier {
  DbHeartRateZoneSchema db;

  HeartRateZoneSchema({@required Athlete athlete}) {
    db = DbHeartRateZoneSchema()
      ..athletesId = athlete.db.id
      ..base = 180
      ..name = "MySchema"
      ..date = DateTime.now();
  }
  HeartRateZoneSchema.fromDb(this.db);

  get heartRateZones => HeartRateZone.all(heartRateZoneSchema: this);

  HeartRateZoneSchema.likeGarmin({Athlete athlete}) {
    db = DbHeartRateZoneSchema()
      ..athletesId = athlete.db.id
      ..name = "like Garmin"
      ..date = DateTime(1970, 01, 01)
      ..base = 180;
  }

  addGarminZones() async {
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: "Warmup",
      lowerPercentage: 50,
      upperPercentage: 60,
      color: Colors.grey.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: "Easy",
      lowerPercentage: 60,
      upperPercentage: 70,
      color: Colors.blue.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: "Aerobic",
      lowerPercentage: 70,
      upperPercentage: 80,
      color: Colors.green.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: "Threshold",
      lowerPercentage: 80,
      upperPercentage: 90,
      color: Colors.orange.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: "Maximum",
      lowerPercentage: 90,
      upperPercentage: 100,
      color: Colors.red.value,
    ).db.save();
  }

  String toString() => '$db.date $db.name';

  delete() async {
    await this.db.delete();
  }

  static Future<List<HeartRateZoneSchema>> all({@required Athlete athlete}) async {
    var dbHeartRateZoneSchemaList =
    await athlete.db.getDbHeartRateZoneSchemas().orderByDesc('date').toList();
    var heartRateZoneSchemas = dbHeartRateZoneSchemaList
        .map((dbHeartRateZoneSchema) => HeartRateZoneSchema.fromDb(dbHeartRateZoneSchema))
        .toList();
    return heartRateZoneSchemas;
  }

  static getBy({
    int athletesId,
    DateTime date,
  }) async {
    var dbHeartRateZoneSchemas = await DbHeartRateZoneSchema()
        .select()
        .athletesId
        .equals(athletesId)
        .and
        .date
        .lessThanOrEquals(date)
        .orderByDesc("date")
        .top(1)
        .toList();
    if (dbHeartRateZoneSchemas.length != 0)
      return HeartRateZoneSchema.fromDb(dbHeartRateZoneSchemas.first);
  }
}
