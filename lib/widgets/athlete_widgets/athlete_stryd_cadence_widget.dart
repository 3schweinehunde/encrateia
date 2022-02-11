import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/image_utils.dart' as image_utils;
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';

import 'athlete_filter_widget.dart';

class AthleteStrydCadenceWidget extends StatefulWidget {
  const AthleteStrydCadenceWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthleteStrydCadenceWidgetState createState() =>
      _AthleteStrydCadenceWidgetState();
}

class _AthleteStrydCadenceWidgetState extends State<AthleteStrydCadenceWidget> {
  ActivityList<Activity> activities = ActivityList<Activity>(<Activity>[]);
  List<TagGroup> tagGroups = <TagGroup>[];
  String loadingStatus = 'Loading ...';
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();
  List<String> sports;
  String selectedSports = 'running';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isNotEmpty) {
      final List<Activity> paceActivities = activities
          .where((Activity activity) =>
              activity.avgStrydCadence != null && activity.avgStrydCadence > 0)
          .toList();

      if (paceActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: AthleteTimeSeriesChart(
                  activities: paceActivities,
                  activityAttr: ActivityAttr.avgDoubleStrydCadence,
                  chartTitleText: 'Cadence',
                  athlete: widget.athlete,
                ),
              ),
              Row(children: <Widget>[
                const Spacer(),
                MyButton.save(
                  child: Text(screenShotButtonText),
                  onPressed: () async {
                    await image_utils.capturePng(widgetKey: widgetKey);
                    screenShotButtonText = 'Image saved';
                    setState(() {});
                  },
                ),
                const SizedBox(width: 20),
              ]),
              Row(
                children: <Widget>[
                  const Spacer(),
                  const Text('Select Sport'),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                    items: sports.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: selectedSports,
                    onChanged: (String value) {
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
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No (Stryd) cadence data available.'),
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
    final List<Activity> unfilteredActivities = await athlete.validActivities;
    tagGroups = await athlete.tagGroups;
    sports = <String>['all'] +
        unfilteredActivities
            .map((Activity activity) => activity.sport)
            .toSet()
            .toList();
    activities = await ActivityList<Activity>(selectedSports == 'all'
            ? unfilteredActivities
            : unfilteredActivities
                .where((Activity activity) => activity.sport == selectedSports)
                .toList())
        .applyFilter(
      athlete: athlete,
      tagGroups: tagGroups,
    );

    setState(() =>
        loadingStatus = activities.length.toString() + ' activities found');
  }
}
