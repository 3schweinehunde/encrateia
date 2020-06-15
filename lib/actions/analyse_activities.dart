import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> analyseActivities({
  @required BuildContext context,
  @required Athlete athlete,
  @required Flushbar<Object> flushbar,
}) async {
  List<Activity> activities;
  activities = await athlete.activities;
  int index = 0;
  int percent;

  flushbar = Flushbar<Object>(
    message: 'Calculating...',
    duration: const Duration(seconds: 5),
    icon: MyIcon.finishedWhite,
  )..show(context);

  for (final Activity activity in activities) {
    index += 1;
    await activity.setAverages();
    flushbar.dismiss();
    percent = 100 * index ~/ activities.length;
    flushbar = Flushbar<Object>(
      titleText: LinearProgressIndicator(value: percent / 100),
      message: '$percent% done (recalculating »${activity.name}« )',
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 1),
    )..show(context);
  }

  flushbar.dismiss();
  flushbar = Flushbar<Object>(
    message: 'Averages are now up to date.',
    duration: const Duration(seconds: 5),
    icon: MyIcon.finishedWhite,
  )..show(context);
}
