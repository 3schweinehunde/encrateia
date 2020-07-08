import 'package:encrateia/models/strava_fit_download.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/athlete_widgets/edit_standalone_athlete_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/edit_strava_athlete_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'strava_get_user.dart';

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
      body: (athlete.state == 'standalone')
          ? EditStandaloneAthleteWidget(athlete: athlete)
          : EditStravaAthleteWidget(athlete: athlete),
    );
  }
}
