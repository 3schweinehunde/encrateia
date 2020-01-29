import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/widgets/activities_list_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: floatingActionButton(),
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: new ActivitiesListWidget(
        athlete: widget.athlete,
      ),
    );
  }

  floatingActionButton() {
    if (widget.athlete.email != null && widget.athlete.password != null) {
      return FloatingActionButton.extended(
        onPressed: () => queryStrava(),
        label: Text("from Strava"),
        icon: Icon(Icons.cloud_download),
      );
    } else {
      return Container();
    }
  }

  Future queryStrava() async {
    await Activity.queryStrava(athlete: widget.athlete);
    await Activity.all();
    setState(() {});
  }
}
