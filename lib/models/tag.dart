import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/models/tag_group.dart';

class Tag extends ChangeNotifier {
  DbTag db;
  bool selected = false;

  Tag({
    @required TagGroup tagGroup,
    String name,
    int color,
  }) {
    db = DbTag()
      ..tagGroupsId = tagGroup.db.id
      ..name = name ?? "my Tag"
      ..color = color ?? 0xFFFFc107;
  }
  Tag.fromDb(this.db);

  String toString() => '< Tag | ${db.name} >';

  delete() async {
    await this.db.delete();
  }

  static Future<List<Tag>> all({@required TagGroup tagGroup}) async {
    var dbTagList = await tagGroup.db.getDbTags().orderBy('name').toList();
    var tags = dbTagList.map((dbTag) => Tag.fromDb(dbTag)).toList();
    return tags;
  }
}
