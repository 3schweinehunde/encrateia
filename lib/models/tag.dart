import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbTag, DbActivityTagging;
import 'package:encrateia/models/tag_group.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart' show BoolResult;
import 'activity.dart';
import 'athlete.dart';

class Tag {
  Tag({
    @required TagGroup tagGroup,
    String name,
    int color,
    int sortOrder,
  }) {
    db = DbTag()
      ..tagGroupsId = tagGroup.id
      ..sortOrder = sortOrder ?? 0
      ..name = name ?? 'my Tag'
      ..color = color ?? 0xFFFFc107;
  }
  Tag.fromDb(this.db);

  DbTag db;
  bool selected = false;

  @override
  String toString() => '< Tag | ${db.name} >';

  Future<BoolResult> delete() async => await db.delete();

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
          .inValues(dbActivityTaggings.map(
              (DbActivityTagging dbActivityTagging) =>
                  dbActivityTagging.tagsId).toList())
          .toList();
      final List<Tag> tags =
          dbTags.map((DbTag dbTag) => Tag.fromDb(dbTag)).toList();
      return tags;
    } else {
      return <Tag>[];
    }
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
    return Tag.fromDb(dbPowerTag);
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
    return Tag.fromDb(dbHeartRateTag);
  }
}
