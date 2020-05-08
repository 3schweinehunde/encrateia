import 'package:encrateia/utils/my_color.dart';
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
  List<Athlete> athletes = [];

  @override
  void initState() {
    getAthletes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          title: Text("Encrateia Dashboard"),
        ),
        body: dashboardBody(),
        floatingActionButton: floatingActionButton());
  }

  getAthletes() async {
    athletes = await Athlete.all();
    setState(() {});
  }

  goToListActivitiesScreen({Athlete athlete}) async {
    await athlete.readCredentials();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowAthleteScreen(athlete: athlete),
      ),
    );
    getAthletes();
  }

  goToEditAthleteScreen({Athlete athlete}) async {
    await athlete.readCredentials();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAthleteScreen(athlete: athlete),
      ),
    );
    getAthletes();
  }

  dashboardBody() {
    if (athletes.length == 0) {
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
                            builder: (context) => IntroductionScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          addUserCard()
        ],
      );
    } else {
      return ListView(
        padding: EdgeInsets.only(top: 20),
        children: <Widget>[
          for (Athlete athlete in athletes)
            ListTile(
              leading: photoOrImage(athlete: athlete),
              title: Text(
                  "${athlete.db.firstName} ${athlete.db.lastName} ${stravaIdString(athlete: athlete)}"),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton.icon(
                    icon: MyIcon.analyze,
                    color: MyColor.athlete,
                    onPressed: () => goToListActivitiesScreen(athlete: athlete),
                    label: Text("Analyze"),
                  ),
                  RaisedButton.icon(
                    icon: MyIcon.edit,
                    color: MyColor.settings,
                    onPressed: () => goToEditAthleteScreen(athlete: athlete),
                    label: Text("Edit"),
                  ),
                ],
              ),
            ),
        ],
      );
    }
  }

  stravaIdString({Athlete athlete}) {
    if (athlete.db.stravaId != null)
      return "- ${athlete.db.stravaId}";
    else
      return "";
  }

  photoOrImage({Athlete athlete}) {
    if (athlete.db.photoPath != null)
      return Image.network(athlete.db.photoPath);
    else
      return MyIcon.runningBig;
  }

  addUserCard() {
    return Card(
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
                onPressed: () => goToEditAthleteScreen(athlete: Athlete()),
              )
            ],
          )
        ],
      ),
    );
  }

  floatingActionButton() {
    if (athletes.length != 0) {
      return FloatingActionButton.extended(
        backgroundColor: MyColor.add,
        label: const Text('Add Athlete'),
        onPressed: () => goToEditAthleteScreen(athlete: Athlete()),
      );
    }
  }
}
