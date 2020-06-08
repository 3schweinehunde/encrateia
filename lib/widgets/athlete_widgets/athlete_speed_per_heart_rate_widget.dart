import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

import 'athlete_filter_widget.dart';

class AthleteSpeedPerHeartRateWidget extends StatefulWidget {
  const AthleteSpeedPerHeartRateWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthleteSpeedPerHeartRateWidgetState createState() =>
      _AthleteSpeedPerHeartRateWidgetState();
}

class _AthleteSpeedPerHeartRateWidgetState
    extends State<AthleteSpeedPerHeartRateWidget> {
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
      final List<Activity> speedPerHeartRateActivities = activities
          .where((Activity value) =>
              value.db.avgSpeed != null &&
              value.db.avgSpeed > 0 &&
              value.db.avgHeartRate != null &&
              value.db.avgHeartRate > 0 &&
              value.db.avgHeartRate != 255)
          .toList();

      if (speedPerHeartRateActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: speedPerHeartRateActivities,
                activityAttr: ActivityAttr.avgSpeedPerHeartRate,
                chartTitleText: 'Average speed per heart rate',
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
          child: Text('No speed per heart rate data available.'),
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
    List<Activity> unfilteredActivities = await athlete.activities;
    unfilteredActivities = unfilteredActivities
        .where((Activity activity) => activity.db.sport == 'running')
        .toList();
    tagGroups = await widget.athlete.tagGroups;
    activities = await ActivityList<Activity>(unfilteredActivities).applyFilter(
      athlete: widget.athlete,
      tagGroups: tagGroups,
    );
    loadingStatus = activities.length.toString() + ' activities found';
    setState(() {});
  }
}
