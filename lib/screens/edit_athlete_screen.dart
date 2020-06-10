import 'package:encrateia/models/strava_fit_download.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'strava_get_user.dart';

class EditAthleteScreen extends StatefulWidget {
  const EditAthleteScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _EditAthleteScreenState createState() => _EditAthleteScreenState();
}

class _EditAthleteScreenState extends State<EditAthleteScreen> {
  Flushbar<Object> flushbar = Flushbar<Object>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.athlete,
        title: const Text('Create Athlete'),
      ),
      body: editAthleteForm(widget.athlete, context),
    );
  }

  Widget editAthleteForm(Athlete athlete, BuildContext context) {
    if (athlete.id == null ||
        (athlete.stravaId == null && athlete.state != 'standalone')) {
      // Strava Connection Card
      return ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: MyIcon.download,
                  title: const Text('Option 1: Strava Connection'),
                  subtitle: const Text(
                      'Choose this option, if you want to download most '
                      'of the activities from Strava'),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('Connect to Strava'),
                      onPressed: () => stravaGetUser(context),
                    )
                  ],
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: MyIcon.upload,
                  title: const Text('Option 2: Standalone User'),
                  subtitle:
                      const Text('Choose this option, if you want to upload all'
                          ' .fit-files manually'),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('Create standalone User'),
                      onPressed: () => athlete.setupStandaloneAthlete(),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else if (athlete.state == 'standalone') {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: ListTile(
              leading: MyIcon.running,
              title: const Text('Step 2 of 2: Enter Your Name'),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'First name'),
            initialValue: athlete.firstName,
            onChanged: (String value) => athlete.firstName = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Last name'),
            initialValue: athlete.lastName,
            onChanged: (String value) => athlete.lastName = value,
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
                  onPressed: () => saveStandaloneUser(context),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: ListTile(
              leading: MyIcon.website,
              title: const Text(
                  'Step 2 of 2: Credentials for Strava Web Site scraping'),
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
      flushbar.dismiss();
      Navigator.of(context).pop();
    } else
      flushbar = Flushbar<Object>(
        icon: MyIcon.error,
        message: 'The credentials provided are invalid!',
        duration: const Duration(seconds: 10),
      )..show(context);
  }

  Future<void> saveStandaloneUser(BuildContext context) async {
    widget.athlete.firstName =
        widget.athlete.firstName ?? widget.athlete.firstName;
    widget.athlete.lastName =
        widget.athlete.lastName ?? widget.athlete.lastName;
    await widget.athlete.save();
    Navigator.of(context).pop();
  }

  Future<void> stravaGetUser(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) =>
            StravaGetUser(athlete: widget.athlete),
      ),
    );
    setState(() {});
  }
}
