import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/widgets/boarding_widget.dart';
import 'edit_athlete_screen.dart';
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
    if (athletes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          title: const Text('Welcome to Encrateia!'),
        ),
        body: const BoardingWidget(),
      );
    } else
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          title: const Text('Encrateia Dashboard'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            for (Athlete athlete in athletes)
              Card(
                child: ListTile(
                  leading: athlete.photoPath != null
                      ? Image.network(athlete.photoPath)
                      : MyIcon.runningBig,
                  title: Text('${athlete.firstName} ${athlete.lastName}'),
                  onTap: () async {
                    await athlete.readCredentials();
                    await Navigator.push(
                      context,
                      MaterialPageRoute<BuildContext>(
                        builder: (BuildContext context) =>
                            ShowAthleteScreen(athlete: athlete),
                      ),
                    );
                    getData();
                  },
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: MyColor.add,
          label: const Text('Add Athlete'),
          onPressed: () => goToEditAthleteScreen(athlete: Athlete()),
        ),
      );
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

  Future<void> getData() async {
    athletes = await Athlete.all();
    setState(() {});
  }
}
