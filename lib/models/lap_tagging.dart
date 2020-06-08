import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbLapTagging ;

class LapTagging extends DbLapTagging {
  LapTagging();

  LapTagging.by({
    @required Lap lap,
    @required Tag tag,
    bool system = false,
  }) : super(
          lapsId: lap.db.id,
          tagsId: tag.id,
          system: system,
        );

  static Future<LapTagging> createBy({
    @required Lap lap,
    @required Tag tag,
    bool system,
  }) async {
    final LapTagging lapTagging = await LapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle() as LapTagging;

    if (lapTagging != null)
      return lapTagging;
    else {
      final LapTagging lapTagging = LapTagging.by(
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
    final LapTagging lapTagging = await LapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle() as LapTagging;
    return lapTagging;
  }

  static Future<void> deleteBy({
    @required Lap lap,
    @required Tag tag,
  }) async {
    final LapTagging lapTagging = await LapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle() as LapTagging;
    await lapTagging.delete();
  }

  @override
  String toString() =>
      '< LapTagging | lapId $lapsId | tagId $tagsId >';
}
