import 'package:flutter/material.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/strava.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/models/athlete.dart';

class StravaGetUser extends StatefulWidget {
  final String title = "Strava Login";
  Athlete athlete;

  StravaGetUser(this.athlete) {}

  @override
  _StravaGetUserState createState() => _StravaGetUserState();
}

class _StravaGetUserState extends State<StravaGetUser> {
  Strava strava;

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
            body: ScopedModelDescendant<Athlete>(
                builder: (context, child, model) {
              widget.athlete = model;
              Container(child: Text("Athlete ${widget.athlete.firstName}"));
            })));
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

    setState(() {
      widget.athlete.firstName = stravaAthlete.firstname;
    });
  }
}
