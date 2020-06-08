import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbLapTagging;
import 'package:sqfentity_gen/sqfentity_gen.dart';

class LapTagging extends ChangeNotifier {
  LapTagging({
    @required Lap lap,
    @required Tag tag,
    bool system,
  }) {
    db = DbLapTagging()
      ..lapsId = lap.db.id
      ..tagsId = tag.db.id
      ..system = system ?? false;
  }

  LapTagging.fromDb(this.db);

  DbLapTagging db;

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
        .equals(tag.db.id)
        .toSingle();

    if (dbLapTagging != null)
      return LapTagging.fromDb(dbLapTagging);
    else {
      final LapTagging lapTagging = LapTagging(
        lap: lap,
        tag: tag,
        system: system ?? false,
      );
      await lapTagging.db.save();
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
        .equals(tag.db.id)
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
        .equals(tag.db.id)
        .toSingle();
    await dbLapTagging.delete();
  }

  @override
  String toString() =>
      '< LapTagging | lapId ${db.lapsId} | tagId ${db.tagsId} >';

  Future<BoolResult> delete() async => await db.delete();
}
