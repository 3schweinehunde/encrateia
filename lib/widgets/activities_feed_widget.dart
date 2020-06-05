import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrateia/screens/show_activity_screen.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:encrateia/utils/enums.dart';

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
      padding: const EdgeInsets.only(top: 20),
      itemCount: activities.length,
      itemBuilder: (BuildContext context, int index) {
        final Activity activity = activities[index];
        return ListTile(
          leading: sportsIcon(sport: activity.db.sport),
          title: Text(activity.db.name ?? 'Activity'),
          subtitle: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(activity.dateString() + '\n' + activity.distanceString()),
                const SizedBox(width: 20),
                Text(activity.paceString()),
                const SizedBox(width: 20),
                Text(activity.heartRateString() +
                    '\n' +
                    activity.averagePowerString()),
              ],
            ),
          ),
          trailing: ChangeNotifierProvider<Activity>.value(
            value: activity,
            child: Consumer<Activity>(
              builder:
                  (BuildContext context, Activity activity, Widget _child) =>
                      popupMenuButton(activity: activity),
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

  Future<void> parse({Activity activity}) async {
    Flushbar<Object> flushbar = Flushbar<Object>(
      message: '0% of storing »${activity.db.name}«',
      duration: const Duration(seconds: 10),
      animationDuration: const Duration(milliseconds: 1),
      titleText: const LinearProgressIndicator(value: 0),
    )..show(context);

    final Stream<int> percentageStream =
        activity.parse(athlete: widget.athlete);
    await for (final int value in percentageStream) {
      flushbar.dismiss();
      flushbar = Flushbar<Object>(
        titleText: LinearProgressIndicator(value: value / 100),
        message: '$value% of storing »${activity.db.name}«',
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 1),
      )..show(context);
    }
    activities = await Activity.all(athlete: widget.athlete);
    setState(() {});
  }

  Future<void> getActivities() async {
    activities = await Activity.all(athlete: widget.athlete);
    setState(() {});
  }

  PopupMenuButton<ActivityAction> popupMenuButton({Activity activity}) {
    List<String> actions;

    switch (activity.db.state) {
      case 'downloaded':
      case 'persisted':
        actions = <String>['parse'];
        break;
    }

    return PopupMenuButton<ActivityAction>(
      onSelected: (ActivityAction action) {
        switch (action) {
          case ActivityAction.parse:
            parse(activity: activity);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ActivityAction>>[
        if (actions.contains('parse'))
          PopupMenuItem<ActivityAction>(
            value: ActivityAction.parse,
            child: Row(
              children: <Widget>[
                MyIcon.parse,
                const Text(' Parse .fit-file'),
              ],
            ),
          ),
      ],
    );
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
