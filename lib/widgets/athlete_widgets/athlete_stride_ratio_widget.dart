import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

import 'athlete_filter_widget.dart';

class AthleteStrideRatioWidget extends StatefulWidget {
  const AthleteStrideRatioWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthleteStrideRatioWidgetState createState() =>
      _AthleteStrideRatioWidgetState();
}

class _AthleteStrideRatioWidgetState extends State<AthleteStrideRatioWidget> {
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
      final List<Activity> strideRatioActivities = activities
          .where((Activity value) =>
              value.db.avgStrideRatio != null && value.db.avgStrideRatio > 0)
          .toList();

      if (strideRatioActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: strideRatioActivities,
                activityAttr: ActivityAttr.avgStrideRatio,
                chartTitleText: 'Stride Ratio',
                athlete: widget.athlete,
              ),
              AthleteFilterWidget(
                athlete: widget.athlete,
                tagGroups: tagGroups,
                callBackFunction: getData,
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No stride ratio data available.'),
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
