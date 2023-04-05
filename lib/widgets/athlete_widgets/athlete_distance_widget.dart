import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/activity_list.dart';
import '/models/athlete.dart';
import '/models/tag_group.dart';
import '/utils/athlete_volume_chart.dart';
import '/utils/enums.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';

class AthleteDistanceWidget extends StatefulWidget {
  const AthleteDistanceWidget({Key? key, this.athlete}) : super(key: key);

  final Athlete? athlete;

  @override
  AthleteDistanceWidgetState createState() => AthleteDistanceWidgetState();
}

class AthleteDistanceWidgetState extends State<AthleteDistanceWidget> {
  ActivityList<Activity> activities = ActivityList<Activity>(<Activity>[]);
  List<TagGroup> tagGroups = <TagGroup>[];
  String loadingStatus = 'Loading ...';
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();
  late List<String?> sports;
  String? selectedSports = 'running';

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
              activity.distance != null && activity.distance! > 0)
          .toList();

      if (distanceActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: AthleteVolumeChart(
                  athlete: widget.athlete,
                  chartTitleText: 'Distance over Time (km)',
                  activities: activities,
                  volumeAttr: ActivityAttr.distanceThisYear,
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
    final Athlete athlete = widget.athlete!;
    final List<Activity> unfilteredActivities = await athlete.validActivities;
    int distanceSoFar = 0;
    int year = 1900;
    sports = <String?>['all'] +
        unfilteredActivities
            .map((Activity activity) => activity.sport)
            .toSet()
            .toList();
    activities = ActivityList<Activity>(selectedSports == 'all'
        ? unfilteredActivities
        : unfilteredActivities
            .where((Activity activity) => activity.sport == selectedSports)
            .toList());

    for (final Activity activity in activities.reversed) {
      if (activity.timeStamp!.year != year) {
        year = activity.timeStamp!.year;
        distanceSoFar = activity.distance ?? 0;
      } else {
        distanceSoFar += activity.distance!;
      }
      activity.distanceSoFar = distanceSoFar;
    }

    setState(() => loadingStatus = '${activities.length} activities found');
  }
}
