import 'dart:math';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/athlete_scatter_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/image_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';

class AthletePaceVsDistanceWidget extends StatefulWidget {
  const AthletePaceVsDistanceWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthletePaceVsDistanceWidgetState createState() => _AthletePaceVsDistanceWidgetState();
}

class _AthletePaceVsDistanceWidgetState extends State<AthletePaceVsDistanceWidget> {
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
      final List<Activity> distanceActivities = activities
          .where((Activity activity) =>
      activity.distance != null && activity.distance > 0)
          .toList();

      if (distanceActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: AthleteScatterChart(
                  athlete: widget.athlete,
                  chartTitleText: 'Power vs. Distance',
                  activities: activities,
                  firstAttr: ActivityAttr.distance,
                  firstAxesText: 'Distance (km)',
                  secondAttr: ActivityAttr.avgPace,
                  secondAxesText: 'Pace (min)',
                  flipVerticalAxis: true,
                ),
              ),
              Row(children: <Widget>[
                const Spacer(),
                MyButton.save(
                  child: Text(screenShotButtonText),
                  onPressed: () async {
                    await ImageUtils.capturePng(widgetKey: widgetKey);
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
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No volume data available.'),
        );
      }
    } else {
      return Center(child: Text(loadingStatus));
    }
  }

  Future<void> getData() async {
    final Athlete athlete = widget.athlete;
    List<Activity> unfilteredActivities = await athlete.validActivities;
    sports = <String>['all'] + unfilteredActivities
        .map((Activity activity) => activity.sport)
        .toSet()
        .toList();
    unfilteredActivities = selectedSports == 'all'
        ? unfilteredActivities
        : unfilteredActivities
        .where((Activity activity) => activity.sport == selectedSports)
        .toList();
    activities = ActivityList<Activity>(unfilteredActivities
        .where((Activity activity) => activity.avgPace > 0)
        .toList());
    activities = ActivityList<Activity>(activities.sublist(0, min(255, activities.length)));

    setState(() =>
    loadingStatus = activities.length.toString() + ' activities found');
  }
}
