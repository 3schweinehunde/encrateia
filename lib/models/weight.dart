import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class Weight {
  Weight({@required Athlete athlete}) {
    _db = DbWeight()
      ..athletesId = athlete.db.id
      ..value = 70
      ..date = DateTime.now();
  }
  Weight.fromDb(this._db);

  DbWeight _db;

  int get id => _db.id;
  DateTime get date => _db.date;
  double get value => _db.value;
  set date(DateTime value) => _db.date = value;
  set value(double value) => _db.value = value;

  @override
  String toString() => '< Weight | $date | $value >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

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
