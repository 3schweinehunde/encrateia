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
    if (athlete.db == null || athlete.db.stravaId == null) {
      // Strava Connection Card
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: MyIcon.brokenConnection,
              title: Text('Step 1 of 2: Strava Connection'),
              subtitle: Text('This athlete is not connected to a '
                  'Strava User yet'),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('CONNECT TO STRAVA'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StravaGetUser(athlete: athlete),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      );
    } else {
      return ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          ListTile(
            leading: MyIcon.website,
            title: Text('Step 2 of 2: Credentials for Strava Web Site scraping'),
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
                RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text('Cancel', textScaleFactor: 1.5),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Container(width: 20.0),
                RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text('Save', textScaleFactor: 1.5),
                  onPressed: () => save(context),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  save (BuildContext context) async {
    await athlete.db.save();
    await athlete.storeCredentials();
    Navigator.of(context).pop();
  }
}
