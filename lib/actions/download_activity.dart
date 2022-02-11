import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';

Future<void> downloadActivity({
  @required BuildContext context,
  @required Activity activity,
  @required Athlete athlete,
  @required Flushbar<Object> flushbar,
}) async {
  await flushbar.dismiss();
  flushbar = Flushbar<Object>(
    message: 'Download .fit-File for »${activity.name}«',
    duration: const Duration(seconds: 10),
    icon: MyIcon.stravaDownloadWhite,
  )..show(context);

  await activity.download(athlete: athlete);

  await flushbar.dismiss();
  flushbar = Flushbar<Object>(
    message: 'Download finished',
    duration: const Duration(seconds: 2),
    icon: MyIcon.finishedWhite,
  )..show(context);
}
