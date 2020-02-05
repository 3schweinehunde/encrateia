import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/widgets/activities_list_widget.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';

class ListActivitiesScreen extends StatefulWidget {
  final Athlete athlete;

  const ListActivitiesScreen({Key key, this.athlete}) : super(key: key);

  @override
  _ListActivitiesScreenState createState() => _ListActivitiesScreenState();
}

class _ListActivitiesScreenState extends State<ListActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(),
      appBar: AppBar(
        title: Text('Activities')
      ),
      body: ActivitiesListWidget(athlete: widget.athlete),
    );
  }

  floatingActionButton() {
    if (widget.athlete.email != null && widget.athlete.password != null) {
      return FloatingActionButton.extended(
        onPressed: () => queryStrava(),
        label: Text("from Strava"),
        icon: MyIcon.stravaDownload,
      );
    } else {
      return Container();
    }
  }

  Future queryStrava() async {
    var flushbar = Flushbar(
      message: "Downloading new activities",
      duration: Duration(seconds: 30),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);
    await Activity.queryStrava(athlete: widget.athlete);
    flushbar.dismiss();
    Flushbar(
      message: "Download finished",
      duration: Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    setState(() {});
  }
}
