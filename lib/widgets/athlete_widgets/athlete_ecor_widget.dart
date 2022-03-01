import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/activity_list.dart';
import '/models/athlete.dart';
import '/models/tag_group.dart';
import '/utils/athlete_time_series_chart.dart';
import '/utils/enums.dart';
import 'athlete_filter_widget.dart';

class AthleteEcorWidget extends StatefulWidget {
  const AthleteEcorWidget({Key? key, required this.athlete}) : super(key: key);

  final Athlete athlete;

  @override
  _AthleteEcorWidgetState createState() => _AthleteEcorWidgetState();
}

class _AthleteEcorWidgetState extends State<AthleteEcorWidget> {
  ActivityList<Activity> activities = ActivityList<Activity>(<Activity>[]);
  List<TagGroup> tagGroups = <TagGroup>[];
  String loadingStatus = 'Loading ...';
  late List<String?> sports;
  String? selectedSports = 'running';

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
              activity.cachedEcor != 0 && activity.cachedEcor != -1)
          .toList();
      if (ecorActivities.isEmpty) {
        return const Center(
          child: Text('No ecor data available.'),
        );
      } else {
        return ListTileTheme(
          iconColor: Colors.orange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: ecorActivities,
                chartTitleText: 'Ecor (kJ/kg/km)',
                activityAttr: ActivityAttr.ecor,
                athlete: widget.athlete,
              ),
              Row(
                children: <Widget>[
                  const Spacer(),
                  const Text('Select Sport'),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                    items:
                        sports.map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!),
                      );
                    }).toList(),
                    value: selectedSports,
                    onChanged: (String? value) {
                      selectedSports = value;
                      getData();
                    },
                  ),
                  const Spacer(),
                ],
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
    List<Activity> unfilteredActivities = await athlete.validActivities;
    tagGroups = await athlete.tagGroups;
    sports = <String?>['all'] +
        unfilteredActivities
            .map((Activity activity) => activity.sport)
            .toSet()
            .toList();
    unfilteredActivities = selectedSports == 'all'
        ? unfilteredActivities
        : unfilteredActivities
            .where((Activity activity) => activity.sport == selectedSports)
            .toList();

    for (final Activity activity in unfilteredActivities) {
      await activity.ecor;
    }

    activities = await ActivityList<Activity>(unfilteredActivities).applyFilter(
      athlete: athlete,
      tagGroups: tagGroups,
    );

    setState(() =>
        loadingStatus = activities.length.toString() + ' activities found');
  }
}
