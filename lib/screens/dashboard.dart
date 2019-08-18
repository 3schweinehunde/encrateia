import 'package:flutter/material.dart';
import 'edit_athlete.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/models/athlete.dart';

class Dashboard extends StatelessWidget {
  final String title;

  Dashboard({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Welcome to Encrateia!'),
                  subtitle: Text('Maybe you want to learn more about Encrateia.'
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
                subtitle: Text('This app stores date associated to one athlete '
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
      ),
    );
  }
}
