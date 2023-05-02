import 'package:flutter/material.dart';
import '../utils/my_color.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/tag_group.dart';
import '/utils/icon_utils.dart';

Future<void> autoTagging({
  required BuildContext context,
  required Athlete athlete,
}) async {
  if (await athlete.checkForSchemas()) {
    if (context.mounted) {
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
    }

    List<Activity> activities;
    activities = await athlete.activities;
    int index = 0;
    int percent;

    await TagGroup.deleteAllAutoTags(athlete: athlete);
    if (context.mounted) {
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
    }

    for (final Activity activity in activities) {
      index += 1;
      await activity.autoTagger(athlete: athlete);
      if (context.mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      }
      percent = 100 * index ~/ activities.length;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Row(
              children: [
                CircularProgressIndicator(
                    value: percent / 100, color: MyColor.progress),
                Text(' $percent% done (autotagging »${activity.name}« )'),
              ],
            ),
          ),
        );
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Row(
            children: [
              MyIcon.finishedWhite,
              const Text(' Autotaggings are now up to date.'),
            ],
          ),
        ),
      );
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Row(
            children: [
              MyIcon.finishedWhite,
              const Text(' Please set up Power Zone Schema and '
                  'Heart Rate Zone Schema first!'),
            ],
          ),
        ),
      );
    }
  }
}
