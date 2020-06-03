import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';

import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

import 'athlete_filter_widget.dart';

class AthletePowerWidget extends StatefulWidget {
  const AthletePowerWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthletePowerWidgetState createState() => _AthletePowerWidgetState();
}

class _AthletePowerWidgetState extends State<AthletePowerWidget> {
  ActivityList<Activity> activities = ActivityList<Activity>(<Activity>[]);
  List<TagGroup> tagGroups = <TagGroup>[];
  String loadingStatus = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isNotEmpty) {
      final List<Activity> powerActivities = activities
          .where((Activity activity) =>
              activity.db.avgPower != null && activity.db.avgPower > 0)
          .toList();
      if (powerActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.orange,
          child: ListView(
              padding: const EdgeInsets.only(left: 25),
              children: <Widget>[
                AthleteTimeSeriesChart(
                  activities: powerActivities,
                  chartTitleText: 'Power (W)',
                  activityAttr: ActivityAttr.avgPower,
                  athlete: widget.athlete,
                ),
                AthleteFilterWidget(
                  athlete: widget.athlete,
                  tagGroups: tagGroups,
                  callBackFunction: getData,
                )
              ]),
        );
      } else {
        return const Center(
          child: Text('No power data available.'),
        );
      }
    } else {
      return ListView(children: <Widget>[
        const SizedBox(
          height: 50,
        ),
        Center(
          child: Text(loadingStatus),
        ),
        const SizedBox(
          height: 50,
        ),
        AthleteFilterWidget(
          athlete: widget.athlete,
          tagGroups: tagGroups,
          callBackFunction: getData,
        )
      ]);
    }
  }

  Future<void> getData() async {
    final Athlete athlete = widget.athlete;
    final List<Activity> unfilteredActivities = await athlete.activities;
    tagGroups = await TagGroup.all(athlete: widget.athlete);
    activities = await ActivityList<Activity>(unfilteredActivities).applyFilter(
      athlete: widget.athlete,
      tagGroups: tagGroups,
    );
    loadingStatus = activities.length.toString() + ' activities found';
    setState(() {});
  }
}
