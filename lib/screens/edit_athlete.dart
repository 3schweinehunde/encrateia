import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:scoped_model/scoped_model.dart';
import 'strava/strava_login.dart';

class EditAthleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, true);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Create Athlete'),
            ),
            body: ScopedModel<Athlete>(
                model: new Athlete(),
                child: new ScopedModelDescendant<Athlete>(
                    builder: (context, child, athlete) =>
                        new ListView(padding: EdgeInsets.all(20), children: <
                            Widget>[
                          TextField(
                              onChanged: (value) => athlete.name = value,
                              decoration: InputDecoration(labelText: 'Name')),

                          // Strava Connection
                          Card(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(Icons.link_off),
                                  title: Text('Strava Connection'),
                                  subtitle:
                                      Text('This athlete is not connected to a '
                                          'Strava User yet')),
                              ButtonTheme.bar(
                                  child: ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    child: const Text('CONNECT TO STRAVA'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StravaLogin()),
                                      );
                                    },
                                  )
                                ],
                              ))
                            ],
                          )),

                          // Cancel and Save
                          Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  RaisedButton(
                                    color: Theme.of(context).primaryColorDark,
                                    textColor:
                                        Theme.of(context).primaryColorLight,
                                    child: Text(
                                      'Cancel',
                                      textScaleFactor: 1.5,
                                    ),
                                    onPressed: () {},
                                  ),
                                  Container(
                                    width: 20.0,
                                  ),
                                  RaisedButton(
                                    color: Theme.of(context).primaryColorDark,
                                    textColor:
                                        Theme.of(context).primaryColorLight,
                                    child: Text(
                                      'Save',
                                      textScaleFactor: 1.5,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              )),
                        ])))));
  }
}
