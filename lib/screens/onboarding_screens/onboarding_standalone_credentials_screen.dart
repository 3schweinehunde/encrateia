import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/athlete_widgets/edit_standalone_athlete_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';

class OnBoardingStandaloneCredentialsScreen extends StatelessWidget {
  const OnBoardingStandaloneCredentialsScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.athlete,
        title: const Text('Enter the Athlete\'s Name'),
      ),
      body: SafeArea(
        child: EditStandaloneAthleteWidget(athlete: athlete),
      ),
    );
  }
}
