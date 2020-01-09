import 'package:flutter/material.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/strava.dart';
import 'package:provider/provider.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';

class StravaGetUser extends StatelessWidget {
  final String title = "Strava Login";
  final Athlete athlete;

  StravaGetUser({this.athlete});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: athlete,
      child: Scaffold(
        appBar: AppBar(title: Text('Create Athlete')),
        body:
            Consumer<Athlete>(builder: (context, athlete, _child) {
          if (athlete.db.firstName == null) loginToStrava();
          return Container(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(athlete.stateText),
            ),
          );
        }),
      ),
    );
  }

  loginToStrava() async {
    Strava strava = Strava(true, secret);
    final prompt = 'auto';

    await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);
    DetailedAthlete stravaAthlete = await strava.getLoggedInAthlete();
    athlete.updateFromStravaAthlete(stravaAthlete);
  }
}
