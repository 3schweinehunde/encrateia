import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/strava.dart';
import 'package:provider/provider.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';

class StravaGetUser extends StatelessWidget {
  const StravaGetUser({this.athlete});

  String get title => 'Strava Login';
  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: athlete,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Athlete'),
          backgroundColor: MyColor.primary,
        ),
        body: Consumer<Athlete>(
          builder: (BuildContext context, Athlete athlete, Widget _child) {
            if (athlete.db.firstName == null)
              loginToStrava();
            if (athlete.db.state == 'fromStrava')
              Navigator.of(context).pop();
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(athlete.stateText),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> loginToStrava() async {
    final Strava strava = Strava(true, secret);
    const String prompt = 'auto';

    await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);
    final DetailedAthlete stravaAthlete = await strava.getLoggedInAthlete();
    athlete.updateFromStravaAthlete(stravaAthlete);
  }
}
