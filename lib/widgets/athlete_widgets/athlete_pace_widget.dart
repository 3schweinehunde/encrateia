import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/activity_list.dart';
import '/models/athlete.dart';
import '/models/tag_group.dart';
import '/utils/athlete_time_series_chart.dart';
import '/utils/enums.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import 'athlete_filter_widget.dart';

class AthletePaceWidget extends StatefulWidget {
  const AthletePaceWidget({Key? key, required this.athlete}) : super(key: key);

  final Athlete athlete;

  @override
  AthletePaceWidgetState createState() => AthletePaceWidgetState();
}

class AthletePaceWidgetState extends State<AthletePaceWidget> {
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
      final List<Activity> paceActivities = activities
          .where((Activity activity) =>
              activity.avgSpeed != null && activity.avgSpeed! > 0)
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
                  activityAttr: ActivityAttr.avgPace,
                  chartTitleText: 'Pace',
                  athlete: widget.athlete,
                  flipVerticalAxis: true,
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
          child: Text('No pace data available.'),
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
    sports = <String?>['all'] +
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

    setState(() => loadingStatus = '${activities.length} activities found');
  }
}
