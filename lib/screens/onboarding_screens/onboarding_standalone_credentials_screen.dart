import 'package:flutter/material.dart';
import '/models/athlete.dart';
import '/utils/my_color.dart';
import '/widgets/athlete_widgets/edit_standalone_athlete_widget.dart';

class OnBoardingStandaloneCredentialsScreen extends StatelessWidget {
  const OnBoardingStandaloneCredentialsScreen({
    Key? key,
    this.athlete,
  }) : super(key: key);

  final Athlete? athlete;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MyColor.athlete,
          title: const Text('Enter the Athlete\'s Name'),
        ),
        body: SafeArea(
          child: EditStandaloneAthleteWidget(athlete: athlete),
        ),
      ),
    );
  }
}
