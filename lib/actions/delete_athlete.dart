import 'package:flutter/material.dart';
import '/models/athlete.dart';
import '/utils/my_button.dart';

Future<void> deleteAthlete({
  required BuildContext context,
  required Athlete? athlete,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('All the athlete\'s data including'),
              Text('activities will be deleted as well.'),
              Text('There is no undo function.'),
            ],
          ),
        ),
        actions: <Widget>[
          MyButton.cancel(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          MyButton.delete(
            onPressed: () async {
              await athlete!.delete();
              if (context.mounted) {
                Navigator.of(context)
                    .popUntil((Route<dynamic> route) => route.isFirst);
              }
            },
          ),
        ],
      );
    },
  );
}
