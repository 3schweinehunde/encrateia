import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';

class ActivityTagging extends ChangeNotifier {
  DbActivityTagging db;

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

  static createBy({
    @required Activity activity,
    @required Tag tag,
    bool system,
  }) async {
    var dbActivityTagging = await DbActivityTagging()
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
      var activityTagging = ActivityTagging(
        activity: activity,
        tag: tag,
        system: system ?? false
      );
      await activityTagging.db.save();
      return activityTagging;
    }
  }

  static getBy({
    @required Activity activity,
    @required Tag tag,
  }) async {
    var dbActivityTagging = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .and
        .tagsId
        .equals(tag.db.id)
        .toSingle();
    if (dbActivityTagging != null)
      return ActivityTagging.fromDb(dbActivityTagging);
  }

  static deleteBy({
    @required Activity activity,
    @required Tag tag,
  }) async {
    var dbActivityTagging = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .and
        .tagsId
        .equals(tag.db.id)
        .toSingle();
    await dbActivityTagging.delete();
  }

  String toString() =>
      '< ActivityTagging | actvityId ${db.activitiesId} | tagId ${db.tagsId} >';

  delete() async {
    await this.db.delete();
  }
}
