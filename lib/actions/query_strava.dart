import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';

Future<void> queryStrava({
  required BuildContext context,
  required Athlete athlete,
  required Flushbar<Object> flushbar,
}) async {
  flushbar = Flushbar<Object>(
    message: 'Downloading new activities',
    duration: const Duration(seconds: 10),
    icon: MyIcon.stravaDownloadWhite,
  )..show(context);
  await Activity.queryStrava(athlete: athlete);
  await flushbar.dismiss();
  flushbar = Flushbar<Object>(
    message: 'Download finished',
    duration: const Duration(seconds: 1),
    icon: MyIcon.finishedWhite,
  )..show(context);
}
