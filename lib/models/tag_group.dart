import 'package:encrateia/models/tag.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart'
    show DbActivityTagging, DbLapTagging, DbTag, DbTagGroup;
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart' show BoolResult;
import 'lap.dart';

class TagGroup {
  TagGroup({@required Athlete athlete}) {
    _db = DbTagGroup()
      ..athletesId = athlete.db.id
      ..color = Colors.lightGreen.value
      ..system = false
      ..name = 'My Tag Group';
  }

  TagGroup.fromDb(this._db);

  TagGroup.by(
      {@required Athlete athlete,
      @required String name,
      @required bool system,
      @required int color}) {
    _db = DbTagGroup()
      ..athletesId = athlete.db.id
      ..color = color
      ..system = system
      ..name = name;
  }

  DbTagGroup _db;
  List<Tag> cachedTags;

  int get id => _db.id;
  int get color => _db.color;
  String get name => _db.name;
  bool get system => _db.system;
  set color(int value) => _db.color = value;
  set name(String value) => _db.name = value;

  Future<List<Tag>> get tags async {
    final List<DbTag> dbTags =
        await _db.getDbTags().orderBy('sortOrder').orderBy('name').toList();
    return dbTags.map((DbTag dbTag) => Tag.fromDb(dbTag)).toList();
  }

  @override
  String toString() => '< Taggroup | ${_db.name} >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Future<TagGroup> autoPowerTagGroup({@required Athlete athlete}) async {
    final DbTagGroup dbTagGroup = await DbTagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.db.id)
        .and
        .name
        .equals('Auto Power Zones')
        .toSingle();
    if (dbTagGroup != null)
      return TagGroup.fromDb(dbTagGroup);
    else {
      final TagGroup autoPowerTagGroup = TagGroup.by(
        name: 'Auto Power Zones',
        athlete: athlete,
        system: true,
        color: MyColor.bitterSweet.value,
      );
      await autoPowerTagGroup._db.save();
      return autoPowerTagGroup;
    }
  }

  static Future<TagGroup> autoHeartRateTagGroup(
      {@required Athlete athlete}) async {
    final DbTagGroup dbTagGroup = await DbTagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.db.id)
        .and
        .name
        .equals('Auto Heart Rate Zones')
        .toSingle();
    if (dbTagGroup != null)
      return TagGroup.fromDb(dbTagGroup);
    else {
      final TagGroup autoHeartRateTagGroup = TagGroup.by(
        name: 'Auto Heart Rate Zones',
        athlete: athlete,
        system: true,
        color: MyColor.grapeFruit.value,
      );
      await autoHeartRateTagGroup._db.save();
      return autoHeartRateTagGroup;
    }
  }

  static Future<List<TagGroup>> includingActivityTaggings({
    @required Athlete athlete,
    @required Activity activity,
  }) async {
    final List<TagGroup> tagGroups = await all(athlete: athlete);

    final List<DbActivityTagging> dbActivityTaggings = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .toList();
    final Iterable<int> selectedTagIds = dbActivityTaggings
        .map((DbActivityTagging dbActivityTagging) => dbActivityTagging.tagsId);

    for (final TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
      for (final Tag tag in tagGroup.cachedTags) {
        tag.selected = selectedTagIds.contains(tag.db.id);
      }
    }
    return tagGroups;
  }

  static Future<List<TagGroup>> includingLapTaggings({
    @required Athlete athlete,
    @required Lap lap,
  }) async {
    final List<TagGroup> tagGroups = await all(athlete: athlete);

    final List<DbLapTagging> dbLapTaggings =
        await DbLapTagging().select().lapsId.equals(lap.db.id).toList();

    final Iterable<int> selectedTagIds =
        dbLapTaggings.map((DbLapTagging dbLapTagging) => dbLapTagging.tagsId);

    for (final TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
      for (final Tag tag in tagGroup.cachedTags) {
        tag.selected = selectedTagIds.contains(tag.db.id);
      }
    }
    return tagGroups;
  }

  static Future<List<TagGroup>> all({@required Athlete athlete}) async {
    final List<DbTagGroup> dbTagGroupList =
        await athlete.db.getDbTagGroups().orderBy('name').toList();
    final List<TagGroup> tagGroups = dbTagGroupList
        .map((DbTagGroup dbTagGroup) => TagGroup.fromDb(dbTagGroup))
        .toList();

    for (final TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
    }
    return tagGroups;
  }

  static Future<void> deleteAllAutoTags({Athlete athlete}) async {
    final TagGroup autoPowerTagGroup =
        await TagGroup.autoPowerTagGroup(athlete: athlete);
    await autoPowerTagGroup._db.getDbTags().delete();

    final TagGroup autoHeartRateTagGroup =
        await TagGroup.autoHeartRateTagGroup(athlete: athlete);
    await autoHeartRateTagGroup._db.getDbTags().delete();
  }
}
