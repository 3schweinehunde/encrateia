import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/tag_group.dart';
import '/utils/icon_utils.dart';

Future<void> autoTagging({
  required BuildContext context,
  required Athlete athlete,
}) async {
  if (await athlete.checkForSchemas()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text('Started cleaning up...'),
          ],
        ),
      ),
    );

    List<Activity> activities;
    activities = await athlete.activities;
    int index = 0;
    int percent;

    await TagGroup.deleteAllAutoTags(athlete: athlete);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text('All existing autotaggings have been deleted.'),
          ],
        ),
      ),
    );

    for (final Activity activity in activities) {
      index += 1;
      await activity.autoTagger(athlete: athlete);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      percent = 100 * index ~/ activities.length;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              CircularProgressIndicator(value: percent / 100),
              Text('$percent% done (autotagging »${activity.name}« )'),
            ],
          ),
        ),
      );
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text('Autotaggings are now up to date.'),
          ],
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text('Please set up Power Zone Schema and '
                'Heart Rate Zone Schema first!'),
          ],
        ),
      ),
    );
  }
}
