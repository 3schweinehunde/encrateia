import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/log.dart';

Future<void> parseActivity({
  required BuildContext context,
  required Activity activity,
  required Athlete athlete,
  required Flushbar<Object>? flushbar,
}) async {
  await flushbar?.dismiss();
  flushbar = Flushbar<Object>(
    message: '0% of storing »${activity.name}«',
    titleText: const LinearProgressIndicator(value: 0),
    animationDuration: const Duration(milliseconds: 0),
  )..show(context);

  Stream<int> percentageStream;

  try {
    percentageStream = activity.parse(athlete: athlete);
    await for (final int value in percentageStream) {
      if (value == -2) {
        await flushbar?.dismiss();
      } else if (value == -1) {
        await flushbar?.dismiss();
        flushbar = Flushbar<Object>(
          message: 'Analysing »${activity.name}«',
          animationDuration: const Duration(milliseconds: 0),
        )..show(context);
      } else {
        await flushbar?.dismiss();
        flushbar = Flushbar<Object>(
          titleText: LinearProgressIndicator(value: value / 100),
          message: '$value% of storing »${activity.name}«',
          animationDuration: const Duration(milliseconds: 0),
        )..show(context);
      }
    }
  } catch (exception) {
    final Log log = Log(
      message: exception.runtimeType.toString(),
      method: 'parseActivity',
      stackTrace: exception.stackTrace.toString(),
      comment: '/lib/actions/parse_activity.25',
    );
    await log.save();
    activity.nonParsable = true;
    await activity.save();
    await flushbar?.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Error, see log on home screen for details',
      animationDuration: const Duration(milliseconds: 0),
      duration: const Duration(seconds: 2),
    )..show(context);
  }
}
