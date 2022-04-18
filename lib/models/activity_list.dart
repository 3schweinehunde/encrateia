import 'package:collection/collection.dart';
import '/model/model.dart' show DbActivityTagging;
import '/models/activity.dart';
import '/models/tag.dart';
import '/models/tag_group.dart';
import '/utils/enums.dart';
import 'athlete.dart';

class ActivityList<E> extends DelegatingList<E> {
  ActivityList(List<E> activities)
      : _activities = activities as List<Activity>,
        super(activities);

  final List<Activity> _activities;

  void enrichGlidingAverage({
    required int fullDecay,
    required ActivityAttr activityAttr,
  }) {
    _activities.asMap().forEach((int index, Activity activity) {
      double sumOfAvg =
          (activity.getAttribute(activityAttr) as double) * fullDecay;
      double sumOfWeightings = fullDecay * 1.0;
      for (int olderIndex = index + 1;
          olderIndex < _activities.length;
          olderIndex++) {
        final double daysAgo = activity.timeCreated
                .difference(_activities[olderIndex].timeCreated)
                .inHours /
            24;
        if (daysAgo > fullDecay) {
          break;
        }
        sumOfAvg += (fullDecay - daysAgo) *
            (_activities[olderIndex].getAttribute(activityAttr) as num);
        sumOfWeightings += fullDecay - daysAgo;
      }

      activity.glidingMeasureAttribute = sumOfAvg / sumOfWeightings;
    });
  }

  Future<ActivityList<Activity>> applyFilter({
    required Athlete athlete,
    List<TagGroup>? tagGroups,
    bool firstGroupWithData = true,
  }) async {
    List<int?> activityIds = <int>[];
    List<int?> tagIds = <int>[];

    if (athlete.filters.isEmpty) {
      return ActivityList<Activity>(_activities);
    }

    if (tagGroups != null && athlete.filters.isNotEmpty) {
      // get active filters for TagGroup
      for (final TagGroup tagGroup in tagGroups) {
        tagIds = tagGroup.cachedTags.map((Tag tag) => tag.id).toList();
        tagIds.removeWhere((int? tagId) => !athlete.filters.contains(tagId));

        // If there are restrictions for this group:
        if (tagIds.isNotEmpty) {
          // get ActivityTaggings ...
          final List<DbActivityTagging> dbTaggings = await DbActivityTagging()
              .select()
              .tagsId
              .inValues(tagIds)
              .toList();
          // ... and the Activity's ids
          final List<int?> activityIdsFromThisGroup = dbTaggings
              .map((DbActivityTagging dbActivityTagging) =>
                  dbActivityTagging.activitiesId)
              .toList();

          // For the first result set ...
          if (firstGroupWithData)
          // use that result set.
          {
            firstGroupWithData = false;
            activityIds = activityIdsFromThisGroup;
          } else {
            activityIds.removeWhere(
                (int? tagId) => !activityIdsFromThisGroup.contains(tagId));
          }
        }
      }
    }

    final List<Activity> activityList = _activities
        .where((Activity activity) => activityIds.contains(activity.id))
        .toList();
    return ActivityList<Activity>(activityList);
  }

  Future<ActivityList<Activity>> filterByTagGroup({
    required TagGroup tagGroup,
  }) async {
    List<int?> activityIds = <int>[];

    final List<Tag> tags = await tagGroup.tags;
    final List<int?> tagIds = tags.map((Tag tag) => tag.id).toList();

    if (tagIds.isNotEmpty) {
      final List<DbActivityTagging> dbTaggings =
          await DbActivityTagging().select().tagsId.inValues(tagIds).toList();
      activityIds = dbTaggings
          .map((DbActivityTagging dbActivityTagging) =>
              dbActivityTagging.activitiesId)
          .toList();
    }

    final List<Activity> activityList = _activities
        .where((Activity activity) => activityIds.contains(activity.id))
        .toList();
    return ActivityList<Activity>(activityList);
  }
}
