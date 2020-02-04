import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrateia/screens/show_activity_screen.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/utils/icon_utils.dart';

enum Action { show, parse, download, delete, state }

class ActivitiesListWidget extends StatefulWidget {
  final Athlete athlete;

  const ActivitiesListWidget({Key key, this.athlete}) : super(key: key);

  @override
  _ActivitiesListWidgetState createState() => _ActivitiesListWidgetState();
}

class _ActivitiesListWidgetState extends State<ActivitiesListWidget> {
  List<Activity> activities = [];

  @override
  initState() {
    getActivities();

    Future<Null>.delayed(
      Duration(seconds: 2),
      () {
        if (widget.athlete.email == null)
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Strava email not provided yet!"),
            backgroundColor: Colors.red,
          ));
        if (widget.athlete.password == null)
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Strava password not provided yet!"),
            backgroundColor: Colors.red,
          ));
      },
    );

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
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      padding: EdgeInsets.only(left: 10),
      itemCount: activities.length,
      itemBuilder: (BuildContext context, int index) {
        var activity = activities[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: sportsIcon(sport: activity.db.sport),
          title: Text(activity.db.name ?? "Activity"),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(activity.dateString() + "\n" + activity.distanceString()),
              Text(activity.timeString() + "\n" + activity.paceString()),
              FutureBuilder<double>(
                  future: activity.avgPower,
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.hasData) {
                      return Text(activity.heartRateString() +
                          "\n" +
                          snapshot.data.toStringOrDashes(1) +
                          " W");
                    } else {
                      return Text(activity.heartRateString() + "\n ...");
                    }
                  }),
            ],
          ),
          trailing: ChangeNotifierProvider.value(
            value: activity,
            child: Consumer<Activity>(
              builder: (context, activity, _child) =>
                  popupMenuButton(activity: activity),
            ),
          ),
        );
      },
    );
  }

  Icon sportsIcon({String sport}) {
    switch (sport) {
      case "running":
        return MyIcon.running;
      case "cycling":
        return MyIcon.cycling;
      default:
        return MyIcon.sport;
    }
  }

  Future delete({Activity activity}) async {
    await activity.delete();
    getActivities();
  }

  Future download({Activity activity}) async {
    await activity.download(athlete: widget.athlete);
    setState(() {});
  }

  Future parse({Activity activity}) async {
    await activity.parse(athlete: widget.athlete);
    activities = await Activity.all();
    setState(() {});
  }

  Future getActivities() async {
    activities = await Activity.all();
    setState(() {});
  }

  popupMenuButton({Activity activity}) {
    List<String> actions;

    switch (activity.db.state) {
      case "new":
        actions = ["download", "delete"];
        break;
      case "downloaded":
        actions = ["parse", "download", "delete"];
        break;
      case "persisted":
        actions = ["show", "parse", "download", "delete"];
        break;
      case "delete":
        delete(activity: activity);
        break;
      case "default":
        actions = ["state"];
    }

    return PopupMenuButton<Action>(
      onSelected: (Action action) {
        switch (action) {
          case Action.show:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowActivityScreen(
                  activity: activity,
                ),
              ),
            );
            break;
          case Action.parse:
            parse(activity: activity);
            break;
          case Action.download:
            download(activity: activity);
            break;
          case Action.delete:
            delete(activity: activity);
            break;
          case Action.state:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Action>>[
        if (actions.contains("download"))
          if (actions.contains("show"))
            PopupMenuItem<Action>(
              value: Action.show,
              child: Row(children: <Widget>[
                MyIcon.show,
                Text(" Show"),
              ]),
            ),
        if (actions.contains("parse"))
          PopupMenuItem<Action>(
            value: Action.parse,
            child: Row(
              children: <Widget>[
                MyIcon.parse,
                Text(" Parse .fit-file"),
              ],
            ),
          ),
        PopupMenuItem<Action>(
          value: Action.download,
          child: Row(
            children: <Widget>[MyIcon.download, Text(" Download .fit-file")],
          ),
        ),
        if (actions.contains("delete"))
          PopupMenuItem<Action>(
            value: Action.delete,
            child: Row(
              children: <Widget>[
                MyIcon.delete,
                Text(" Delete activity"),
              ],
            ),
          ),
        if (actions.contains("state"))
          PopupMenuItem<Action>(
            value: Action.state,
            child: Text("State: ${activity.db.state}"),
          ),
      ],
    );
  }
}
