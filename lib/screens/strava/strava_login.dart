import 'package:flutter/material.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/strava.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:strava_flutter/Models/activity.dart';

class StravaLogin  extends StatefulWidget {
  final String title = "Strava Login";

  StravaLogin();

  @override
  _StravaLoginState createState() => _StravaLoginState();
}

class _StravaLoginState extends State<StravaLogin> {
  bool isAuthOk = false;
  Strava strava;
  DetailedAthlete athlete;
  List<SummaryActivity> activities;

  @override
  void initState() {
    loginToStrava();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, true);
        },
        child: Scaffold(
          appBar: AppBar(title: Text('Create Athlete')),
          body: Container(child:
            Text("isAuthOk $isAuthOk \n"
                 "stravaAthlete ${athlete?.firstname} \n"
                 "activities ${activities?.length}"))
        )
    );
  }

  loginToStrava() async {
    strava = Strava(true, secret);
    final prompt = 'auto';

    final auth = await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);
    print(auth);
    final stravaAthlete = await strava.getLoggedInAthlete();
//    final now = DateTime.now().microsecondsSinceEpoch ~/ 1000 ;
//    final yesterday = now - 1550;
//    final stravaActivities = await strava.getLoggedInAthleteActivities(
//        now,
//        yesterday
//    );

    setState(() {
      isAuthOk = auth;
      athlete = stravaAthlete;
    });
  }
}