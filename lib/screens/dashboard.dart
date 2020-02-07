import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'edit_athlete_screen.dart';
import 'package:encrateia/models/athlete.dart';
import 'indroduction_screen.dart';
import 'show_athlete_screen.dart';
import 'package:encrateia/utils/icon_utils.dart';

class Dashboard extends StatefulWidget {
  Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<List<Athlete>> athletes;

  @override
  void initState() {
    athletes = Athlete.all();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Encrateia Dashboard")),
      body: FutureBuilder<List<Athlete>>(
          future: athletes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.length == 0) {
                return ListView(
                  padding: EdgeInsets.all(20),
                  children: <Widget>[
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: MyIcon.information,
                            title: Text('Welcome to Encrateia!'),
                            subtitle: Text(
                              'Maybe you want to learn a bit about Encrateia.'
                              'We have provided some introductory text for you.',
                            ),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('Introduction'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          IntroductionScreen(),
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
                          leading: MyIcon.athlete,
                          title: Text('Who are you?'),
                          subtitle: Text(
                            'This app stores date associated to one athlete '
                            '(you) or many athletes (if you act as a trainer).',
                          ),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('Create a new Athlete'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditAthleteScreen(
                                      athlete: Athlete(),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        )
                      ],
                    ))
                  ],
                );
              } else {
                return ListView(
                  padding: EdgeInsets.all(40),
                  children: <Widget>[
                    for (Athlete athlete in snapshot.data)
                      ListTile(
                        leading: Image.network(athlete.db.photoPath),
                        title: Text(
                            "${athlete.db.firstName} ${athlete.db.lastName} - ${athlete.db.stravaId}"),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () => navigateToListActivitiesScreen(
                                  athlete: athlete),
                              child: Text("Analyze"),
                            ),
                            RaisedButton(
                              onPressed: () =>
                                  navigateToEditAthleteScreen(athlete: athlete),
                              child: MyIcon.edit,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  navigateToListActivitiesScreen({Athlete athlete}) async {
    await athlete.readCredentials();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowAthleteScreen(athlete: athlete),
      ),
    );
  }

  navigateToEditAthleteScreen({Athlete athlete}) async {
    await athlete.readCredentials();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAthleteScreen(athlete: athlete),
      ),
    );
  }
}
