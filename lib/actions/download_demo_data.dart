import 'dart:io';
import 'package:dio/dio.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrateia/actions/parse_activity.dart';

Future<void> downloadDemoData({
  @required BuildContext context,
  @required Athlete athlete,
  @required Flushbar<Object> flushbar,
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

    flushbar = Flushbar<Object>(
      message: 'Downloading Demo data ...',
      duration: const Duration(seconds: 1),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    for (final String filename in fileNames) {
      final Activity activity = Activity.fromLocalDirectory(athlete: athlete);
      await dio.download(downloadDir + filename,
          appDocDir.path + '/' + activity.stravaId.toString() + '.fit');
      await activity.setState('downloaded');
    }

    flushbar = Flushbar<Object>(
      message: 'Downloading demo data finished',
      duration: const Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    activities = await athlete.activities;
    final List<Activity> downloadedActivities = activities
        .where((Activity activity) => activity.state == 'downloaded')
        .toList();
    for (final Activity activity in downloadedActivities) {
      await parseActivity(
        context: context,
        activity: activity,
        athlete: athlete,
        flushbar: flushbar,
      );
      await activity.autoTagger(athlete: athlete);
    }
    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Activities imported!',
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
