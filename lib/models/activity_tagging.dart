import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbActivityTagging;

class ActivityTagging extends DbActivityTagging {
  ActivityTagging();

  ActivityTagging.by({
    @required Activity activity,
    @required Tag tag,
    bool system = false,
  }) : super(
          activitiesId: activity.db.id,
          tagsId: tag.id,
          system: system,
        );

  static Future<ActivityTagging> createBy({
    @required Activity activity,
    @required Tag tag,
    bool system,
  }) async {
    final ActivityTagging activityTagging = await ActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle() as ActivityTagging;

    if (activityTagging != null)
      return activityTagging;
    else {
      final ActivityTagging activityTagging = ActivityTagging.by(
        activity: activity,
        tag: tag,
        system: system ?? false,
      );
      await activityTagging.save();
      return activityTagging;
    }
  }

  static Future<ActivityTagging> getBy({
    @required Activity activity,
    @required Tag tag,
  }) async {
    final ActivityTagging activityTagging = await ActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle() as ActivityTagging;
    return activityTagging;
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
}
