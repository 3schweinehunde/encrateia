import 'package:flutter/material.dart';
import '../utils/my_color.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/screens/show_activity_screen.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/pg_text.dart';

class ActivitiesListWidget extends StatefulWidget {
  const ActivitiesListWidget({Key? key, required this.athlete})
      : super(key: key);

  final Athlete athlete;

  @override
  _ActivitiesListWidgetState createState() => _ActivitiesListWidgetState();
}

class _ActivitiesListWidgetState extends State<ActivitiesListWidget> {
  List<Activity> activities = <Activity>[];

  @override
  void initState() {
    getActivities();
    WidgetsBinding.instance!.addPostFrameCallback((_) => showMyFlushbar());
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

  Icon sportsIcon({String? sport}) {
    switch (sport) {
      case 'running':
        return MyIcon.running;
      case 'cycling':
        return MyIcon.cycling;
      default:
        return MyIcon.sport;
    }
  }

  Future<void> delete({required Activity activity}) async {
    await activity.delete();
    getActivities();
  }

  Future<void> download({required Activity activity}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Row(
          children: [
            MyIcon.stravaDownloadWhite,
            Text(' Download .fit-File for »${activity.name}«'),
          ],
        ),
      ),
    );

    await activity.download(athlete: widget.athlete);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text(' Download finished'),
          ],
        ),
      ),
    );

    setState(() {});
  }

  Future<void> parse({required Activity activity}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Row(
          children: [
            CircularProgressIndicator(value: 0, color: MyColor.progress),
            Text(' storing »${activity.name}«'),
          ],
        ),
      ),
    );

    final Stream<int> percentageStream =
        activity.parse(athlete: widget.athlete);
    await for (final int value in percentageStream) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              CircularProgressIndicator(value: value / 100, color: MyColor.progress),
              Text(' storing »${activity.name}«'),
            ],
          ),
        ),
      );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.yellow,
            content: Text('Strava email not provided yet!'),
          ),
        );
      } else if (widget.athlete.password == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            content: Text('Strava password not provided yet!'),
          ),
        );
      }
    }
  }
}
