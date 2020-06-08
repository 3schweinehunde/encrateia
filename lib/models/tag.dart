import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbTag;
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/models/activity_tagging.dart';
import 'activity.dart';
import 'athlete.dart';

class Tag extends DbTag {
  Tag();

  Tag.minimal({
    @required TagGroup tagGroup,
    String name = 'my Tag',
    int color = 0xFFFFc107,
    int sortOrder = 0,
    bool system = false,
  }) : super(
          name: name,
          color: color,
          sortOrder: sortOrder,
          tagGroupsId: tagGroup.id,
          system: system,
        );

  Tag.by({
    @required TagGroup tagGroup,
    @required String name,
    @required int color,
    @required int sortOrder,
    @required bool system,
  }) : super(
          name: name,
          color: color,
          sortOrder: sortOrder,
          tagGroupsId: tagGroup.id,
          system: system,
        );

  bool selected = false;

  @override
  String toString() => '< Tag | $name >';

  static Future<List<Tag>> all({@required TagGroup tagGroup}) async {
    final List<Tag> tags = await tagGroup
        .getDbTags()
        .orderBy('sortOrder')
        .orderBy('name')
        .toList() as List<Tag>;
    return tags;
  }

  static Future<List<Tag>> allByActivity({@required Activity activity}) async {
    final List<ActivityTagging> activityTaggings = await ActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .toList() as List<ActivityTagging>;
    if (activityTaggings.isNotEmpty) {
      final List<Tag> tags = await Tag()
          .select()
          .id
          .inValues(activityTaggings
              .map((ActivityTagging activityTagging) => activityTagging.tagsId)
              .toList())
          .toList() as List<Tag>;
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
    return dbPowerTag as Tag;
  }

  static Future<Tag> autoHeartRateTag({
    @required Athlete athlete,
    @required String name,
    @required int sortOrder,
    @required int color,
  }) async {
    Tag heartRateTag;

    final TagGroup autoHeartRateTagGroup =
        await TagGroup.autoHeartRateTagGroup(athlete: athlete);
    heartRateTag = await Tag()
        .select()
        .tagGroupsId
        .equals(autoHeartRateTagGroup.id)
        .and
        .name
        .equals(name)
        .toSingle() as Tag;

    if (heartRateTag == null) {
      heartRateTag = Tag.by(
        tagGroup: autoHeartRateTagGroup,
        color: color,
        sortOrder: sortOrder,
        name: name,
        system: true,
      );
      await heartRateTag.save();
    }
    return heartRateTag;
  }
}
