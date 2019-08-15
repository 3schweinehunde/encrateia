import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encrateia',
      theme: ThemeData(
        primarySwatch: Colors.orange, // #ff9800
      ),
      home: Dashboard(title: 'Encrateia Dashboard'),
    );
  }
}

class Dashboard extends StatelessWidget {
  final String title;
  Widget widget;

  Dashboard({this.title});

  @override
  Widget build(BuildContext context) {
    if (true) {
      widget = ListView(padding: EdgeInsets.all(20), children: <Widget>[
      Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.help),
              title: Text('Welcome to Encrateia!'),
              subtitle: Text('Maybe you want to learn more about Encrateia.'
              'We have provided some introductory help for you.')
          ),
          ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('HELP'),
                    onPressed: () {},
                  )
                ],
              ))
        ],
      )),

        Card(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.face),
                title: Text('Who are you?'),
                subtitle: Text('This app stores date associated to one athlete '
                    '(you) or many athletes (if you act as a trainer).'
                    '\n Please create your first athlete!')),
            ButtonTheme.bar(
                child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('CREATE NEW ATHLETE'),
                  onPressed: () {},
                )
              ],
            ))
          ],
        ))
      ]);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: widget);
  }
}
