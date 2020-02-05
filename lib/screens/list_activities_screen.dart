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
  Flushbar flushbar;
  Visibility floatingActionButton;
  bool floatingActionButtonVisible;

  @override
  void initState() {
    floatingActionButtonVisible =
    (widget.athlete.email != null && widget.athlete.password != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: floatingActionButtonVisible,
        child: FloatingActionButton.extended(
          onPressed: () => updateJob(),
          label: Text("from Strava"),
          icon: MyIcon.stravaDownload,
        ),
      ),
      appBar: AppBar(title: Text('Activities')),
      body: ActivitiesListWidget(athlete: widget.athlete),
    );
  }

  updateJob() async {
    List<Activity> activities;
    setState(() => floatingActionButtonVisible = false);
    print(floatingActionButtonVisible);

    await queryStrava();

    activities = await Activity.all();
    var newActivities =
        activities.where((activity) => activity.db.state == "new");
    for (Activity activity in newActivities) {
      await download(activity: activity);
    }

    var downloadedActivities =
        activities.where((activity) => activity.db.state == "downloaded");
    for (Activity activity in downloadedActivities) {
      await parse(activity: activity);
    }

    flushbar.dismiss();
    Flushbar(
      message: "Download Job finished",
      duration: Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    setState(() => floatingActionButtonVisible = true);
  }

  Future queryStrava() async {
    flushbar = Flushbar(
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

  Future download({Activity activity}) async {
    flushbar.dismiss();
    flushbar = Flushbar(
      message: "Download .fit-File for »${activity.db.name}«",
      duration: Duration(seconds: 30),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    await activity.download(athlete: widget.athlete);

    flushbar.dismiss();
    Flushbar(
      message: "Download finished",
      duration: Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    setState(() {});
  }

  Future parse({Activity activity}) async {
    flushbar.dismiss();
    flushbar = Flushbar(
      message: "0% of storing »${activity.db.name}«",
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 1),
      titleText: LinearProgressIndicator(value: 0),
    )..show(context);

    var percentageStream = activity.parse(athlete: widget.athlete);
    await for (var value in percentageStream) {
      flushbar.dismiss();
      flushbar = Flushbar(
        titleText: LinearProgressIndicator(value: value / 100),
        message: "$value% of storing »${activity.db.name}«",
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 1),
      )..show(context);
    }

    setState(() {});
  }
}
