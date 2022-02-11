import 'package:flutter/material.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart'
    show BoolCommitResult, BoolResult;

import '/model/model.dart'
    show DbActivityTagging, DbIntervalTagging, DbLapTagging, DbTag;
import '/models/tag_group.dart';
import 'activity.dart';
import 'athlete.dart';
import 'interval.dart' as encrateia;
import 'lap.dart';

class Tag {
  Tag({
    @required TagGroup tagGroup,
    String name,
    int color,
    int sortOrder,
  }) {
    _db = DbTag()
      ..tagGroupsId = tagGroup.id
      ..sortOrder = sortOrder ?? 0
      ..name = name ?? 'my Tag'
      ..color = color ?? 0xFFFFc107;
  }
  Tag._fromDb(this._db);

  DbTag _db;
  bool selected = false;

  int get id => _db?.id;
  int get tagGroupsId => _db.tagGroupsId;
  String get name => _db.name;
  bool get system => _db.system;
  int get color => _db.color;

  set color(int value) => _db.color = value;
  set name(String value) => _db.name = value;

  @override
  String toString() => '< Tag | $name >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Future<List<Tag>> allByActivity({@required Activity activity}) async {
    final List<DbActivityTagging> dbActivityTaggings = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.id)
        .toList();
    if (dbActivityTaggings.isNotEmpty) {
      final List<int> tagIds = dbActivityTaggings
          .map(
              (DbActivityTagging dbActivityTagging) => dbActivityTagging.tagsId)
          .toList();
      final List<DbTag> dbTags = await DbTag()
          .select()
          .id
          .inValues(tagIds)
          .orderBy('tagGroupsId')
          .toList();
      final List<Tag> tags = dbTags.map(Tag.exDb).toList();
      return tags;
    } else {
      return <Tag>[];
    }
  }

  static Future<List<Tag>> allByLap({@required Lap lap}) async {
    final List<DbLapTagging> dbLapTaggings =
        await DbLapTagging().select().lapsId.equals(lap.id).toList();
    if (dbLapTaggings.isNotEmpty) {
      final List<int> tagIds = dbLapTaggings
          .map((DbLapTagging dbLapTagging) => dbLapTagging.tagsId)
          .toList();
      final List<DbTag> dbTags = await DbTag()
          .select()
          .id
          .inValues(tagIds)
          .orderBy('tagGroupsId')
          .toList();
      final List<Tag> tags = dbTags.map(Tag.exDb).toList();
      return tags;
    } else {
      return <Tag>[];
    }
  }

  static Future<List<Tag>> allByInterval(
      {@required encrateia.Interval interval}) async {
    final List<DbIntervalTagging> dbIntervalTaggings = await DbIntervalTagging()
        .select()
        .intervalsId
        .equals(interval.id)
        .toList();
    if (dbIntervalTaggings.isNotEmpty) {
      final List<int> tagIds = dbIntervalTaggings
          .map(
              (DbIntervalTagging dbIntervalTagging) => dbIntervalTagging.tagsId)
          .toList();
      final List<DbTag> dbTags = await DbTag()
          .select()
          .id
          .inValues(tagIds)
          .orderBy('tagGroupsId')
          .toList();
      final List<Tag> tags = dbTags.map(Tag.exDb).toList();
      return tags;
    } else {
      return <Tag>[];
    }
  }

  static Future<BoolCommitResult> upsertAll(List<Tag> tags) async {
    return await DbTag().upsertAll(tags.map((Tag tag) => tag._db).toList());
  }

  static Future<Tag> autoPowerTag({
    @required Athlete athlete,
    @required String name,
    @required int sortOrder,
    @required int color,
  }) async {
    DbTag dbPowerTag;

    final TagGroup autoPowerTagGroup =
        await TagGroup.autoPowerTagGroup(athlete: athlete);
    dbPowerTag = await DbTag()
        .select()
        .tagGroupsId
        .equals(autoPowerTagGroup.id)
        .and
        .name
        .equals(name)
        .toSingle();

    if (dbPowerTag == null) {
      dbPowerTag = DbTag()
        ..tagGroupsId = autoPowerTagGroup.id
        ..color = color
        ..sortOrder = sortOrder
        ..name = name
        ..system = true;
      await dbPowerTag.save();
    }
    return Tag._fromDb(dbPowerTag);
  }

  static Future<Tag> autoHeartRateTag({
    @required Athlete athlete,
    @required String name,
    @required int sortOrder,
    @required int color,
  }) async {
    DbTag dbHeartRateTag;

    final TagGroup autoHeartRateTagGroup =
        await TagGroup.autoHeartRateTagGroup(athlete: athlete);
    dbHeartRateTag = await DbTag()
        .select()
        .tagGroupsId
        .equals(autoHeartRateTagGroup.id)
        .and
        .name
        .equals(name)
        .toSingle();

    if (dbHeartRateTag == null) {
      dbHeartRateTag = DbTag()
        ..tagGroupsId = autoHeartRateTagGroup.id
        ..color = color
        ..sortOrder = sortOrder
        ..name = name
        ..system = true;
      await dbHeartRateTag.save();
    }
    return Tag._fromDb(dbHeartRateTag);
  }

  static Tag exDb(DbTag db) => Tag._fromDb(db);
}
