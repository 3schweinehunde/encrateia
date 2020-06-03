import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

import 'athlete_filter_widget.dart';

class AthleteEcorWidget extends StatefulWidget {
  const AthleteEcorWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthleteEcorWidgetState createState() => _AthleteEcorWidgetState();
}

class _AthleteEcorWidgetState extends State<AthleteEcorWidget> {
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
    if (activities.isEmpty) {
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
    } else {
      final List<Activity> ecorActivities = activities
          .where((Activity activity) =>
              activity.db.avgPower != null &&
              activity.db.avgPower > 0 &&
              activity.db.avgSpeed != null)
          .toList();
      if (ecorActivities.isEmpty) {
        return const Center(
          child: Text('No ecor data available.'),
        );
      } else if (ecorActivities.first.weight == null) {
        return const Center(
          child: Text('Please enter your (historical) weight in the settings.'),
        );
      } else {
        return ListTileTheme(
          iconColor: Colors.orange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: ecorActivities,
                chartTitleText: 'Ecor (kJ / kg / km)',
                activityAttr: ActivityAttr.ecor,
                athlete: widget.athlete,
              ),
              AthleteFilterWidget(
                athlete: widget.athlete,
                tagGroups: tagGroups,
                callBackFunction: getData,
              )
            ],
          ),
        );
      }
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

    for (final Activity activity in activities) {
      final Weight weight = await Weight.getBy(
        athletesId: activity.db.athletesId,
        date: activity.db.timeCreated,
      );
      activity.weight = weight?.db?.value;
    }
    setState(() {});
  }
}
