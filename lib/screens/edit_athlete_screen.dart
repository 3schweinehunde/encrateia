import 'package:flutter/material.dart';

import '/models/athlete.dart';
import '/utils/my_color.dart';
import '/widgets/athlete_widgets/edit_standalone_athlete_widget.dart';
import '/widgets/athlete_widgets/edit_strava_athlete_widget.dart';

class EditAthleteScreen extends StatelessWidget {
  const EditAthleteScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.athlete,
          title: const Text('Athlete Credentials'),
        ),
        body: SafeArea(
          child: (athlete.state == 'standalone')
              ? EditStandaloneAthleteWidget(athlete: athlete)
              : EditStravaAthleteWidget(athlete: athlete),
        ));
  }
}
