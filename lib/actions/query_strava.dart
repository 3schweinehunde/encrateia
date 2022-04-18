import 'package:flutter/material.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';

Future<void> queryStrava({
  required BuildContext context,
  required Athlete athlete,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 10),
      content: Row(
        children: [
          MyIcon.stravaDownloadWhite,
          const Text(' Downloading new activities'),
        ],
      ),
    ),
  );

  await athlete.queryStrava();
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          MyIcon.finishedWhite,
          const Text('Download finished'),
        ],
      ),
    ),
  );
}
