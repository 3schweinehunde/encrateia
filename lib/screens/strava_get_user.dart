import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/strava.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';

class StravaGetUser extends StatefulWidget {
  const StravaGetUser({this.athlete});

  final Athlete athlete;

  @override
  _StravaGetUserState createState() => _StravaGetUserState();
}

class _StravaGetUserState extends State<StravaGetUser> {
  String get title => 'Strava Login';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Athlete'),
        backgroundColor: MyColor.primary,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(widget.athlete.stateText),
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
    widget.athlete.updateFromStravaAthlete(stravaAthlete);
  }

  Future<void> getData() async {
    if (widget.athlete.db.firstName == null) {
      await loginToStrava();
      setState((){});
    }
    if (widget.athlete.db.state == 'fromStrava')
      Navigator.of(context).pop();
  }
}
