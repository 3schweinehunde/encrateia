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
  flushbar.dismiss();
  flushbar = Flushbar<Object>(
    message: '0% of storing »${activity.name}«',
    duration: const Duration(seconds: 10),
    animationDuration: const Duration(milliseconds: 1),
    titleText: const LinearProgressIndicator(value: 0),
  )..show(context);

  final Stream<int> percentageStream = activity.parse(athlete: athlete);
  await for (final int value in percentageStream) {
    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      titleText: LinearProgressIndicator(value: value / 100),
      message: '$value% of storing »${activity.name}«',
      duration: const Duration(seconds: 20),
      animationDuration: const Duration(milliseconds: 1),
    )..show(context);
  }
}
