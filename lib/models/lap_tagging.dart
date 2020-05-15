import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';

class LapTagging extends ChangeNotifier {
  DbLapTagging db;

  LapTagging({
    @required Lap lap,
    @required Tag tag,
  }) {
    db = DbLapTagging()
      ..lapsId = lap.db.id
      ..tagsId = tag.db.id
      ..system = false;
  }

  LapTagging.fromDb(this.db);

  static createBy({
    @required Lap lap,
    @required Tag tag,
  }) async {
    var dbLapTagging = await DbLapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .and
        .tagsId
        .equals(tag.db.id)
        .toSingle();

    if (dbLapTagging != null)
      return LapTagging.fromDb(dbLapTagging);
    else {
      var lapTagging = LapTagging(
        lap: lap,
        tag: tag,
      );
      await lapTagging.db.save();
      return lapTagging;
    }
  }

  static getBy({
    @required Lap lap,
    @required Tag tag,
  }) async {
    var dbLapTagging = await DbLapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .and
        .tagsId
        .equals(tag.db.id)
        .toSingle();
    if (dbLapTagging != null)
      return LapTagging.fromDb(dbLapTagging);
  }

  static deleteBy({
    @required Lap lap,
    @required Tag tag,
  }) async {
    var dbLapTagging = await DbLapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .and
        .tagsId
        .equals(tag.db.id)
        .toSingle();
    await dbLapTagging.delete();
  }

  String toString() =>
      '< LapTagging | lapId ${db.lapsId} | tagId ${db.tagsId} >';

  delete() async {
    await this.db.delete();
  }
}
