import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/tag.dart';
import '/models/tag_group.dart';
import '/screens/show_activity_screen.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/my_color.dart';

class ActivitiesFeedWidget extends StatefulWidget {
  const ActivitiesFeedWidget({Key? key, this.athlete}) : super(key: key);

  final Athlete? athlete;

  @override
  _ActivitiesFeedWidgetState createState() => _ActivitiesFeedWidgetState();
}

class _ActivitiesFeedWidgetState extends State<ActivitiesFeedWidget> {
  List<Activity> activities = <Activity>[];
  List<TagGroup> tagGroups = <TagGroup>[];
  Flushbar<Object>? flushbar;
  bool disposed = false;

  @override
  void initState() {
    getData();
    WidgetsBinding.instance!.addPostFrameCallback((_) => showMyFlushbar());
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
        if (activity.nonParsable == true) {
          return ListTile(
            leading: sportsIcon(sport: activity.sport),
            title: Text(activity.name ?? 'Activity'),
            trailing: MyIcon.excluded,
            subtitle: const Text('Activity cannot be parsed. 🙇'),
            onTap: () async {
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
            },
          );
        } else {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: sportsIcon(sport: activity.sport),
                  title: Text(activity.name ?? 'Activity'),
                  trailing: activity.excluded == true
                      ? MyIcon.excluded
                      : const Text(''),
                  subtitle: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(children: <Widget>[
                          PQText(
                            pq: PQ.dateTime,
                            value: activity.timeCreated,
                            format: DateTimeFormat.shortDate,
                          ),
                          PQText(
                            pq: PQ.distance,
                            value: activity.totalDistance,
                          ),
                        ]),
                        const SizedBox(width: 20),
                        Column(children: <Widget>[
                          PQText(
                              pq: PQ.paceFromSpeed, value: activity.avgSpeed),
                          PQText(
                            pq: PQ.heartRate,
                            value: activity.avgHeartRate,
                          ),
                        ]),
                        const SizedBox(width: 20),
                        Column(
                          children: <Widget>[
                            PQText(
                              pq: PQ.power,
                              value: activity.avgPower,
                            ),
                            PQText(
                              pq: PQ.ecor,
                              value: activity.cachedEcor,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  onTap: () async {
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
                                  backgroundColor: Color(tagGroup(tag).color!)),
                              backgroundColor: Color(tagGroup(tag).color!),
                              child: Text(capitals(tag))),
                          label: Text(
                            tag.name!,
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
        }
      },
    );
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

  Future<void> getData() async {
    activities = await widget.athlete!.activities;
    setState(() {});
    tagGroups = await TagGroup.allByAthlete(athlete: widget.athlete!);
    for (final Activity activity in activities) {
      await activity.tags;
      await activity.ecor;
      if (disposed) {
        break;
      }
      setState(() {});
    }
  }

  void showMyFlushbar() {
    if (widget.athlete!.stravaId != null) {
      if (widget.athlete!.email == null) {
        flushbar = Flushbar<Object>(
          message: 'Strava email not provided yet!',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.yellow[900]!,
        )..show(context);
      } else if (widget.athlete!.password == null) {
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
        tagGroup(tag).name!.split(' ').map((String word) => word[0]).join();
    return capitals.substring(0, min(capitals.length, 2));
  }
}
