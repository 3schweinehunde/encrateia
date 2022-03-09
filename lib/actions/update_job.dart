import 'package:flutter/material.dart';

import '/actions/download_activity.dart';
import '/actions/parse_activity.dart';
import '/actions/query_strava.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';

Future<void> updateJob({
  required BuildContext context,
  required Athlete athlete,
}) async {
  List<Activity> activities;

  if (await athlete.checkForSchemas()) {
    await queryStrava(
      context: context,
      athlete: athlete,
    );

    activities = await athlete.activities;
    final Iterable<Activity> newActivities =
        activities.where((Activity activity) => activity.state == 'new');
    for (final Activity activity in newActivities) {
      await downloadActivity(
        context: context,
        activity: activity,
        athlete: athlete,
      );
    }

    final Iterable<Activity> downloadedActivities = activities.where(
        (Activity activity) =>
            activity.state == 'downloaded' &&
            activity.manual != true &&
            activity.nonParsable != true &&
            activity.excluded != true);
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
            const Text('You are now up to date!'),
          ],
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text('Please set up Power Zone Schema and '
                'Heart Rate Zone Schema first!'),
          ],
        ),
      ),
    );
  }
}
