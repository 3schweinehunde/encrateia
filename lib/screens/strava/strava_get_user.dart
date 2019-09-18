import 'package:flutter/material.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/strava.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/models/athlete.dart';

class StravaGetUser extends StatelessWidget {
  final String title = "Strava Login";
  final Athlete athlete;

  StravaGetUser({this.athlete});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<Athlete>(
      model: athlete,
      child: Scaffold(
        appBar: AppBar(title: Text('Create Athlete')),
        body:
            ScopedModelDescendant<Athlete>(builder: (context, child, athlete) {
          if (athlete.firstName == null) loginToStrava();
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
    final stravaAthlete = await strava.getLoggedInAthlete();

    athlete.set(
      firstName: stravaAthlete.firstname,
      lastName: stravaAthlete.lastname,
      stravaId: stravaAthlete.id,
      stravaUsername: stravaAthlete.username,
      photoPath: stravaAthlete.profile,
      state: "loaded",
    );
  }
}
