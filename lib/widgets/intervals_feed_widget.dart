import 'dart:math';

import 'package:collection/collection.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/screens/show_interval_screen.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class IntervalsFeedWidget extends StatefulWidget {
  const IntervalsFeedWidget({Key key, this.athlete}) : super(key: key);

  final Athlete athlete;

  @override
  _IntervalsFeedWidgetState createState() => _IntervalsFeedWidgetState();
}

class _IntervalsFeedWidgetState extends State<IntervalsFeedWidget> {
  List<encrateia.Interval> intervals = <encrateia.Interval>[];
  Map<int, List<encrateia.Interval>> groupedIntervals =
      <int, List<encrateia.Interval>>{};
  Map<int, Activity> activityMap = <int, Activity>{};
  List<TagGroup> tagGroups = <TagGroup>[];
  Flushbar<Object> flushbar;
  bool disposed = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(IntervalsFeedWidget oldWidget) {
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
      itemCount: groupedIntervals.length,
      itemBuilder: (BuildContext context, int index) {
        final int activityId = groupedIntervals.keys.toList()[index];
        final List<encrateia.Interval> intervalsInCard =
            groupedIntervals[activityId];
        return ListTile(
          title: Text(activityMap[activityId].name),
          subtitle: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(children: <Widget>[
              for (encrateia.Interval interval in intervalsInCard.reversed)
                InkWell(
                  child: Row(
                    children: <Widget>[
                      PQText(
                        value: interval.timeStamp,
                        pq: PQ.dateTime,
                        format: DateTimeFormat.shortTime,
                      ),
                      const SizedBox(width: 20),
                      PQText(value: interval.distance, pq: PQ.distance),
                      const SizedBox(width: 20),
                      PQText(value: interval.movingTime, pq: PQ.shortDuration),
                      const SizedBox(width: 20),
                      PQText(value: interval.avgPace, pq: PQ.pace),
                      const SizedBox(width: 20),
                      PQText(value: interval.avgPower, pq: PQ.power),
                      const SizedBox(width: 20),
                      PQText(value: interval.avgHeartRate, pq: PQ.heartRate),
                      const SizedBox(width: 20),
                      Wrap(
                        spacing: 10,
                        children: <Widget>[
                          for (Tag tag in interval.cachedTags)
                            Chip(
                              avatar: CircleAvatar(
                                  foregroundColor: MyColor.textColor(
                                      backgroundColor:
                                          Color(tagGroup(tag).color)),
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
                    ],
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<BuildContext>(
                        builder: (BuildContext context) => ShowIntervalScreen(
                          interval: interval,
                          intervals: intervalsInCard,
                          athlete: widget.athlete,
                          activity: activityMap[activityId],
                        ),
                      ),
                    );
                    getData();
                  },
                ),
            ]),
          ),
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

  TagGroup tagGroup(Tag tag) => tagGroups
      .firstWhere((TagGroup tagGroup) => tagGroup.id == tag.tagGroupsId);

  String capitals(Tag tag) {
    final String capitals =
        tagGroup(tag).name.split(' ').map((String word) => word[0]).join();
    return capitals.substring(0, min(capitals.length, 2));
  }

  Future<void> getData() async {
    intervals = await widget.athlete.intervals;
    groupedIntervals = groupBy(
        intervals, (encrateia.Interval interval) => interval.activitiesId);
    activityMap = <int, Activity>{
      for (int activityId in groupedIntervals.keys)
        activityId: await Activity.byId(activityId)
    };
    setState(() {});
    tagGroups = await TagGroup.allByAthlete(athlete: widget.athlete);
    int index = 1;
    for (final encrateia.Interval interval in intervals.reversed) {
      await interval.tags;
      interval.index = index;
      index++;
      if (disposed) break;
      setState(() {});
    }
  }
}
