import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbLapTagging;
import 'package:sqfentity_gen/sqfentity_gen.dart';

class LapTagging {
  LapTagging({
    @required Lap lap,
    @required Tag tag,
    bool system,
  }) {
    _db = DbLapTagging()
      ..lapsId = lap.db.id
      ..tagsId = tag.id
      ..system = system ?? false;
  }

  LapTagging.fromDb(this._db);

  DbLapTagging _db;

  int get lapsId => _db.lapsId;
  int get tagsId => _db.tagsId;

  @override
  String toString() =>
      '< LapTagging | lapId $lapsId | tagId $tagsId >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Future<LapTagging> createBy({
    @required Lap lap,
    @required Tag tag,
    bool system,
  }) async {
    final DbLapTagging dbLapTagging = await DbLapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();

    if (dbLapTagging != null)
      return LapTagging.fromDb(dbLapTagging);
    else {
      final LapTagging lapTagging = LapTagging(
        lap: lap,
        tag: tag,
        system: system ?? false,
      );
      await lapTagging.save();
      return lapTagging;
    }
  }

  static Future<LapTagging> getBy({
    @required Lap lap,
    @required Tag tag,
  }) async {
    final DbLapTagging dbLapTagging = await DbLapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();
    return (dbLapTagging != null) ? LapTagging.fromDb(dbLapTagging) : null;
  }

  static Future<void> deleteBy({
    @required Lap lap,
    @required Tag tag,
  }) async {
    final DbLapTagging dbLapTagging = await DbLapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();
    await dbLapTagging.delete();
  }
}
