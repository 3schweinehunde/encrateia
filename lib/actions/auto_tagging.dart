import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> autoTagging({
  @required BuildContext context,
  @required Athlete athlete,
  @required Flushbar<Object> flushbar,
}) async {
  if (await athlete.checkForSchemas()) {
    flushbar = Flushbar<Object>(
      message: 'Started cleaning up...',
      duration: const Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);

    List<Activity> activities;
    activities = await athlete.activities;
    int index = 0;
    int percent;

    await TagGroup.deleteAllAutoTags(athlete: athlete);
    flushbar = Flushbar<Object>(
      message: 'All existing autotaggings have been deleted.',
      duration: const Duration(seconds: 2),
      icon: MyIcon.finishedWhite,
    )..show(context);

    for (final Activity activity in activities) {
      index += 1;
      await activity.autoTagger(athlete: athlete);
      flushbar.dismiss();
      percent = 100 * index ~/ activities.length;
      flushbar = Flushbar<Object>(
        titleText: LinearProgressIndicator(value: percent / 100),
        message: '$percent% done (autotagging »${activity.name}« )',
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 1),
      )..show(context);
    }

    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Autotaggings are now up to date.',
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
