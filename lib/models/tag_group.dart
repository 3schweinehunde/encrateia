import 'package:encrateia/models/tag.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart' show DbTagGroup;
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/activity_tagging.dart';
import 'lap.dart';
import 'lap_tagging.dart';

class TagGroup extends DbTagGroup {
  TagGroup();

  TagGroup.minimal({@required Athlete athlete})
      : super(
          athletesId: athlete.db.id,
          color: Colors.lightGreen.value,
          system: false,
          name: 'My Tag Group',
        );

  TagGroup.by(
      {@required Athlete athlete,
      @required String name,
      @required bool system,
      @required int color})
      : super(
          athletesId: athlete.db.id,
          color: color,
          system: system,
          name: name,
        );

  List<Tag> cachedTags;

  Future<List<Tag>> get tags async => await Tag.all(tagGroup: this);

  @override
  String toString() => '< TagGroup | $name >';

  static Future<TagGroup> autoPowerTagGroup({@required Athlete athlete}) async {
    final TagGroup tagGroup = await TagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.db.id)
        .and
        .name
        .equals('Auto Power Zones')
        .toSingle() as TagGroup;
    if (tagGroup != null)
      return tagGroup;
    else {
      final TagGroup autoPowerTagGroup = TagGroup.by(
        name: 'Auto Power Zones',
        athlete: athlete,
        system: true,
        color: MyColor.bitterSweet.value,
      );
      await autoPowerTagGroup.save();
      return autoPowerTagGroup;
    }
  }

  static Future<TagGroup> autoHeartRateTagGroup(
      {@required Athlete athlete}) async {
    final TagGroup tagGroup = await TagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.db.id)
        .and
        .name
        .equals('Auto Heart Rate Zones')
        .toSingle() as TagGroup;
    if (tagGroup != null)
      return tagGroup;
    else {
      final TagGroup autoHeartRateTagGroup = TagGroup.by(
        name: 'Auto Heart Rate Zones',
        athlete: athlete,
        system: true,
        color: MyColor.grapeFruit.value,
      );
      await autoHeartRateTagGroup.save();
      return autoHeartRateTagGroup;
    }
  }

  static Future<List<TagGroup>> includingActivityTaggings({
    @required Athlete athlete,
    @required Activity activity,
  }) async {
    final List<TagGroup> tagGroups = await all(athlete: athlete);

    final List<ActivityTagging> activityTaggings = await ActivityTagging()
        .select()
        .activitiesId
        .equals(activity.db.id)
        .toList() as List<ActivityTagging>;
    final Iterable<int> selectedTagIds = activityTaggings
        .map((ActivityTagging activityTagging) => activityTagging.tagsId);

    for (final TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
      for (final Tag tag in tagGroup.cachedTags) {
        tag.selected = selectedTagIds.contains(tag.id);
      }
    }
    return tagGroups;
  }

  static Future<List<TagGroup>> includingLapTaggings({
    @required Athlete athlete,
    @required Lap lap,
  }) async {
    final List<TagGroup> tagGroups = await all(athlete: athlete);

    final List<LapTagging> lapTaggings = await LapTagging()
        .select()
        .lapsId
        .equals(lap.db.id)
        .toList() as List<LapTagging>;

    final Iterable<int> selectedTagIds =
        lapTaggings.map((LapTagging lapTagging) => lapTagging.tagsId);

    for (final TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
      for (final Tag tag in tagGroup.cachedTags) {
        tag.selected = selectedTagIds.contains(tag.id);
      }
    }
    return tagGroups;
  }

  static Future<List<TagGroup>> all({@required Athlete athlete}) async {
    final List<TagGroup> tagGroups = await athlete.db
        .getDbTagGroups()
        .orderBy('name')
        .toList() as List<TagGroup>;

    for (final TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
    }
    return tagGroups;
  }

  static Future<void> deleteAllAutoTags({Athlete athlete}) async {
    final TagGroup autoPowerTagGroup =
        await TagGroup.autoPowerTagGroup(athlete: athlete);
    await autoPowerTagGroup.getDbTags().delete();

    final TagGroup autoHeartRateTagGroup =
        await TagGroup.autoHeartRateTagGroup(athlete: athlete);
    await autoHeartRateTagGroup.getDbTags().delete();
  }
}
