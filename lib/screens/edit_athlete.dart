import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'strava/strava_get_user.dart';
import 'package:scoped_model/scoped_model.dart';

class EditAthleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Athlete'),
        ),
        body: ScopedModel<Athlete>(
          model: Athlete(),
          child: ScopedModelDescendant<Athlete>(
            builder: (context, _, athlete) => ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                ListTile(
                    leading: Text("First Name"),
                    title: Text(athlete?.firstName ?? ""),
                ),
                ListTile(
                  leading: Text("Last Name"),
                  title: Text(athlete?.lastName ?? ""),
                ),
                ListTile(
                  leading: Text("Strava ID"),
                  title: Text(athlete?.stravaId.toString() ?? ""),
                ),
                ListTile(
                  leading: Text("Strava Username"),
                  title: Text(athlete?.stravaUsername ?? ""),
                ),

                // Strava Connection Card
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.link_off),
                        title: Text('Strava Connection'),
                        subtitle: Text('This athlete is not connected to a '
                            'Strava User yet'),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('CONNECT TO STRAVA'),
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
                      )
                    ],
                  ),
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
                        onPressed: null,
                      ),
                      Container(width: 20.0),
                      RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Save', textScaleFactor: 1.5),
                        onPressed: athlete.persist,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
