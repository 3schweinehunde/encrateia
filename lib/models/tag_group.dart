import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/athlete.dart';

class TagGroup extends ChangeNotifier {
  DbTagGroup db;

  TagGroup({@required Athlete athlete}) {
    db = DbTagGroup()
      ..athletesId = athlete.db.id
      ..name = "My Tag Group";
  }
  TagGroup.fromDb(this.db);

  get powerZones => Tag.all(tagGroup: this);

  TagGroup.likeStryd({Athlete athlete}) {
    db = DbTagGroup()
      ..athletesId = athlete.db.id
      ..name = "CP based";
  }

  addStrydZones() async {
    await Tag(
      tagGroup: this,
      name: "Easy",
      color: Colors.lightGreen.value,
    ).db.save();
    await Tag(
      tagGroup: this,
      name: "Moderate",
      color: Colors.lightBlue.value,
    ).db.save();
    await Tag(
      tagGroup: this,
      name: "Threshold",
      color: Colors.yellow.value,
    ).db.save();
    await Tag(
      tagGroup: this,
      name: "Interval",
      color: Colors.orange.value,
    ).db.save();
    await Tag(
      tagGroup: this,
      name: "Repetition",
      color: Colors.red.value,
    ).db.save();
  }

  String toString() => '$db.name';

  delete() async {
    await this.db.delete();
  }

  static Future<List<TagGroup>> all({@required Athlete athlete}) async {
    var dbTagGroupList =
    await athlete.db.getDbTagGroups().orderByDesc('date').toList();
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
    if (dbTagGroups.length != 0)
      return TagGroup.fromDb(dbTagGroups.first);
  }
}
