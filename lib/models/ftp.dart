import 'dart:math';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/power_duration.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/activity_list.dart';
import 'athlete.dart';

class Ftp {
  static Future<void> calculate({
    Athlete athlete,
    Function callback,
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
    print('backlog: ${backlog.length} activities');
    for (final Activity activity in backlog) {
      print('ftp calculating 0');
      final List<Event> records = await activity.records;
      final List<Event> powerRecords = records
          .where((Event value) => value.power != null && value.power > 100)
          .toList();
      print('ftp calculating 1');
      final PowerDuration powerDuration = PowerDuration(records: powerRecords);
      print('ftp calculating 2');
      final PowerDuration ftpCurve = powerDuration.normalize();
      print('ftp calculating 3');
      final double ftp = ftpCurve.powerMap.values.toList().reduce(max);
      activity.ftp = ftp;
      activity.save();
      print('ftp calculated');
      callback(() {});
    }
  }
}
