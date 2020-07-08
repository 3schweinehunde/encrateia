import 'package:encrateia/models/strava_fit_download.dart';
import 'package:encrateia/screens/onboarding_screens/onboarding_power_zone_schema_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/utils/icon_utils.dart';

class EditStravaAthleteWidget extends StatefulWidget {
  const EditStravaAthleteWidget({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _EditStravaAthleteWidgetState createState() =>
      _EditStravaAthleteWidgetState();
}

class _EditStravaAthleteWidgetState extends State<EditStravaAthleteWidget> {
  Flushbar<Object> flushbar = Flushbar<Object>();

  @override
  Widget build(BuildContext context) {
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
          title: Text(widget.athlete.firstName ?? 't.b.d.'),
        ),
        ListTile(
          leading: const Text('Last Name'),
          title: Text(widget.athlete.lastName ?? 't.b.d.'),
        ),
        ListTile(
          leading: const Text('Strava ID'),
          title: Text(widget.athlete.stravaId?.toString() ?? 't.b.d.'),
        ),
        ListTile(
          leading: const Text('Strava Username'),
          title: Text(widget.athlete.stravaUsername ?? 't.b.d.'),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          initialValue: widget.athlete.email,
          onChanged: (String value) => widget.athlete.email = value,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Password'),
          onChanged: (String value) => widget.athlete.password = value,
          initialValue: widget.athlete.password,
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
      final List<PowerZoneSchema> powerZoneSchemas =
          await widget.athlete.powerZoneSchemas;
      await flushbar.dismiss();
      if (powerZoneSchemas.isEmpty)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<BuildContext>(
            builder: (BuildContext _) =>
                OnBoardingPowerZoneSchemaScreen(athlete: widget.athlete),
          ),
        );
      else
        Navigator.of(context).pop();
    } else {
      flushbar = Flushbar<Object>(
        icon: MyIcon.error,
        message: 'The credentials provided are invalid!',
        duration: const Duration(seconds: 5),
      )
        ..show(context);
    }
  }
}
