import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/screens/show_activity_screen.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';

class ActivitiesFeedWidget extends StatefulWidget {
  const ActivitiesFeedWidget({Key key, this.athlete}) : super(key: key);

  final Athlete athlete;

  @override
  _ActivitiesFeedWidgetState createState() => _ActivitiesFeedWidgetState();
}

class _ActivitiesFeedWidgetState extends State<ActivitiesFeedWidget> {
  List<Activity> activities = <Activity>[];
  Flushbar<Object> flushbar;

  @override
  void initState() {
    getActivities();
    WidgetsBinding.instance.addPostFrameCallback((_) => showMyFlushbar());
    super.initState();
  }

  @override
  void didUpdateWidget(ActivitiesFeedWidget oldWidget) {
    getActivities();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.black,
      ),
      padding: const EdgeInsets.only(top: 10),
      itemCount: activities.length,
      itemBuilder: (BuildContext context, int index) {
        final Activity activity = activities[index];
        return ListTile(
          leading: sportsIcon(sport: activity.db.sport),
          title: Text(activity.db.name ?? 'Activity'),
          subtitle: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(activity.dateString() + '\n' + activity.distanceString()),
                const SizedBox(width: 20),
                Text(activity.paceString() + "\n" + activity.heartRateString()),
                const SizedBox(width: 20),
                Text(activity.averagePowerString()),
              ],
            ),
          ),
          onTap: () async {
            if (activity.db.state == 'persisted') {
              await Navigator.push(
                context,
                MaterialPageRoute<BuildContext>(
                  builder: (BuildContext context) => ShowActivityScreen(
                    activity: activity,
                    athlete: widget.athlete,
                  ),
                ),
              );
              getActivities();
            }
          },
        );
      },
    );
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

  Future<void> getActivities() async {
    activities = await Activity.all(athlete: widget.athlete);
    setState(() {});
  }

  void showMyFlushbar() {
    if (widget.athlete.email == null) {
      flushbar = Flushbar<Object>(
        message: 'Strava email not provided yet or not a Strava User!',
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
