import 'dart:math';

import '/models/activity.dart';
import '/models/activity_list.dart';
import '/models/event.dart';
import '/models/power_duration.dart';
import '/models/tag_group.dart';
import 'athlete.dart';

Future<List<Activity>> deriveBacklog({
  required Athlete athlete,
}) async {
  final List<Activity> unfilteredActivities = await athlete.activities;
  final TagGroup autoEffortTagGroup =
      await TagGroup.autoEffortTagGroup(athlete: athlete);
  final List<Activity> effortActivities =
      await ActivityList<Activity>(unfilteredActivities)
          .filterByTagGroup(tagGroup: autoEffortTagGroup);
  final List<Activity> backlog = effortActivities
      .where((final Activity activity) => activity.ftp == null)
      .toList();
  return backlog;
}

Future<void> catchUp({required List<Activity> backlog}) async {
  for (final Activity activity in backlog) {
    print('calculating ftp for ${activity.name} ...');
    final List<Event> records = await activity.records;
    final List<Event> powerRecords = records
        .where((Event value) => value.power != null && value.power! > 100)
        .toList();
    activity.ftp = calculate(records: powerRecords);
    activity.save();
    print('ftp calculated');
  }
}

double calculate({required List<Event> records}) {
  final PowerDuration powerDuration = PowerDuration(records: records);
  final PowerDuration ftpCurve = powerDuration.normalize();
  final double ftp = ftpCurve.powerMap.values.toList().reduce(max);
  return ftp;
}
