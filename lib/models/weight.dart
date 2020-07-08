import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class Weight {
  Weight({@required Athlete athlete}) {
    _db = DbWeight()
      ..athletesId = athlete.id
      ..value = 70
      ..date = DateTime.now();
  }
  Weight._fromDb(this._db);

  DbWeight _db;

  int get id => _db?.id;
  DateTime get date => _db.date;
  double get value => _db.value;

  set date(DateTime value) => _db.date = value;
  set value(double value) => _db.value = value;

  @override
  String toString() => '< Weight | $date | $value >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Future<Weight> getBy({int athletesId, DateTime date}) async {
    List<DbWeight> dbWeights;

    dbWeights = await DbWeight()
        .select()
        .athletesId
        .equals(athletesId)
        .and
        .date
        .lessThanOrEquals(date)
        .orderByDesc('date')
        .top(1)
        .toList();
    if (dbWeights.isNotEmpty)
      return Weight._fromDb(dbWeights.first);
    else
      dbWeights = await DbWeight()
          .select()
          .athletesId
          .equals(athletesId)
          .orderBy('date')
          .top(1)
          .toList();
    return (dbWeights.isNotEmpty) ? Weight._fromDb(dbWeights.first) : null;
  }

  static Weight exDb(DbWeight db) => Weight._fromDb(db);
}
