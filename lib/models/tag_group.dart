import 'package:encrateia/models/tag.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

import 'lap.dart';

class TagGroup extends ChangeNotifier {
  DbTagGroup db;
  List<Tag> cachedTags;

  TagGroup({@required Athlete athlete}) {
    db = DbTagGroup()
      ..athletesId = athlete.db.id
      ..color = Colors.lightGreen.value
      ..system = false
      ..name = "My Tag Group";
  }

  TagGroup.fromDb(this.db);

  Future<List<Tag>> get tags async {
    var tags = await Tag.all(tagGroup: this);
    return tags;
  }

  TagGroup.by(
      {@required Athlete athlete,
      @required String name,
      @required bool system,
      @required int color}) {
    db = DbTagGroup()
      ..athletesId = athlete.db.id
      ..color = color
      ..system = system
      ..name = name;
  }

  String toString() => '< Taggroup | ${db.name} >';

  delete() async {
    await this.db.delete();
  }

  static createDefaultTagGroups({Athlete athlete}) async {
    var autoHeartRateZones = TagGroup.by(
      name: "Auto Heart Rate Zones",
      athlete: athlete,
      system: true,
      color: MyColor.grapeFruit.value,
    );
    await autoHeartRateZones.db.save();

    var autoPowerZonesTagGroup = TagGroup.by(
      name: "Auto Power Zones",
      athlete: athlete,
      system: true,
      color: MyColor.bitterSweet.value,
    );
    await autoPowerZonesTagGroup.db.save();
  }

  static autoPowerTagGroup({Athlete athlete}) async {
    var dbTagGroup = await DbTagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.db.id)
        .and
        .name
        .equals("Auto Power Zones")
        .toSingle();
    return TagGroup.fromDb(dbTagGroup);
  }

  static autoHeartRateTagGroup({Athlete athlete}) async {
    var dbTagGroup = await DbTagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.db.id)
        .and
        .name
        .equals("Auto Heart Rate Zones")
        .toSingle();
    return TagGroup.fromDb(dbTagGroup);
  }

  static includingActivityTaggings({
    @required Athlete athlete,
    @required Activity activity,
  }) async {
    var tagGroups = await all(athlete: athlete);

    var dbActivityTaggings = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .toList();
    var selectedTagIds = dbActivityTaggings
        .map((DbActivityTagging dbActivityTagging) => dbActivityTagging.tagsId);

    for (TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
      for (Tag tag in tagGroup.cachedTags) {
        tag.selected = selectedTagIds.contains(tag.db.id) ? true : false;
      }
    }
    return tagGroups;
  }

  static includingLapTaggings({
    @required Athlete athlete,
    @required Lap lap,
  }) async {
    var tagGroups = await all(athlete: athlete);

    var dbLapTaggings =
        await DbLapTagging().select().lapsId.equals(lap.db.id).toList();

    var selectedTagIds =
        dbLapTaggings.map((DbLapTagging dbLapTagging) => dbLapTagging.tagsId);

    for (TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
      for (Tag tag in tagGroup.cachedTags) {
        tag.selected = selectedTagIds.contains(tag.db.id) ? true : false;
      }
    }
    return tagGroups;
  }

  static Future<List<TagGroup>> all({@required Athlete athlete}) async {
    var dbTagGroupList =
        await athlete.db.getDbTagGroups().orderBy('name').toList();
    var tagGroups = dbTagGroupList
        .map((dbTagGroup) => TagGroup.fromDb(dbTagGroup))
        .toList();

    for (TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
    }
    return tagGroups;
  }

  static deleteAllAutoTags({Athlete athlete}) async {
    TagGroup autoPowerTagGroup = await TagGroup.autoPowerTagGroup(athlete: athlete);
    await autoPowerTagGroup.db.getDbTags().delete();

    TagGroup autoHeartRateTagGroup = await TagGroup.autoHeartRateTagGroup(athlete: athlete);
    await autoHeartRateTagGroup.db.getDbTags().delete();
  }
}
