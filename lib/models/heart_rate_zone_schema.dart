import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class HeartRateZoneSchema extends ChangeNotifier {
  HeartRateZoneSchema({@required Athlete athlete}) {
    db = DbHeartRateZoneSchema()
      ..athletesId = athlete.db.id
      ..base = 180
      ..name = 'My Schema'
      ..date = DateTime.now();
  }
  HeartRateZoneSchema.fromDb(this.db);

  HeartRateZoneSchema.likeGarmin({Athlete athlete}) {
    db = DbHeartRateZoneSchema()
      ..athletesId = athlete.db.id
      ..name = 'max HR based'
      ..date = DateTime(1970, 01, 01)
      ..base = 180;
  }

  HeartRateZoneSchema.likeStefanDillinger({Athlete athlete}) {
    db = DbHeartRateZoneSchema()
      ..athletesId = athlete.db.id
      ..name = 'threshold heart rate based'
      ..date = DateTime(1970, 01, 01)
      ..base = 165;
  }

  DbHeartRateZoneSchema db;
  Future<List<HeartRateZone>> get heartRateZones async =>
      HeartRateZone.all(heartRateZoneSchema: this);

  Future<void> addGarminZones() async {
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Warmup',
      lowerPercentage: 50,
      upperPercentage: 60,
      color: Colors.grey.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Easy',
      lowerPercentage: 60,
      upperPercentage: 70,
      color: Colors.blue.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Aerobic',
      lowerPercentage: 70,
      upperPercentage: 80,
      color: Colors.green.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Threshold',
      lowerPercentage: 80,
      upperPercentage: 90,
      color: Colors.orange.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Maximum',
      lowerPercentage: 90,
      upperPercentage: 100,
      color: Colors.red.value,
    ).db.save();
  }

  Future<void> addStefanDillingerZones() async {
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z1',
      lowerPercentage: 70,
      upperPercentage: 80,
      color: Colors.grey.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z2',
      lowerPercentage: 80,
      upperPercentage: 88,
      color: Colors.blue.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z3',
      lowerPercentage: 88,
      upperPercentage: 95,
      color: Colors.green.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z4',
      lowerPercentage: 95,
      upperPercentage: 100,
      color: Colors.orange.value,
    ).db.save();
    await HeartRateZone(
      heartRateZoneSchema: this,
      name: 'Z5/6',
      lowerPercentage: 100,
      upperPercentage: 115,
      color: Colors.red.value,
    ).db.save();
  }

  @override
  String toString() => '< HeartRateZoneSchema | ${db.name} | ${db.date} >';

  Future<BoolResult> delete() async => await db.delete();

  static Future<List<HeartRateZoneSchema>> all(
      {@required Athlete athlete}) async {
    final List<DbHeartRateZoneSchema> dbHeartRateZoneSchemaList = await athlete
        .db
        .getDbHeartRateZoneSchemas()
        .orderByDesc('date')
        .toList();
    final List<HeartRateZoneSchema> heartRateZoneSchemas =
        dbHeartRateZoneSchemaList
            .map((DbHeartRateZoneSchema dbHeartRateZoneSchema) =>
                HeartRateZoneSchema.fromDb(dbHeartRateZoneSchema))
            .toList();
    return heartRateZoneSchemas;
  }

  static Future<HeartRateZoneSchema> getBy({
    int athletesId,
    DateTime date,
  }) async {
    final List<DbHeartRateZoneSchema> dbHeartRateZoneSchemas =
        await DbHeartRateZoneSchema()
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
      return HeartRateZoneSchema.fromDb(dbHeartRateZoneSchemas.first);
    return null;
  }
}
