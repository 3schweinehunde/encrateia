import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'edit_athlete_screen.dart';
import 'indroduction_screen.dart';
import 'show_athlete_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Athlete> athletes = <Athlete>[];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          title: const Text('Encrateia Dashboard'),
        ),
        body: dashboardBody(),
        floatingActionButton: floatingActionButton());
  }

  Future<void> getData() async {
    athletes = await Athlete.all();
    setState(() {});
  }

  Future<void> goToListActivitiesScreen({Athlete athlete}) async {
    await athlete.readCredentials();
    await Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) => ShowAthleteScreen(athlete: athlete),
      ),
    );
    getData();
  }

  Future<void> goToEditAthleteScreen({Athlete athlete}) async {
    await athlete.readCredentials();
    await Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) => EditAthleteScreen(athlete: athlete),
      ),
    );
    getData();
  }

  Widget dashboardBody() {
    if (athletes.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: MyIcon.information,
                  title: const Text('Welcome to Encrateia!'),
                  subtitle: const Text(
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
                          MaterialPageRoute<BuildContext>(
                            builder: (BuildContext context) =>
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
          addUserCard()
        ],
      );
    } else {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          for (Athlete athlete in athletes)
            Card(
              child: ListTile(
                leading: photoOrImage(athlete: athlete),
                title: Text('${athlete.firstName} ${athlete.lastName}'),
                onTap: () => goToListActivitiesScreen(athlete: athlete),
              ),
            ),
        ],
      );
    }
  }

  Widget photoOrImage({Athlete athlete}) {
    if (athlete.photoPath != null)
      return Image.network(athlete.photoPath);
    else
      return MyIcon.runningBig;
  }

  Widget addUserCard() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: MyIcon.athlete,
            title: const Text('Who are you?'),
            subtitle: const Text(
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

  Widget floatingActionButton() {
    if (athletes.isNotEmpty) {
      return FloatingActionButton.extended(
        backgroundColor: MyColor.add,
        label: const Text('Add Athlete'),
        onPressed: () => goToEditAthleteScreen(athlete: Athlete()),
      );
    } else
      return null;
  }
}
