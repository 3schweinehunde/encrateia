import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbActivityTagging;
import 'package:sqfentity_gen/sqfentity_gen.dart';

class ActivityTagging {
  ActivityTagging({
    @required Activity activity,
    @required Tag tag,
    bool system,
  }) {
    _db = DbActivityTagging()
      ..activitiesId = activity.db.id
      ..tagsId = tag.id
      ..system = system ?? false;
  }

  ActivityTagging._fromDb(this._db);

  DbActivityTagging _db;

  int get activitiesId => _db.activitiesId;
  int get tagsId => _db.tagsId;

  static Future<ActivityTagging> createBy({
    @required Activity activity,
    @required Tag tag,
    bool system,
  }) async {
    final DbActivityTagging dbActivityTagging = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();

    if (dbActivityTagging != null)
      return ActivityTagging._fromDb(dbActivityTagging);
    else {
      final ActivityTagging activityTagging = ActivityTagging(
          activity: activity, tag: tag, system: system ?? false);
      await activityTagging._db.save();
      return activityTagging;
    }
  }

  static Future<ActivityTagging> getBy({
    @required Activity activity,
    @required Tag tag,
  }) async {
    final DbActivityTagging dbActivityTagging = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();
    if (dbActivityTagging != null)
      return ActivityTagging._fromDb(dbActivityTagging);
    return null;
  }

  static Future<void> deleteBy({
    @required Activity activity,
    @required Tag tag,
  }) async {
    final DbActivityTagging dbActivityTagging = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();
    await dbActivityTagging.delete();
  }

  @override
  String toString() =>
      '< ActivityTagging | actvityId $activitiesId | tagId $tagsId >';

  Future<BoolResult> delete() async => await _db.delete();

  static ActivityTagging exDb(DbActivityTagging db) => ActivityTagging._fromDb(db);
}
