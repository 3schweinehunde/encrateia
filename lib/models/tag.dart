import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import 'athlete.dart';

class Tag extends ChangeNotifier {
  Tag({
    @required TagGroup tagGroup,
    String name,
    int color,
    int sortOrder,
  }) {
    db = DbTag()
      ..tagGroupsId = tagGroup.db.id
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

  static Future<List<Tag>> all({@required TagGroup tagGroup}) async {
    print('before');
    final List<DbTag> dbTagList = await tagGroup.db
        .getDbTags()
        .orderBy('sortOrder')
        .orderBy('name')
        .toList();
    print('after');
    final List<Tag> tags =
        dbTagList.map((DbTag dbTag) => Tag.fromDb(dbTag)).toList();
    return tags;
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
        .equals(autoPowerTagGroup.db.id)
        .and
        .name
        .equals(name)
        .toSingle();

    if (dbPowerTag == null) {
      dbPowerTag = DbTag()
        ..tagGroupsId = autoPowerTagGroup.db.id
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
        .equals(autoHeartRateTagGroup.db.id)
        .and
        .name
        .equals(name)
        .toSingle();

    if (dbHeartRateTag == null) {
      dbHeartRateTag = DbTag()
        ..tagGroupsId = autoHeartRateTagGroup.db.id
        ..color = color
        ..sortOrder = sortOrder
        ..name = name
        ..system = true;
      await dbHeartRateTag.save();
    }
    return Tag.fromDb(dbHeartRateTag);
  }
}
