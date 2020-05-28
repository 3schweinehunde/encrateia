import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrateia/screens/show_activity_screen.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:encrateia/utils/enums.dart';

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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(activity.dateString() + '\n' + activity.distanceString()),
                  Text(activity.timeString() + '\n' + activity.paceString()),
                  Text(activity.heartRateString() +
                      '\n' +
                      activity.averagePowerString()),
                ],
              ),
            ),
            trailing: ChangeNotifierProvider<Activity>.value(
              value: activity,
              child: Consumer<Activity>(
                builder: (BuildContext context, Activity activity, Widget _child) =>
                    popupMenuButton(activity: activity),
              ),
            ),
            onTap: () {
              if (activity.db.state == 'persisted')
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

  Future<void> delete({Activity activity}) async {
    await activity.delete();
    getActivities();
  }

  Future<void> download({Activity activity}) async {
    flushbar = Flushbar<Object>(
      message: 'Download .fit-File for »${activity.db.name}«',
      duration: const Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    await activity.download(athlete: widget.athlete);

    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Download finished',
      duration: const Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    setState(() {});
  }

  Future<void> parse({Activity activity}) async {
    Flushbar<Object> flushbar = Flushbar<Object>(
      message: '0% of storing »${activity.db.name}«',
      duration: const Duration(seconds: 10),
      animationDuration: const Duration(milliseconds: 1),
      titleText: const LinearProgressIndicator(value: 0),
    )..show(context);

    final Stream<int> percentageStream = activity.parse(athlete: widget.athlete);
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
      case 'new':
        actions = <String>['download', 'delete'];
        break;
      case 'downloaded':
      case 'persisted':
        actions = <String>['parse', 'download', 'delete'];
        break;
      case 'default':
        actions = <String>['state'];
    }

    return PopupMenuButton<ActivityAction>(
      onSelected: (ActivityAction action) {
        switch (action) {
          case ActivityAction.parse:
            parse(activity: activity);
            break;
          case ActivityAction.download:
            download(activity: activity);
            break;
          case ActivityAction.delete:
            delete(activity: activity);
            break;
          case ActivityAction.state:
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
        if (actions.contains('download'))
          PopupMenuItem<ActivityAction>(
            value: ActivityAction.download,
            child: Row(
              children: <Widget>[
                MyIcon.download,
                const Text(' Download .fit-file'),
              ],
            ),
          ),
        if (actions.contains('delete'))
          PopupMenuItem<ActivityAction>(
            value: ActivityAction.delete,
            child: Row(
              children: <Widget>[
                MyIcon.delete,
                const Text(' Delete activity'),
              ],
            ),
          ),
        if (actions.contains('state'))
          PopupMenuItem<ActivityAction>(
            value: ActivityAction.state,
            child: Text('State: ${activity.db.state}'),
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
