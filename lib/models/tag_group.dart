import 'package:encrateia/models/tag.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

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
    if (cachedTags == null) {
      cachedTags = await Tag.all(tagGroup: this);
    }
    return cachedTags;
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
        .map((DbActivityTagging dbActivityTagging) => dbActivityTagging.id);

    for (TagGroup tagGroup in tagGroups) {
      var tags = await tagGroup.tags;
      for (Tag tag in tags) {
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

    return tagGroups;
  }
}
