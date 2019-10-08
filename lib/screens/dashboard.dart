import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'edit_athlete.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/utils/db.dart';
import 'list_activities_screen.dart';

class Dashboard extends StatefulWidget {
  Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<List<DbAthlete>> athletes;

  @override
  void initState() {
    Db.create().connect();
    athletes = DbAthlete().select().toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Encrateia Dashboard")),
      body: FutureBuilder<List<DbAthlete>>(
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
                            leading: Icon(Icons.help),
                            title: Text('Welcome to Encrateia!'),
                            subtitle: Text(
                                'Maybe you want to learn more about Encrateia.'
                                'We have provided some introductory help for you.'),
                          ),
                          ButtonTheme.bar(
                            child: ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text('HELP'),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Card(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.face),
                          title: Text('Who are you?'),
                          subtitle: Text(
                              'This app stores date associated to one athlete '
                              '(you) or many athletes (if you act as a trainer).'
                              '\n Please create your first athlete!'),
                        ),
                        ButtonTheme.bar(
                            child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('CREATE NEW ATHLETE'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScopedModel<Athlete>(
                                      model: Athlete(),
                                      child: EditAthleteScreen(),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ))
                      ],
                    ))
                  ],
                );
              } else {
                return ListView(
                  padding: EdgeInsets.all(40),
                  children: <Widget>[
                    Text(
                      "Select the athlete to analyze:",
                      style: Theme.of(context).textTheme.title,
                    ),
                    for (DbAthlete athlete in snapshot.data)
                      ListTile(
                          leading: Image.network(athlete.photoPath),
                          title:
                              Text("${athlete.firstName} ${athlete.lastName}"),
                          subtitle: Text("${athlete.stravaId}"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScopedModel<Athlete>(
                                  model: Athlete(),
                                  child: ListActivitiesScreen(athlete: athlete),
                                ),
                              ),
                            );
                          },)
                  ],
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
