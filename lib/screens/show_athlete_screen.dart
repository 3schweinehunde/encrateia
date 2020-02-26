import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/widgets/activities_list_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_widget.dart';
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
          )
        ]),
        TableRow(children: [
          detailTile(
            title: "Power",
            icon: MyIcon.power,
            nextWidget: AthletePowerWidget(athlete: widget.athlete),
          ),
          detailTile(
            title: "Power / Heart Rate",
            icon: MyIcon.power,
            nextWidget: AthletePowerPerHeartRateWidget(athlete: widget.athlete),
          ),
        ]),
        TableRow(children: [
          detailTile(
            title: "Speed / Heart Rate",
            icon: MyIcon.speed,
            nextWidget: AthleteSpeedPerHeartRateWidget(athlete: widget.athlete),
          ),
          Text(""),
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
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 1),
      )..show(context);
    }

    setState(() {});
  }
}
