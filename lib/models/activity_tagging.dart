import 'package:sqfentity_gen/sqfentity_gen.dart';

import '/model/model.dart' show DbActivityTagging;
import '/models/activity.dart';
import '/models/tag.dart';

class ActivityTagging {
  ActivityTagging({
    required Activity activity,
    required Tag tag,
    bool? system,
  }) {
    _db = DbActivityTagging()
      ..activitiesId = activity.id
      ..tagsId = tag.id
      ..system = system ?? false;
  }

  ActivityTagging._fromDb(this._db);

  DbActivityTagging? _db;

  int? get id => _db?.id;
  int? get activitiesId => _db!.activitiesId;
  int? get tagsId => _db!.tagsId;

  static Future<ActivityTagging> createBy({
    required Activity activity,
    required Tag tag,
    bool? system,
  }) async {
    final DbActivityTagging? dbActivityTagging = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();

    if (dbActivityTagging != null) {
      return ActivityTagging._fromDb(dbActivityTagging);
    } else {
      final ActivityTagging activityTagging = ActivityTagging(
          activity: activity, tag: tag, system: system ?? false);
      await activityTagging._db!.save();
      return activityTagging;
    }
  }

  static Future<ActivityTagging?> getBy({
    required Activity activity,
    required Tag tag,
  }) async {
    final DbActivityTagging? dbActivityTagging = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();
    if (dbActivityTagging != null) {
      return ActivityTagging._fromDb(dbActivityTagging);
    }
    return null;
  }

  static Future<void> deleteBy({
    required Activity activity,
    required Tag tag,
  }) async {
    final DbActivityTagging dbActivityTagging = await (DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle() as FutureOr<DbActivityTagging>);
    await dbActivityTagging.delete();
  }

  @override
  String toString() =>
      '< ActivityTagging | actvityId $activitiesId | tagId $tagsId >';

  Future<BoolResult> delete() async => await _db!.delete();

  static ActivityTagging exDb(DbActivityTagging db) =>
      ActivityTagging._fromDb(db);
}
