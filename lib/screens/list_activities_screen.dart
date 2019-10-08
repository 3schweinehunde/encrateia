import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';

class ListActivitiesScreen extends StatefulWidget {
  DbAthlete athlete;
  ListActivitiesScreen({this.athlete});

  @override
  _ListActivitiesScreenState createState() => _ListActivitiesScreenState();
}

class _ListActivitiesScreenState extends State<ListActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.cloud_download),
            title: Text("Download Activities from Strava"),
          )
        ],
      ),
    );
  }
}
