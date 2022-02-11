import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/activity_list.dart';
// ignore: directives_ordering
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/ftp.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/image_utils.dart' as image_utils;
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';

import 'athlete_filter_widget.dart';

class AthleteFtpWidget extends StatefulWidget {
  const AthleteFtpWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthleteFtpWidgetState createState() => _AthleteFtpWidgetState();
}

class _AthleteFtpWidgetState extends State<AthleteFtpWidget> {
  ActivityList<Activity> activities = ActivityList<Activity>(<Activity>[]);
  List<TagGroup> tagGroups = <TagGroup>[];
  String loadingStatus = 'Loading ...';
  List<Activity> ftpActivities = <Activity>[];
  List<Activity> backlog = <Activity>[];
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
      if (ftpActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.orange,
          child: ListView(
              padding: const EdgeInsets.only(left: 25),
              children: <Widget>[
                RepaintBoundary(
                  key: widgetKey,
                  child: AthleteTimeSeriesChart(
                    activities: ftpActivities,
                    chartTitleText: 'FTP (W)',
                    activityAttr: ActivityAttr.ftp,
                    athlete: widget.athlete,
                    fullDecay: 90,
                  ),
                ),
                const SizedBox(height: 20),
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
                const Center(
                  child:
                      Text('Tag activities with power data in any tag within '
                          'the taggroup "Effort" to let them show up here.'),
                ),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    const Text('Select Sport'),
                    const SizedBox(width: 20),
                    DropdownButton<String>(
                      items:
                          sports.map<DropdownMenuItem<String>>((String value) {
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
                Text(loadingStatus),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    MyButton.activity(
                        child: const Text('Calculate missing FTP'),
                        onPressed: () async {
                          await Ftp.catchUp(backlog: backlog);
                          getData();
                        }),
                    const SizedBox(width: 20),
                  ],
                ),
              ]),
        );
      } else {
        return ListView(children: <Widget>[
          const SizedBox(height: 20),
          Center(child: Text(loadingStatus)),
          Row(
            children: <Widget>[
              const Spacer(),
              MyButton.activity(
                  child: const Text('Calculate FTP'),
                  onPressed: () async {
                    Ftp.catchUp(backlog: backlog);
                    setState(() {});
                  }),
              const SizedBox(width: 20),
            ],
          )
        ]);
      }
    } else {
      return Center(child: Text(loadingStatus));
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
    ftpActivities = activities
        .where((Activity activity) => activity.ftp != null && activity.ftp > 0)
        .toList();
    loadingStatus = ftpActivities.length.toString() +
        ' tagged in Effort Taggroup, deriving backlog...';
    setState(() {});
    checkForBacklog();
  }

  Future<void> checkForBacklog() async {
    final Athlete athlete = widget.athlete;
    backlog = await Ftp.deriveBacklog(athlete: athlete);

    setState(() => loadingStatus = ftpActivities.length.toString() +
        ' tagged in Effort Taggroup, ' +
        backlog.length.toString() +
        ' need their ftp to be calculated.');
  }
}
