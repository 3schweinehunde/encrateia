import 'package:encrateia/model/model.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthleteSettingsWidget extends StatefulWidget {
  final Athlete athlete;

  // ignore: sort_constructors_first
  const AthleteSettingsWidget({this.athlete});

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
    final DbAthlete userDB = widget.athlete.db;
    return ListView(
      children: <Widget>[
        ListTile(
          leading: MyIcon.athlete,
          title: const Text('Name'),
          subtitle: Text(
            userDB.firstName + ' ' + userDB.lastName,
          ),
        ),
        stravaTile(userDB: userDB),
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
              Text(widget.athlete.db.downloadInterval.toString()),
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
              Text(widget.athlete.db.recordAggregationCount.toString()),
              const Spacer(),
              MyButton.save(
                child: const Text('* 2'),
                onPressed: () => increaseRecordAggregationCount(),
              ),
              const Spacer(),
            ],
          ),
        ),
        ListTile(
            leading: MyIcon.weight,
            title: const Text('Last known weight'),
            subtitle: const Text('no data available'))
      ],
    );
  }

  Future<void> getData() async {
    activities = await widget.athlete.activities;

    setState(() {
      numberOfActivitiesString = activities.length.toString();
    });
  }

  Future<void> increaseDownloadInterval() async {
    final DbAthlete userDB = widget.athlete.db;
    userDB.downloadInterval = (userDB.downloadInterval ?? 21) + 7;
    await userDB.save();
    setState(() {});
  }

  Future<void> decreaseDownloadInterval() async {
    final DbAthlete userDB = widget.athlete.db;
    userDB.downloadInterval = (userDB.downloadInterval ?? 21) - 7;
    if (userDB.downloadInterval < 7) 
      userDB.downloadInterval = 7;
    await userDB.save();
    setState(() {});
  }

  Future<void> increaseRecordAggregationCount() async {
    final DbAthlete userDB = widget.athlete.db;
    userDB.recordAggregationCount = (userDB.recordAggregationCount ?? 16) * 2;
    await userDB.save();
    setState(() {});
  }

  Future<void> decreaseRecordAggregationCount() async {
    final DbAthlete userDB = widget.athlete.db;
    userDB.recordAggregationCount =
        ((userDB.recordAggregationCount ?? 16) / 2).round();
    if (userDB.recordAggregationCount < 1) 
      userDB.recordAggregationCount = 1;
    await userDB.save();
    setState(() {});
  }

  Widget stravaTile({DbAthlete userDB}) {
    if (userDB.stravaId != null)
      return ListTile(
          leading: MyIcon.stravaDownload,
          title: const Text('Strava ID / Username / Location'),
          subtitle: Text(userDB.stravaId.toString() +
              ' / ' +
              userDB.stravaUsername +
              ' / ' +
              userDB.geoState));
    else
      return Container(width: 0, height: 0);
  }
}
