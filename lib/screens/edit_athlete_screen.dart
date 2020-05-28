import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:provider/provider.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'strava_get_user.dart';

class EditAthleteScreen extends StatelessWidget {
  const EditAthleteScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.athlete,
        title: const Text('Create Athlete'),
      ),
      body: ChangeNotifierProvider.value(
        value: athlete,
        child: Consumer<Athlete>(
          builder: (BuildContext context, Athlete athlete, Widget _child) =>
              editAthleteForm(athlete, context),
        ),
      ),
    );
  }

  Widget editAthleteForm(Athlete athlete, BuildContext context) {
    if (athlete.db == null ||
        (athlete.db.stravaId == null && athlete.db.state != 'standalone')) {
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
                  subtitle:
                      const Text('Choose this option, if you want to download most '
                          'of the activities from Strava'),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('Connect to Strava'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                StravaGetUser(athlete: athlete),
                          ),
                        );
                      },
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
                  subtitle: const Text('Choose this option, if you want to upload all'
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
    } else if (athlete.db.state == 'standalone') {
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
            initialValue: athlete.db.firstName,
            onChanged: (value) => athlete.firstName = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Last name'),
            initialValue: athlete.db.lastName,
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
              title:
                  const Text('Step 2 of 2: Credentials for Strava Web Site scraping'),
            ),
          ),
          ListTile(
            leading: const Text('First Name'),
            title: Text(athlete.db.firstName ?? 't.b.d.'),
          ),
          ListTile(
            leading: const Text('Last Name'),
            title: Text(athlete.db.lastName ?? 't.b.d.'),
          ),
          ListTile(
            leading: const Text('Strava ID'),
            title: Text(athlete.db.stravaId?.toString() ?? 't.b.d.'),
          ),
          ListTile(
            leading: const Text('Strava Username'),
            title: Text(athlete.db.stravaUsername ?? 't.b.d.'),
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

  saveStravaUser(BuildContext context) async {
    await athlete.db.save();
    await athlete.storeCredentials();
    Navigator.of(context).pop();
  }

  saveStandaloneUser(BuildContext context) async {
    athlete.db.firstName = athlete.firstName ?? athlete.db.firstName;
    athlete.db.lastName = athlete.lastName ?? athlete.db.lastName;
    await athlete.save();

    Navigator.of(context).pop();
  }
}
