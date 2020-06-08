import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

import 'athlete_filter_widget.dart';

class AthletePowerPerHeartRateWidget extends StatefulWidget {
  const AthletePowerPerHeartRateWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthletePowerPerHeartRateWidgetState createState() =>
      _AthletePowerPerHeartRateWidgetState();
}

class _AthletePowerPerHeartRateWidgetState
    extends State<AthletePowerPerHeartRateWidget> {
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
      final List<Activity> powerPerHeartRateActivities = activities
          .where((Activity value) =>
              value.avgPower != null &&
              value.avgPower > 0 &&
              value.avgHeartRate != null &&
              value.avgHeartRate > 0 &&
              value.avgHeartRate != 255)
          .toList();

      if (powerPerHeartRateActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: powerPerHeartRateActivities,
                activityAttr: ActivityAttr.avgPowerPerHeartRate,
                chartTitleText: 'Average power per heart rate',
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
          child: Text('No power per heart rate data available.'),
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
    tagGroups = await widget.athlete.tagGroups;
    activities = await ActivityList<Activity>(unfilteredActivities).applyFilter(
      athlete: widget.athlete,
      tagGroups: tagGroups,
    );
    loadingStatus = activities.length.toString() + ' activities found';
    setState(() {});
  }
}
