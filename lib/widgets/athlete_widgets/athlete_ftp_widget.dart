import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/ftp.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/my_button.dart';

import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

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
  List<Activity> backlog = <Activity>[];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isNotEmpty) {
      final List<Activity> ftpActivities = activities
          .where(
              (Activity activity) => activity.ftp != null && activity.ftp > 0)
          .toList();
      if (ftpActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.orange,
          child: ListView(
              padding: const EdgeInsets.only(left: 25),
              children: <Widget>[
                AthleteTimeSeriesChart(
                  activities: ftpActivities,
                  chartTitleText: 'FTP (W)',
                  activityAttr: ActivityAttr.ftp,
                  athlete: widget.athlete,
                ),
                AthleteFilterWidget(
                  athlete: widget.athlete,
                  tagGroups: tagGroups,
                  callBackFunction: getData,
                ),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    Text(loadingStatus),
                    const Spacer(),
                    MyButton.activity(
                        child: const Text('Calculate missing FTP'),
                        onPressed: () async {
                          await Ftp.calculate(backlog: backlog);
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
                    Ftp.calculate(backlog: backlog);
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
    final List<Activity> unfilteredActivities = await athlete.activities;
    tagGroups = await widget.athlete.tagGroups;
    activities = await ActivityList<Activity>(unfilteredActivities).applyFilter(
      athlete: widget.athlete,
      tagGroups: tagGroups,
    );
    loadingStatus =
        activities.length.toString() + ' activities found, deriving backlog...';
    setState(() {});
    checkForBacklog();
  }

  Future<void> checkForBacklog() async {
    final Athlete athlete = widget.athlete;
    backlog = await Ftp.deriveBacklog(athlete: athlete);
    loadingStatus = activities.length.toString() +
        ' activities found, ${backlog.length} need their ftp to be calculated.';
    setState(() {});
  }
}
