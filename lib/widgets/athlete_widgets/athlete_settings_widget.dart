import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button.dart';

class AthleteSettingsWidget extends StatefulWidget {
  const AthleteSettingsWidget({this.athlete});

  final Athlete? athlete;

  @override
  _AthleteSettingsWidgetState createState() => _AthleteSettingsWidgetState();
}

class _AthleteSettingsWidgetState extends State<AthleteSettingsWidget> {
  List<Activity> activities = <Activity>[];
  String numberOfActivitiesString = '---';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: MyIcon.athlete,
          title: const Text('Name'),
          subtitle: Text(
            widget.athlete!.firstName! + ' ' + widget.athlete!.lastName!,
          ),
        ),
        stravaTile(athlete: widget.athlete!),
        ListTile(
          leading: MyIcon.activities,
          title: const Text('Number of activities'),
          subtitle: Text(numberOfActivitiesString),
        ),
        ListTile(
          leading: MyIcon.time,
          title: const Text('Days back in Time, activities are downloaded'),
          subtitle: Row(
            children: <Widget>[
              const Spacer(),
              MyButton.save(
                child: const Text('- 7 days'),
                onPressed: () => decreaseDownloadInterval(),
              ),
              const Spacer(),
              Text(widget.athlete!.downloadInterval.toString()),
              const Spacer(),
              MyButton.save(
                child: const Text('+ 7 days'),
                onPressed: () => increaseDownloadInterval(),
              ),
              const Spacer(),
            ],
          ),
        ),
        ListTile(
          leading: MyIcon.number,
          title: const Text(
            'number of records that are averaged in diagrams on'
            ' activity level',
          ),
          subtitle: Row(
            children: <Widget>[
              const Spacer(),
              MyButton.save(
                child: const Text('/ 2'),
                onPressed: () => decreaseRecordAggregationCount(),
              ),
              const Spacer(),
              Text(widget.athlete!.recordAggregationCount.toString()),
              const Spacer(),
              MyButton.save(
                child: const Text('* 2'),
                onPressed: () => increaseRecordAggregationCount(),
              ),
              const Spacer(),
            ],
          ),
        ),
        const ListTile(
            leading: MyIcon.weight,
            title: Text('Last known weight'),
            subtitle: Text('no data available'))
      ],
    );
  }

  Future<void> getData() async {
    activities = await widget.athlete!.activities;

    setState(() {
      numberOfActivitiesString = activities.length.toString();
    });
  }

  Future<void> increaseDownloadInterval() async {
    widget.athlete!.downloadInterval =
        (widget.athlete!.downloadInterval ?? 21) + 7;
    await widget.athlete!.save();
    setState(() {});
  }

  Future<void> decreaseDownloadInterval() async {
    widget.athlete!.downloadInterval =
        (widget.athlete!.downloadInterval ?? 21) - 7;
    if (widget.athlete!.downloadInterval! < 7) {
      widget.athlete!.downloadInterval = 7;
    }
    await widget.athlete!.save();
    setState(() {});
  }

  Future<void> increaseRecordAggregationCount() async {
    widget.athlete!.recordAggregationCount =
        (widget.athlete!.recordAggregationCount ?? 16) * 2;
    await widget.athlete!.save();
    setState(() {});
  }

  Future<void> decreaseRecordAggregationCount() async {
    widget.athlete!.recordAggregationCount =
        ((widget.athlete!.recordAggregationCount ?? 16) / 2).round();
    if (widget.athlete!.recordAggregationCount! < 1) {
      widget.athlete!.recordAggregationCount = 1;
    }
    await widget.athlete!.save();
    setState(() {});
  }

  Widget stravaTile({required Athlete athlete}) {
    if (athlete.id != null) {
      return ListTile(
        leading: MyIcon.stravaDownload,
        title: const Text('Strava ID / Username / Location'),
        subtitle: Text((athlete.stravaId.toString() ?? '') +
            ' / ' +
            (athlete.stravaUsername ?? '') +
            ' / ' +
            (athlete.geoState ?? '')),
      );
    } else {
      return Container(width: 0, height: 0);
    }
  }
}
