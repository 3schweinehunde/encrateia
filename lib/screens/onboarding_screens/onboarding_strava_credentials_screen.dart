import 'package:flutter/material.dart';

import '/models/athlete.dart';
import '/utils/my_color.dart';
import '/widgets/athlete_widgets/edit_strava_athlete_widget.dart';

class OnBoardingStravaCredentialsScreen extends StatelessWidget {
  const OnBoardingStravaCredentialsScreen({
    Key key,
    @required this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MyColor.athlete,
          title: const Text('Athlete Credentials'),
        ),
        body: SafeArea(
          child: EditStravaAthleteWidget(athlete: athlete),
        ),
      ),
    );
  }
}
