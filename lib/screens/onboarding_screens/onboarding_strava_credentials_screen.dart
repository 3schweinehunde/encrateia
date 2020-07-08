import 'package:encrateia/models/strava_fit_download.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';

import 'onboarding_power_zone_schema_screen.dart';

class OnBoardingStravaCredentialsScreen extends StatefulWidget {
  const OnBoardingStravaCredentialsScreen({
    Key key,
    @required this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _OnBoardingStravaCredentialsScreenState createState() =>
      _OnBoardingStravaCredentialsScreenState();
}

class _OnBoardingStravaCredentialsScreenState
    extends State<OnBoardingStravaCredentialsScreen> {
  Flushbar<Object> flushbar = Flushbar<Object>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.athlete,
        title: const Text('Athlete Credentials'),
      ),
      body: editAthleteForm(widget.athlete, context),
    );
  }

  Widget editAthleteForm(Athlete athlete, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Card(
          child: ListTile(
            leading: MyIcon.website,
            title: const Text(
                'Credentials for .fit-Download from Strava Web Site'),
          ),
        ),
        ListTile(
          leading: const Text('First Name'),
          title: Text(athlete.firstName ?? 't.b.d.'),
        ),
        ListTile(
          leading: const Text('Last Name'),
          title: Text(athlete.lastName ?? 't.b.d.'),
        ),
        ListTile(
          leading: const Text('Strava ID'),
          title: Text(athlete.stravaId?.toString() ?? 't.b.d.'),
        ),
        ListTile(
          leading: const Text('Strava Username'),
          title: Text(athlete.stravaUsername ?? 't.b.d.'),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          initialValue: athlete.email,
          onChanged: (String value) => athlete.email = value,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Password'),
          onChanged: (String value) => athlete.password = value,
          initialValue: athlete.password,
          obscureText: true,
        ),

        // Cancel and Save Card
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.cancel(
                onPressed: () => Navigator.of(context).pop(),
              ),
              Container(width: 20.0),
              MyButton.save(
                onPressed: () => saveStravaUser(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> saveStravaUser(BuildContext context) async {
    await widget.athlete.save();
    await widget.athlete.storeCredentials();
    flushbar = Flushbar<Object>(
      icon: MyIcon.information,
      message: 'checking credentials...',
      duration: const Duration(seconds: 10),
    )..show(context);
    if (await StravaFitDownload.credentialsAreValid(athlete: widget.athlete)) {
      await flushbar.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<BuildContext>(
          builder: (BuildContext _) =>
              OnBoardingPowerZoneSchemaScreen(
                athlete: widget.athlete,
              ),
        ),
      );

    } else
      flushbar = Flushbar<Object>(
        icon: MyIcon.error,
        message: 'The credentials provided are invalid!',
        duration: const Duration(seconds: 10),
      )..show(context);
  }
}
