import 'package:flutter/material.dart';

import '/models/athlete.dart';
import '/models/power_zone_schema.dart';
import '/models/strava_fit_download.dart';
import '/screens/onboarding_screens/onboarding_power_zone_schema_screen.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button.dart';

class EditStravaAthleteWidget extends StatefulWidget {
  const EditStravaAthleteWidget({
    Key? key,
    this.athlete,
  }) : super(key: key);

  final Athlete? athlete;

  @override
  _EditStravaAthleteWidgetState createState() =>
      _EditStravaAthleteWidgetState();
}

class _EditStravaAthleteWidgetState extends State<EditStravaAthleteWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        const Card(
          child: ListTile(
            leading: MyIcon.website,
            title: Text('Credentials for .fit-Download from Strava Web Site'),
          ),
        ),
        ListTile(
          leading: const Text('First Name'),
          title: Text(widget.athlete!.firstName ?? 't.b.d.'),
        ),
        ListTile(
          leading: const Text('Last Name'),
          title: Text(widget.athlete!.lastName ?? 't.b.d.'),
        ),
        ListTile(
          leading: const Text('Strava ID'),
          title: Text(widget.athlete!.stravaId?.toString() ?? 't.b.d.'),
        ),
        ListTile(
          leading: const Text('Strava Username'),
          title: Text(widget.athlete!.stravaUsername ?? 't.b.d.'),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          initialValue: widget.athlete!.email,
          onChanged: (String value) => widget.athlete!.email = value,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Password'),
          onChanged: (String value) => widget.athlete!.password = value,
          initialValue: widget.athlete!.password,
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
    await widget.athlete!.save();
    await widget.athlete!.storeCredentials();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Row(
          children: [
            MyIcon.information,
            const Text('checking credentials...'),
          ],
        ),
      ),
    );

    if (await StravaFitDownload.credentialsAreValid(athlete: widget.athlete!)) {
      final List<PowerZoneSchema> powerZoneSchemas =
          await widget.athlete!.powerZoneSchemas;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (powerZoneSchemas.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<BuildContext>(
            builder: (BuildContext _) =>
                OnBoardingPowerZoneSchemaScreen(athlete: widget.athlete),
          ),
        );
      } else {
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Row(
            children: [
              MyIcon.error,
              const Text('The credentials provided are invalid!'),
            ],
          ),
        ),
      );
    }
  }
}
