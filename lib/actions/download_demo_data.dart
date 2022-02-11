import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '/actions/parse_activity.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';

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

    await flushbar?.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Downloading Demo data ...',
      icon: MyIcon.stravaDownloadWhite,
      animationDuration: const Duration(milliseconds: 0),
    )..show(context);

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
        flushbar: flushbar,
      );
      await flushbar?.dismiss();
      flushbar = Flushbar<Object>(
        message: 'Tagging »${activity.name}«',
        animationDuration: const Duration(milliseconds: 0),
      )..show(context);
      await activity.autoTagger(athlete: athlete);
    }
    await flushbar?.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Activities imported!',
      icon: MyIcon.finishedWhite,
      animationDuration: const Duration(milliseconds: 0),
    )..show(context);
  } else {
    await flushbar?.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Please set up Power Zone Schema and Heart'
          ' Rate Zone Schema first!',
      animationDuration: const Duration(milliseconds: 0),
    )..show(context);
  }
}
