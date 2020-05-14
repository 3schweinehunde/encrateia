import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';

class TagGroup extends ChangeNotifier {
  DbTagGroup db;

  TagGroup({@required Athlete athlete}) {
    db = DbTagGroup()
      ..athletesId = athlete.db.id
      ..color = Colors.lightGreen.value
      ..system = false
      ..name = "My Tag Group";
  }
  TagGroup.fromDb(this.db);

  get tags => Tag.all(tagGroup: this);

  TagGroup.by(
      {@required Athlete athlete,
      @required String name,
      @required bool system}) {
    db = DbTagGroup()
      ..athletesId = athlete.db.id
      ..color = Colors.lightGreen.value
      ..system = system
      ..name = name;
  }

  String toString() => '$db.name';

  delete() async {
    await this.db.delete();
  }

  static createDefaultTagGroups({Athlete athlete}) async {
    var autoHeartRateZones = TagGroup.by(
      name: "Auto Heart Rate Zones",
      athlete: athlete,
      system: true,
    );
    await autoHeartRateZones.db.save();

    var autoPowerZonesTagGroup = TagGroup.by(
      name: "Auto Power Zones",
      athlete: athlete,
      system: true,
    );
    await autoPowerZonesTagGroup.db.save();
  }

  static Future<List<TagGroup>> all({@required Athlete athlete}) async {
    var dbTagGroupList =
        await athlete.db.getDbTagGroups().orderBy('name').toList();
    var tagGroups = dbTagGroupList
        .map((dbTagGroup) => TagGroup.fromDb(dbTagGroup))
        .toList();
    return tagGroups;
  }

  static getBy({
    int athletesId,
  }) async {
    var dbTagGroups = await DbTagGroup()
        .select()
        .athletesId
        .equals(athletesId)
        .top(1)
        .toList();
    if (dbTagGroups.length != 0) return TagGroup.fromDb(dbTagGroups.first);
  }
}
