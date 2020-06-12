import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'edit_athlete_screen.dart';
import 'introduction_screen.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<BuildContext>(
                              builder: (BuildContext _) => IntroductionScreen(),
                            ),
                          ))
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
                    onPressed: () async {
                      final Athlete athlete = Athlete();
                      await athlete.readCredentials();
                      await Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) =>
                              EditAthleteScreen(athlete: athlete),
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
