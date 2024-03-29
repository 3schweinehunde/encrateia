import 'package:flutter/material.dart';
import 'package:strava_client/domain/model/model_authentication_scopes.dart';
import 'package:strava_client/domain/model/model_detailed_athlete.dart';
import 'package:strava_client/strava_client.dart';
import '/models/athlete.dart';
import '/secrets/secrets.dart';
import '/utils/my_color.dart';

class StravaGetUser extends StatefulWidget {
  const StravaGetUser({Key? key, required this.athlete}) : super(key: key);

  final Athlete athlete;

  @override
  StravaGetUserState createState() => StravaGetUserState();
}

class StravaGetUserState extends State<StravaGetUser> {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(widget.athlete.stateText),
        ),
      ),
    );
  }

  Future<void> loginToStrava({required Athlete athlete}) async {
    final StravaClient stravaClient = StravaClient(
        clientId: clientId, secret: secret, applicationName: athlete.uuid);

    await stravaClient.authentication.authenticate(
        scopes: <AuthenticationScope>[
          AuthenticationScope.read_all,
          AuthenticationScope.profile_read_all,
          AuthenticationScope.activity_read_all
        ],
        redirectUrl: 'stravaflutter://redirect',
        callbackUrlScheme: 'stravaflutter');

    final DetailedAthlete stravaAthlete =
        await stravaClient.athletes.getAuthenticatedAthlete();
    await widget.athlete.updateFromStravaAthlete(stravaAthlete);
  }

  Future<void> getData() async {
    if (widget.athlete.firstName == null) {
      await loginToStrava(athlete: widget.athlete);
      setState(() {});
    }
    if (widget.athlete.state == 'fromStrava') {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
