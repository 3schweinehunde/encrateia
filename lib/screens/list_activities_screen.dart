import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';

class ListActivitiesScreen extends StatefulWidget {
  final Athlete athlete;

  const ListActivitiesScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  @override
  _ListActivitiesScreenState createState() => _ListActivitiesScreenState();
}

class _ListActivitiesScreenState extends State<ListActivitiesScreen> {
  Future<List<Activity>> activities;

  @override
  void initState() {
    super.initState();
    activities = Activity.all();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: FutureBuilder<List<Activity>>(
        future: activities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data.length > 0) {
            final activities = snapshot.data.map((activity) => activity);
            return ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.cloud_download),
                  title: Text("Download Activities from Strava"),
                  onTap: () {
                    setState(() {
                      Activity.queryStrava();
                    });
                  },
                ),
                for (Activity activity in activities)
                  ListTile(
                    leading: Icon(Icons.directions_run),
                    title: Text("${activity.db.type} "
                        "${activity.db.stravaId}"),
                    subtitle: Text(activity.db.name ?? "Activity"),
                    trailing: stateIcon(activity, widget.athlete),
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
                    setState(() {
                      Activity.queryStrava();
                    });
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  stateIcon(Activity activity, Athlete athlete) {
    switch (activity.state) {
      case "new":
        return IconButton(
          icon: Icon(Icons.cloud_download),
          onPressed: () {
            setState(() {
              activity.download(athlete: athlete);
            });
          },
          tooltip: 'Download',
        );
        break;
      case "fromDatabase":
        return IconButton(
          icon: Icon(Icons.save_alt),
          onPressed: () {
            setState(() {
              activity.download(athlete: athlete);
            });
          },
          tooltip: 'Parse .fit-file',
        );
        break;
      default:
        return Text(activity.state);
    }
  }
}
