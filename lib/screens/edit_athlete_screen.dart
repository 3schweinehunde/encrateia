import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:provider/provider.dart';
import 'strava_get_user.dart';
import 'package:encrateia/utils/icon_utils.dart';

class EditAthleteScreen extends StatelessWidget {
  final Athlete athlete;

  const EditAthleteScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Athlete'),
      ),
      body: ChangeNotifierProvider.value(
        value: athlete,
        child: Consumer<Athlete>(
          builder: (context, athlete, _child) =>
              editAthleteForm(athlete, context),
        ),
      ),
    );
  }

  Widget editAthleteForm(Athlete athlete, BuildContext context) {
    if (athlete.db == null ||
        (athlete.db.stravaId == null && athlete.db.state != "standalone")) {
      // Strava Connection Card
      return ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: MyIcon.download,
                  title: Text('Option 1: Strava Connection'),
                  subtitle:
                      Text('Choose this option, if you want to download most '
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
                            builder: (context) =>
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
                  title: Text('Option 2: Standalone User'),
                  subtitle: Text('Choose this option, if you want to upload all'
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
    } else if (athlete.db.state == "standalone") {
      return ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: ListTile(
              leading: MyIcon.running,
              title: Text('Step 2 of 2: Enter Your Name'),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "First name"),
            initialValue: athlete.db.firstName,
            onChanged: (value) => athlete.firstName = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Last name"),
            initialValue: athlete.db.lastName,
            onChanged: (value) => athlete.lastName = value,
          ),

          // Cancel and Save Card
          Padding(
            padding: EdgeInsets.all(15),
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
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: ListTile(
              leading: MyIcon.website,
              title:
                  Text('Step 2 of 2: Credentials for Strava Web Site scraping'),
            ),
          ),
          ListTile(
            leading: Text("First Name"),
            title: Text(athlete.db.firstName ?? 't.b.d.'),
          ),
          ListTile(
            leading: Text("Last Name"),
            title: Text(athlete.db.lastName ?? 't.b.d.'),
          ),
          ListTile(
            leading: Text("Strava ID"),
            title: Text(athlete.db.stravaId?.toString() ?? 't.b.d.'),
          ),
          ListTile(
            leading: Text("Strava Username"),
            title: Text(athlete.db.stravaUsername ?? 't.b.d.'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Email"),
            initialValue: athlete.email,
            onChanged: (value) => athlete.email = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Password"),
            onChanged: (value) => athlete.password = value,
            initialValue: athlete.password,
            obscureText: true,
          ),

          // Cancel and Save Card
          Padding(
            padding: EdgeInsets.all(15),
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
