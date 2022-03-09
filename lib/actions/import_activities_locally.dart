import 'package:flutter/material.dart';

import '/actions/parse_activity.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';

Future<void> importActivitiesLocally({
  required BuildContext context,
  required Athlete athlete,
}) async {
  List<Activity> activities;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          MyIcon.stravaDownloadWhite,
          const Text(' Importing activities from local directory'),
        ],
      ),
    ),
  );

  await Activity.importFromLocalDirectory(athlete: athlete);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          MyIcon.finishedWhite,
          const Text(' Activities moved into application'),
        ],
      ),
    ),
  );

  activities = await athlete.activities;
  final List<Activity> downloadedActivities = activities
      .where((Activity activity) =>
          activity.state == 'downloaded' &&
          activity.nonParsable != true &&
          activity.manual != true &&
          activity.excluded != true)
      .toList();
  for (final Activity activity in downloadedActivities) {
    await parseActivity(
      context: context,
      activity: activity,
      athlete: athlete,
    );
    await activity.autoTagger(athlete: athlete);
  }
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 5),
      content: Row(
        children: [
          MyIcon.finishedWhite,
          const Text(' Activities imported!'),
        ],
      ),
    ),
  );
}
