import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> parseActivity({
  @required BuildContext context,
  @required Activity activity,
  @required Athlete athlete,
  @required Flushbar<Object> flushbar,
}) async {
  await flushbar?.dismiss();
  flushbar = Flushbar<Object>(
    message: '0% of storing »${activity.name}«',
    titleText: const LinearProgressIndicator(value: 0),
    animationDuration: const Duration(milliseconds: 0),
  )..show(context);

  final Stream<int> percentageStream = activity.parse(athlete: athlete);
  await for (final int value in percentageStream) {
    if (value == -2)
      await flushbar?.dismiss();
    else if (value == -1) {
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
}
