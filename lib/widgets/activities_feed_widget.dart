import 'dart:math';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/PQ.dart';
import 'package:encrateia/utils/enums.dart';
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
  List<TagGroup> tagGroups = <TagGroup>[];
  Flushbar<Object> flushbar;
  bool disposed = false;

  @override
  void initState() {
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) => showMyFlushbar());
    super.initState();
  }

  @override
  void didUpdateWidget(ActivitiesFeedWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(color: Colors.black),
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
                Column(children: <Widget>[
                  PQ(
                    dateTime: activity.timeCreated,
                    format: DateTimeFormat.longDate,
                  ),
                  PQ(distance: activity.totalDistance),
                ]),
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
                getData();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Wrap(
              spacing: 10,
              children: <Widget>[
                for (Tag tag in activity.cachedTags)
                  Chip(
                    avatar: CircleAvatar(
                        foregroundColor: MyColor.textColor(
                            backgroundColor: Color(tagGroup(tag).color)),
                        backgroundColor: Color(tagGroup(tag).color),
                        child: Text(capitals(tag))),
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

  Future<void> getData() async {
    activities = await widget.athlete.activities;
    setState(() {});
    tagGroups = await TagGroup.allByAthlete(athlete: widget.athlete);
    for (final Activity activity in activities) {
      await activity.tags;
      if (disposed)
        break;
      setState(() {});
    }
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

  TagGroup tagGroup(Tag tag) => tagGroups
      .firstWhere((TagGroup tagGroup) => tagGroup.id == tag.tagGroupsId);

  String capitals(Tag tag) {
    final String capitals =
        tagGroup(tag).name.split(' ').map((String word) => word[0]).join();
    return capitals.substring(0, min(capitals.length, 2));
  }
}
