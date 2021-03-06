import 'package:encrateia/actions/download_activity.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/actions/query_strava.dart';
import 'package:encrateia/actions/parse_activity.dart';

Future<void> updateJob({
  @required BuildContext context,
  @required Athlete athlete,
  @required Flushbar<Object> flushbar,
}) async {
  List<Activity> activities;

  if (await athlete.checkForSchemas()) {
    await queryStrava(
      context: context,
      athlete: athlete,
      flushbar: flushbar,
    );

    activities = await athlete.activities;
    final Iterable<Activity> newActivities =
        activities.where((Activity activity) => activity.state == 'new');
    for (final Activity activity in newActivities) {
      await downloadActivity(
        context: context,
        activity: activity,
        athlete: athlete,
        flushbar: flushbar,
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
        flushbar: flushbar,
      );
      await activity.autoTagger(athlete: athlete);
    }
    await flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'You are now up to date!',
      duration: const Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  } else {
    flushbar = Flushbar<Object>(
      message:
          'Please set up Power Zone Schema and Heart Rate Zone Schema first!',
      duration: const Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  }
}
