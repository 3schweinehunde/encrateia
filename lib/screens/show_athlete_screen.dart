import 'package:encrateia/widgets/athlete_widgets/athlete_power_ratio_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/widgets/activities_list_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_stride_ratio_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_settings_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_speed_per_heart_rate_widget.dart';
import 'package:encrateia/screens/show_athlete_detail_screen.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';

class ShowAthleteScreen extends StatefulWidget {
  final Athlete athlete;

  const ShowAthleteScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  @override
  _ShowAthleteScreenState createState() => _ShowAthleteScreenState();
}

class _ShowAthleteScreenState extends State<ShowAthleteScreen> {
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
      appBar: AppBar(
        title: Text(
          '${widget.athlete.db.firstName} ${widget.athlete.db.lastName}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      floatingActionButton: Visibility(
        visible: floatingActionButtonVisible,
        child: FloatingActionButton.extended(
          onPressed: () => updateJob(),
          label: Text("from Strava"),
          icon: MyIcon.stravaDownload,
        ),
      ),
      body: Table(children: [
        TableRow(children: [
          detailTile(
            title: "Activities List",
            icon: MyIcon.activities,
            nextWidget: ActivitiesListWidget(athlete: widget.athlete),
          ),
          detailTile(
            title: "Settings",
            icon: MyIcon.settings,
            nextWidget: AthleteSettingsWidget(athlete: widget.athlete),
          ),
        ]),
        TableRow(children: [
          detailTile(
            title: "Power",
            icon: MyIcon.power,
            nextWidget: AthletePowerWidget(athlete: widget.athlete),
          ),
          detailTile(
            title: "Power Ratio",
            icon: MyIcon.power,
            nextWidget: AthletePowerRatioWidget(athlete: widget.athlete),
          ),
        ]),
        TableRow(children: [
          detailTile(
            title: "Power / Heart Rate",
            icon: MyIcon.power,
            nextWidget: AthletePowerPerHeartRateWidget(athlete: widget.athlete),
          ),
          detailTile(
            title: "Speed / Heart Rate",
            icon: MyIcon.speed,
            nextWidget: AthleteSpeedPerHeartRateWidget(athlete: widget.athlete),
          ),
        ]),
        TableRow(children: [
          detailTile(
            title: "Stride Ratio",
            icon: MyIcon.strideRatio,
            nextWidget: AthleteStrideRatioWidget(athlete: widget.athlete),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: MyIcon.settings,
              title: Text("Recalculate Averages"),
              onTap: () => recalculate(),
            ),
          ),
        ]),
        TableRow(children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: MyIcon.downloadLocal,
              title: Text("Import from Local Directory"),
              onTap: () => importLocal(),
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: MyIcon.delete,
              title: Text("Delete Athlete"),
              onTap: () => deleteUser(),
            ),
          ),
        ]),
      ]),
    );
  }

  detailTile({
    Widget nextWidget,
    Widget icon,
    String title,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: ListTile(
        leading: icon,
        title: Text(title),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowAthleteDetailScreen(
              athlete: widget.athlete,
              widget: nextWidget,
              title: title,
            ),
          ),
        ),
      ),
    );
  }

  recalculate() async {
    print("Start");
    List<Activity> activities;
    activities = await Activity.all(athlete: widget.athlete);
    int index = 0;
    int percent;

    flushbar = Flushbar(
      message: "Calculating...",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);

    for (Activity activity in activities) {
      index += 1;
      await activity.recalculateAverages();
      flushbar.dismiss();
      percent = 100 * index ~/ activities.length;
      flushbar = Flushbar(
        titleText: LinearProgressIndicator(value: percent / 100),
        message: "$percent% done (recalculating »${activity.db.name}« )",
        duration: Duration(seconds: 2),
        animationDuration: Duration(milliseconds: 1),
      )..show(context);
    }

    flushbar.dismiss();
    Flushbar(
      message: "Averages are now up to date.",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  }

  importLocal() async {
    List<Activity> activities;

    flushbar = Flushbar(
      message: "Importing activities from local directory",
      duration: Duration(seconds: 1),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);
    await Activity.importFromLocalDirectory(athlete: widget.athlete);
    flushbar = Flushbar(
      message: "Activities moved into application",
      duration: Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    activities = await Activity.all(athlete: widget.athlete);
    var downloadedActivities = activities
        .where((activity) => activity.db.state == "downloaded")
        .toList();
    for (Activity activity in downloadedActivities) {
      await parse(activity: activity);
    }
    flushbar.dismiss();
    flushbar = Flushbar(
      message: "Activities imported!",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  }

  updateJob() async {
    List<Activity> activities;
    setState(() => floatingActionButtonVisible = false);

    await queryStrava();

    activities = await Activity.all(athlete: widget.athlete);
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
      message: "You are now up to date!",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);

    setState(() => floatingActionButtonVisible = true);
  }

  Future queryStrava() async {
    flushbar = Flushbar(
      message: "Downloading new activities",
      duration: Duration(seconds: 10),
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
      duration: Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    await activity.download(athlete: widget.athlete);

    flushbar.dismiss();
    Flushbar(
      message: "Download finished",
      duration: Duration(seconds: 2),
      icon: MyIcon.finishedWhite,
    )..show(context);
    setState(() {});
  }

  Future parse({Activity activity}) async {
    flushbar.dismiss();
    flushbar = Flushbar(
      message: "0% of storing »${activity.db.name}«",
      duration: Duration(seconds: 10),
      animationDuration: Duration(milliseconds: 1),
      titleText: LinearProgressIndicator(value: 0),
    )..show(context);

    var percentageStream = activity.parse(athlete: widget.athlete);
    await for (var value in percentageStream) {
      flushbar.dismiss();
      flushbar = Flushbar(
        titleText: LinearProgressIndicator(value: value / 100),
        message: "$value% of storing »${activity.db.name}«",
        duration: Duration(seconds: 20),
        animationDuration: Duration(milliseconds: 1),
      )..show(context);
    }
    setState(() {});
  }

  deleteUser() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('All the athlete\'s data including'),
                Text('activities will be deleted as well.'),
                Text('There is no undo function.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () => deleteAthleteAndPop(),
            ),
          ],
        );
      },
    );
  }

  deleteAthleteAndPop() async{
    await widget.athlete.delete();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
