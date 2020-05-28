import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class ActivityTagging extends ChangeNotifier {
  ActivityTagging({
    @required Activity activity,
    @required Tag tag,
    bool system,
  }) {
    db = DbActivityTagging()
      ..activitiesId = activity.db.id
      ..tagsId = tag.db.id
      ..system = system ?? false;
  }

  ActivityTagging.fromDb(this.db);

  DbActivityTagging db;

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
        .equals(tag.db.id)
        .toSingle();

    if (dbActivityTagging != null)
      return ActivityTagging.fromDb(dbActivityTagging);
    else {
      final ActivityTagging activityTagging = ActivityTagging(
          activity: activity, tag: tag, system: system ?? false);
      await activityTagging.db.save();
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
        .equals(tag.db.id)
        .toSingle();
    if (dbActivityTagging != null)
      return ActivityTagging.fromDb(dbActivityTagging);
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
        .equals(tag.db.id)
        .toSingle();
    await dbActivityTagging.delete();
  }

  @override
  String toString() =>
      '< ActivityTagging | actvityId ${db.activitiesId} | tagId ${db.tagsId} >';

  Future<BoolResult> delete() async => await db.delete();
}
