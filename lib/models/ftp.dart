import 'dart:math';

import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/power_duration.dart';
import 'package:encrateia/models/tag_group.dart';

import 'athlete.dart';

class Ftp {
  static Future<List<Activity>> deriveBacklog({
    Athlete athlete,
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

  static Future<void> catchUp({List<Activity> backlog}) async {
    for (final Activity activity in backlog) {
      print('calculating ftp for ${activity.name} ...');
      final List<Event> records = await activity.records;
      final List<Event> powerRecords = records
          .where((Event value) => value.power != null && value.power > 100)
          .toList();
      activity.ftp = calculate(records: powerRecords);
      activity.save();
      print('ftp calculated');
    }
  }

  static double calculate({List<Event> records}) {
    final PowerDuration powerDuration = PowerDuration(records: records);
    final PowerDuration ftpCurve = powerDuration.normalize();
    final double ftp = ftpCurve.powerMap.values.toList().reduce(max);
    return ftp;
  }
}
