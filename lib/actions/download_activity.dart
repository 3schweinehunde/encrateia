import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';

Future<void> downloadActivity({
  required BuildContext context,
  required Activity activity,
  required Athlete athlete,
}) async {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 10),
      content: Row(children: [
        MyIcon.stravaDownloadWhite,
        Text(' Download .fit-File for »${activity.name}«'),
      ]),
    ),
  );

  await activity.download(athlete: athlete);

  if (context.mounted) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text(' Download finished'),
          ],
        ),
      ),
    );
  }
}
