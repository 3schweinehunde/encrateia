import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '/actions/parse_activity.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';

Future<void> downloadDemoData({
  required BuildContext context,
  required Athlete athlete,
}) async {
  if (await athlete.checkForSchemas()) {
    List<Activity> activities;
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Dio dio = Dio();
    const String downloadDir =
        'https://encrateia.informatom.com/assets/fit-files/';
    final List<String> fileNames = <String>[
      'munich_half_marathon.fit',
      'listener_meetup_run_cologne.fit',
      'stockholm_half_marathon.fit',
      'upper_palatinate_winter_challenge_half_marathon.fit',
    ];

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            MyIcon.stravaDownloadWhite,
            const Text(' Downloading Demo data ...'),
          ],
        ),
      ),
    );

    for (final String filename in fileNames) {
      final Activity activity = Activity.fromLocalDirectory(athlete: athlete);
      await dio.download(downloadDir + filename,
          appDocDir.path + '/' + activity.stravaId.toString() + '.fit');
      await activity.setState('downloaded');
    }

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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Tagging »${activity.name}«')),
      );

      await activity.autoTagger(athlete: athlete);
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text(' Activities imported!'),
          ],
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(' Please set up Power Zone Schema and Heart'
            ' Rate Zone Schema first!'),
      ),
    );
  }
}
