import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';

class Weight extends ChangeNotifier {
  DbWeight db;

  Weight({@required Athlete athlete}) {
    db = DbWeight()
      ..athletesId = athlete.db.id
      ..value = 70
      ..date = DateTime.now();
  }
  Weight.fromDb(this.db);

  String toString() => '$db.date $db.value';

  delete() async {
    await this.db.delete();
  }

  static Future<List<Weight>> all({@required Athlete athlete}) async {
    var dbWeightList =
        await athlete.db.getDbWeights().orderByDesc('date').toList();
    var weights =
        dbWeightList.map((dbWeight) => Weight.fromDb(dbWeight)).toList();
    return weights;
  }
}