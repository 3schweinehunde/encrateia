import 'package:encrateia/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:encrateia/utils/db.dart';

class ListActivitiesScreen extends StatefulWidget {
  final DbAthlete athlete;
  ListActivitiesScreen({this.athlete});

  @override
  _ListActivitiesScreenState createState() => _ListActivitiesScreenState();
}

class _ListActivitiesScreenState extends State<ListActivitiesScreen> {
  Future<List<DbActivity>> activities;

  @override
  void initState() {
    Db.create().connect();
    activities = DbActivity().select().toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: FutureBuilder<List<DbActivity>>(
        future: activities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data.length > 0) {
            final activities = snapshot.data.map((dbActivity) => Activity.fromDb(dbActivity));
            return ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.cloud_download),
                  title: Text("Download Activities from Strava"),
                  onTap: () {
                    Activity.queryStrava();
                  },
                ),
                for (Activity activity in activities)
                  ListTile(
                    leading: Icon(Icons.directions_run),
                    title: Text("${activity.type} "
                        "${activity.stravaId}"),
                    subtitle: Text(activity.name),
                    trailing: stateIcon(activity),
                  )
              ],
            );
          } else {
            return ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.cloud_download),
                  title: Text("Download Activities from Strava"),
                  onTap: () {
                    Activity.queryStrava();
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  static stateIcon(Activity activity) {
    switch (activity.state) {
      case "new":
        return IconButton(
          icon: Icon(Icons.cloud_download),
          onPressed: () => activity.download,
        );
        break;
      default:
        return Text(activity.state);
    }
  }
}
