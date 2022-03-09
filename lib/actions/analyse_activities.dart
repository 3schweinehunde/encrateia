import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';

Future<void> analyseActivities({
  required BuildContext context,
  required Athlete athlete,
}) async {
  List<Activity> activities;
  activities = await athlete.activities;
  int index = 0;
  int percent;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 5),
      content: Row(
        children: [
          MyIcon.finishedWhite,
          const Text('Calculating...'),
        ],
      ),
    ),
  );

  for (final Activity activity in activities) {
    index += 1;
    await activity.setAverages();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    percent = 100 * index ~/ activities.length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(children: [
          CircularProgressIndicator(value: percent / 100),
          Text('recalculating »${activity.name}«')
        ]),
      ),
    );
  }

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 5),
      content: Row(
        children: [
          MyIcon.finishedWhite,
          const Text('Averages are now up to date.')
        ],
      ),
    ),
  );
}
