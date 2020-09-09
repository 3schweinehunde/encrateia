import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbIntervalTagging;
import 'package:sqfentity_gen/sqfentity_gen.dart';

class IntervalTagging {
  IntervalTagging({
    @required encrateia.Interval interval,
    @required Tag tag,
    bool system,
  }) {
    _db = DbIntervalTagging()
      ..intervalsId = interval.id
      ..tagsId = tag.id
      ..system = system ?? false;
  }

  IntervalTagging._fromDb(this._db);

  DbIntervalTagging _db;

  int get id => _db?.id;
  int get intervalsId => _db.intervalsId;
  int get tagsId => _db.tagsId;

  @override
  String toString() =>
      '< IntervalTagging | intervalId $intervalsId | tagId $tagsId >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Future<IntervalTagging> createBy({
    @required encrateia.Interval interval,
    @required Tag tag,
    bool system,
  }) async {
    final DbIntervalTagging dbIntervalTagging = await DbIntervalTagging()
        .select()
        .intervalsId
        .equals(interval.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();

    if (dbIntervalTagging != null)
      return IntervalTagging._fromDb(dbIntervalTagging);
    else {
      final IntervalTagging intervalTagging = IntervalTagging(
        interval: interval,
        tag: tag,
        system: system ?? false,
      );
      await intervalTagging.save();
      return intervalTagging;
    }
  }

  static Future<IntervalTagging> getBy({
    @required encrateia.Interval interval,
    @required Tag tag,
  }) async {
    final DbIntervalTagging dbIntervalTagging = await DbIntervalTagging()
        .select()
        .intervalsId
        .equals(interval.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();
    return (dbIntervalTagging != null)
        ? IntervalTagging._fromDb(dbIntervalTagging)
        : null;
  }

  static Future<void> deleteBy({
    @required encrateia.Interval interval,
    @required Tag tag,
  }) async {
    final DbIntervalTagging dbIntervalTagging = await DbIntervalTagging()
        .select()
        .intervalsId
        .equals(interval.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();
    await dbIntervalTagging.delete();
  }

  static IntervalTagging exDb(DbIntervalTagging db) =>
      IntervalTagging._fromDb(db);
}
