import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class Weight extends ChangeNotifier {
  Weight({@required Athlete athlete}) {
    db = DbWeight()
      ..athletesId = athlete.db.id
      ..value = 70
      ..date = DateTime.now();
  }
  Weight.fromDb(this.db);

  DbWeight db;

  @override
  String toString() => '< Weight | ${db.date} | ${db.value} >';

  Future<BoolResult> delete() async => await db.delete();

  static Future<List<Weight>> all({@required Athlete athlete}) async {
    final List<DbWeight> dbWeightList =
        await athlete.db.getDbWeights().orderByDesc('date').toList();
    final List<Weight> weights = dbWeightList
        .map((DbWeight dbWeight) => Weight.fromDb(dbWeight))
        .toList();
    return weights;
  }

  static Future<Weight> getBy({int athletesId, DateTime date}) async {
    final List<DbWeight> dbWeights = await DbWeight()
        .select()
        .athletesId
        .equals(athletesId)
        .and
        .date
        .lessThanOrEquals(date)
        .orderByDesc('date')
        .top(1)
        .toList();
    return dbWeights.isNotEmpty ? Weight.fromDb(dbWeights.first) : null;
  }
}
