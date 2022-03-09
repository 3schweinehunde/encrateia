import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/log.dart';

Future<void> parseActivity({
  required BuildContext context,
  required Activity activity,
  required Athlete athlete,
}) async {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const CircularProgressIndicator(value: 0),
          Text('storing »${activity.name}«'),
        ],
      ),
    ),
  );

  Stream<int> percentageStream;

  try {
    percentageStream = activity.parse(athlete: athlete);
    await for (final int value in percentageStream) {
      if (value == -2) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      } else if (value == -1) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysing »${activity.name}«'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CircularProgressIndicator(value: value / 100),
                Text('storing »${activity.name}«'),
              ],
            ),
          ),
        );
      }
    }
  } catch (exception, stacktrace) {
    final Log log = Log(
      message: exception.runtimeType.toString(),
      method: 'parseActivity',
      stackTrace: stacktrace.toString(),
      comment: '/lib/actions/parse_activity.25',
    );
    await log.save();
    activity.nonParsable = true;
    await activity.save();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Error, see log on home screen for details')),
    );
  }
}
