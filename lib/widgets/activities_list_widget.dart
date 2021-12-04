import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/screens/show_activity_screen.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ActivitiesListWidget extends StatefulWidget {
  const ActivitiesListWidget({Key key, this.athlete}) : super(key: key);

  final Athlete athlete;

  @override
  _ActivitiesListWidgetState createState() => _ActivitiesListWidgetState();
}

class _ActivitiesListWidgetState extends State<ActivitiesListWidget> {
  List<Activity> activities = <Activity>[];
  Flushbar<Object> flushbar;

  @override
  void initState() {
    getActivities();
    WidgetsBinding.instance.addPostFrameCallback((_) => showMyFlushbar());
    super.initState();
  }

  @override
  void didUpdateWidget(ActivitiesListWidget oldWidget) {
    getActivities();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      for (Activity activity in activities)
        if (activity.nonParsable == true)
          ListTile(
            dense: true,
            leading: sportsIcon(sport: activity.sport),
            trailing: MyIcon.excluded,
            title: Text(activity.name ?? 'Activity'),
            subtitle: const Text('Activity cannot be parsed. 🙇'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<BuildContext>(
                  builder: (BuildContext context) => ShowActivityScreen(
                    activity: activity,
                    athlete: widget.athlete,
                  ),
                ),
              );
            },
          )
        else
          ListTile(
            dense: true,
            leading: sportsIcon(sport: activity.sport),
            title: Text(activity.name ?? 'Activity'),
            trailing:
                activity.excluded == true ? MyIcon.excluded : const Text(''),
            subtitle: PQText(
              pq: PQ.dateTime,
              value: activity.timeCreated,
              format: DateTimeFormat.longDate,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<BuildContext>(
                  builder: (BuildContext context) => ShowActivityScreen(
                    activity: activity,
                    athlete: widget.athlete,
                  ),
                ),
              );
            },
          )
    ]);
  }

  Icon sportsIcon({String sport}) {
    switch (sport) {
      case 'running':
        return MyIcon.running;
      case 'cycling':
        return MyIcon.cycling;
      default:
        return MyIcon.sport;
    }
  }

  Future<void> delete({Activity activity}) async {
    await activity.delete();
    getActivities();
  }

  Future<void> download({Activity activity}) async {
    flushbar = Flushbar<Object>(
      message: 'Download .fit-File for »${activity.name}«',
      duration: const Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    await activity.download(athlete: widget.athlete);

    flushbar = Flushbar<Object>(
      message: 'Download finished',
      duration: const Duration(seconds: 3),
      icon: MyIcon.finishedWhite,
    )..show(context);

    setState(() {});
  }

  Future<void> parse({Activity activity}) async {
    Flushbar<Object> flushbar = Flushbar<Object>(
      message: '0% of storing »${activity.name}«',
      duration: const Duration(seconds: 10),
      animationDuration: const Duration(milliseconds: 1),
      titleText: const LinearProgressIndicator(value: 0),
    )..show(context);

    final Stream<int> percentageStream =
        activity.parse(athlete: widget.athlete);
    await for (final int value in percentageStream) {
      await flushbar.dismiss();
      flushbar = Flushbar<Object>(
        titleText: LinearProgressIndicator(value: value / 100),
        message: '$value% of storing »${activity.name}«',
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 1),
      )..show(context);
    }
    getActivities();
  }

  Future<void> getActivities() async {
    activities = await widget.athlete.activities;
    setState(() {});
  }

  void showMyFlushbar() {
    if (widget.athlete.stravaId != null) {
      if (widget.athlete.email == null) {
        flushbar = Flushbar<Object>(
          message: 'Strava email not provided yet!',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.yellow[900],
        )..show(context);
      } else if (widget.athlete.password == null) {
        flushbar = Flushbar<Object>(
          message: 'Strava password not provided yet!',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        )..show(context);
      }
    }
  }
}
