import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbTag, DbActivityTagging;
import 'package:encrateia/models/tag_group.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart'
    show BoolCommitResult, BoolResult;
import 'activity.dart';
import 'athlete.dart';

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

  int get id => _db.id;
  int get color => _db.color;
  String get name => _db.name;
  bool get system => _db.system;
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
        .equals(activity.db.id)
        .toList();
    if (dbActivityTaggings.isNotEmpty) {
      final List<DbTag> dbTags = await DbTag()
          .select()
          .id
          .inValues(dbActivityTaggings
              .map((DbActivityTagging dbActivityTagging) =>
                  dbActivityTagging.tagsId)
              .toList())
          .toList();
      final List<Tag> tags =
          dbTags.map(Tag.exDb).toList();
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
