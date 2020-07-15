import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/screens/show_activity_screen.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/my_color.dart';
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
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          ListTile(
            leading: sportsIcon(sport: activity.sport),
            title: Text(activity.name ?? 'Activity'),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(activity.dateString() + '\n' + activity.distanceString()),
                const SizedBox(width: 20),
                Text(activity.paceString() + '\n' + activity.heartRateString()),
                const SizedBox(width: 20),
                Text((activity.avgPower == null || activity.avgPower == -1)
                    ? '-'
                    : activity.avgPower.toStringAsFixed(1) + ' W' + '\n'),
              ],
            ),
            onTap: () async {
              if (activity.state == 'persisted') {
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                for (Tag tag in activity.cachedTags)
                  Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.fromLTRB(4, -6, 4, -6),
                    labelPadding: const EdgeInsets.fromLTRB(0, -6, 0, -6),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1))),
                    label: Text(
                      tag.name,
                      style: TextStyle(
                        color: MyColor.textColor(
                          selected: true,
                          backgroundColor: Color(tag.color ?? 99999),
                        ),
                      ),
                    ),
                    backgroundColor: Color(tag.color ?? 99999),
                    elevation: 3,
                  ),
              ],
            ),
          )
        ]);
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
    activities = await widget.athlete.activities;
    for (final Activity activity in activities) {
      await activity.tags;
    }
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
