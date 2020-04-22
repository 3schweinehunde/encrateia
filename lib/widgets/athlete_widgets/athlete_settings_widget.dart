import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthleteSettingsWidget extends StatefulWidget {
  final Athlete athlete;

  AthleteSettingsWidget({this.athlete});

  @override
  _AthleteSettingsWidgetState createState() => _AthleteSettingsWidgetState();
}

class _AthleteSettingsWidgetState extends State<AthleteSettingsWidget> {
  List<Activity> activities = [];
  String numberOfActivitiesString = "---";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userDB = widget.athlete.db;
    return ListView(
      children: <Widget>[
        ListTile(
          leading: MyIcon.athlete,
          title: Text("Name"),
          subtitle: Text(
            userDB.firstName + " " + userDB.lastName,
          ),
        ),
        stravaTile(userDB: userDB),
        ListTile(
          leading: MyIcon.activities,
          title: Text("Number of activities"),
          subtitle: Text(numberOfActivitiesString),
        ),
        ListTile(
          leading: MyIcon.time,
          title: Text("Days back in Time, activities are downloaded"),
          subtitle: Row(
            children: <Widget>[
              Spacer(),
              RaisedButton(
                color: Colors.orange,
                child: Text("- 7 days"),
                onPressed: () => decreaseDownloadInterval(),
              ),
              Spacer(),
              Text(widget.athlete.db.downloadInterval.toString()),
              Spacer(),
              RaisedButton(
                color: Colors.orange,
                child: Text("+ 7 days"),
                onPressed: () => increaseDownloadInterval(),
              ),
              Spacer(),
            ],
          ),
        ),
        ListTile(
          leading: MyIcon.weight,
          title: Text("Last known weight"),
          subtitle: Text("no data available")
        )
      ],
    );
  }

  getData() async {
    activities = await widget.athlete.activities;

    setState(() {
      numberOfActivitiesString = activities.length.toString();
    });
  }

  increaseDownloadInterval() async {
    var userDB = widget.athlete.db;
    userDB.downloadInterval = (userDB.downloadInterval ?? 21) + 7;
    await userDB.save();
    setState(() {});
  }

  decreaseDownloadInterval() async {
    var userDB = widget.athlete.db;
    userDB.downloadInterval = (userDB.downloadInterval ?? 21) - 7;
    if (userDB.downloadInterval < 7) userDB.downloadInterval = 7;
    await userDB.save();
    setState(() {});
  }

  stravaTile({userDB}) {
    if (userDB.stravaId != null)
      return ListTile(
          leading: MyIcon.stravaDownload,
          title: Text("Strava ID / Username / Location"),
          subtitle: Text(
              userDB.stravaId.toString() +
              " / " +
              userDB.stravaUsername +
              " / " +
              userDB.geoState));
    else
      return Container(width: 0, height: 0);
  }
}
