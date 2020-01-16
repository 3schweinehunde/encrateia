import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: FutureBuilder<List<Activity>>(
        future: Activity.all(),
        builder: (context, snapshot) {
          return ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              if (widget.athlete.email != null &&
                  widget.athlete.password != null)
                ListTile(
                  leading: Icon(Icons.cloud_download),
                  title: Text("Download Activities from Strava"),
                  onTap: () => Activity.queryStrava(athlete: athlete),
                ),
              if (widget.athlete.password == null)
                ListTile(
                  leading: Icon(Icons.error),
                  title: Text("Strava password not provided yet!"),
                ),
              if (widget.athlete.email == null)
                ListTile(
                  leading: Icon(Icons.error),
                  title: Text("Strava email not provided yet!"),
                ),
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data.length > 0)
                for (Activity activity in snapshot.data)
                  ListTile(
                    leading: Icon(Icons.directions_run),
                    title: Text("${activity.db.type} "
                        "${activity.db.stravaId}"),
                    subtitle: Text(activity.db.name ?? "Activity"),
                    trailing: ChangeNotifierProvider.value(
                      value: activity,
                      child: Consumer<Activity>(
                        builder: (context, activity, _child) =>
                            stateIcon(activity, widget.athlete),
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }

  stateIcon(Activity activity, Athlete athlete) {
    switch (activity.db.state) {
      case "new":
        return IconButton(
          icon: Icon(Icons.cloud_download),
          onPressed: () => activity.download(athlete: athlete),
          tooltip: 'Download',
        );
        break;
      case "downloaded":
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.details),
              onPressed: () => activity.parse(athlete: athlete),
              tooltip: 'Parse .fit-file',
            ),
            IconButton(
              icon: Icon(Icons.cloud_download),
              onPressed: () => activity.download(athlete: athlete),
              tooltip: 'Download',
            ),
          ],
        );
        break;
      default:
        return Text(activity.db.state);
    }
  }
}
