import 'package:flutter/material.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/strava.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/models/athlete.dart';

class StravaGetUser extends StatelessWidget {
  final String title = "Strava Login";
  Athlete athlete;
  Strava strava;

  StravaGetUser({this.athlete});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<Athlete>(
        model: athlete,
        child: WillPopScope(
          onWillPop: () {
            Navigator.pop(context, true);
          },
          child: Scaffold(
              appBar: AppBar(title: Text('Create Athlete')),
              body:  ScopedModelDescendant<Athlete>(
                      builder: (context, child, athlete) {
                        if (strava == null) {
                          loginToStrava();
                        };
                        return Container(child:
                          Text("Athlete ${athlete.firstName}")
                        );
                      }
                  )
          )
        )
    );
  }

  loginToStrava() async {
    this.strava = Strava(true, secret);
    final prompt = 'auto';

    final auth = await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);
    print(auth);
    final stravaAthlete = await strava.getLoggedInAthlete();

    athlete.setData(firstName: stravaAthlete.firstname);
  }
}
