import 'package:flutter/material.dart';

import '/models/athlete.dart';
import '/models/tag_group.dart';
import '/screens/add_filter_screen.dart';
import '/utils/my_button.dart';
import 'athlete_current_filter_widget.dart';

class AthleteFilterWidget extends StatelessWidget {
  const AthleteFilterWidget(
      {Key? key, required this.athlete,
      required this.tagGroups,
      required this.callBackFunction}) : super(key: key);

  final Athlete? athlete;
  final List<TagGroup> tagGroups;
  final Function callBackFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 20),
          AthleteCurrentFilterWidget(
            athlete: athlete,
            tagGroups: tagGroups,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.add(
                child: const Text('Add filter'),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) => AddFilterScreen(
                        athlete: athlete,
                      ),
                    ),
                  );
                  callBackFunction();
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),
        ]);
  }
}
