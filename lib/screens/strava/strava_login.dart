import 'package:flutter/material.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/strava.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';

class StravaLogin  extends StatefulWidget {
  final String title = "Strava Login";

  StravaLogin() {}

  @override
  _StravaLoginState createState() => _StravaLoginState();
}

class _StravaLoginState extends State<StravaLogin> {
  bool isAuthOk = false;
  Strava strava;
  DetailedAthlete stravaAthlete;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loginToStrava();

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, true);
        },
        child: Scaffold(
          appBar: AppBar(title: Text('Create Athlete')),
          body: Container(child:
            Text("isAuthOk ${isAuthOk} \n"
                 "stravaAthlete ${stravaAthlete}"))
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
    final athlete = await strava.getLoggedInAthlete();

    setState(() {
      isAuthOk = auth;
      stravaAthlete = athlete;
    });
  }
}