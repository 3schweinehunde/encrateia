import 'package:dio/dio.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_ratio_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_zone_schema_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_heart_rate_zone_schema_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_tag_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/widgets/activities_list_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_stride_ratio_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_settings_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_speed_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_body_weight_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_ecor_widget.dart';
import 'package:encrateia/screens/show_athlete_detail_screen.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';

class ShowAthleteScreen extends StatefulWidget {
  final Athlete athlete;

  const ShowAthleteScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  @override
  _ShowAthleteScreenState createState() => _ShowAthleteScreenState();
}

class _ShowAthleteScreenState extends State<ShowAthleteScreen> {
  Flushbar flushbar;
  Visibility floatingActionButton;
  bool floatingActionButtonVisible;

  @override
  void initState() {
    floatingActionButtonVisible =
        (widget.athlete.email != null && widget.athlete.password != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.athlete,
        title: Text(
          '${widget.athlete.db.firstName} ${widget.athlete.db.lastName}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      floatingActionButton: Visibility(
        visible: floatingActionButtonVisible,
        child: FloatingActionButton.extended(
          onPressed: () => updateJob(),
          label: Text("from Strava"),
          icon: MyIcon.stravaDownload,
        ),
      ),
      body: StaggeredGridView.count(
        staggeredTiles: List.filled(17, StaggeredTile.fit(1)),
        crossAxisSpacing: 10,
        padding: EdgeInsets.all(10),
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
        children: [
          navigationButton(
            color: MyColor.activity,
            title: "Activities List",
            icon: MyIcon.activities,
            backgroundColor: MyColor.activity,
            nextWidget: ActivitiesListWidget(athlete: widget.athlete),
          ),
          navigationButton(
            color: MyColor.navigate,
            title: "Power",
            icon: MyIcon.power,
            nextWidget: AthletePowerWidget(athlete: widget.athlete),
          ),
          navigationButton(
            title: "Power Ratio",
            color: MyColor.navigate,
            icon: MyIcon.power,
            nextWidget: AthletePowerRatioWidget(athlete: widget.athlete),
          ),
          navigationButton(
            color: MyColor.navigate,
            title: "Power /\nHeart Rate",
            icon: MyIcon.power,
            nextWidget: AthletePowerPerHeartRateWidget(athlete: widget.athlete),
          ),
          navigationButton(
            color: MyColor.navigate,
            title: "Ecor",
            icon: MyIcon.power,
            nextWidget: AthleteEcorWidget(athlete: widget.athlete),
          ),
          navigationButton(
            color: MyColor.navigate,
            title: "Stride Ratio",
            icon: MyIcon.strideRatio,
            nextWidget: AthleteStrideRatioWidget(athlete: widget.athlete),
          ),
          navigationButton(
            color: MyColor.navigate,
            title: "Speed /\nHeart Rate",
            icon: MyIcon.speed,
            nextWidget: AthleteSpeedPerHeartRateWidget(athlete: widget.athlete),
          ),
          RaisedButton.icon(
            color: MyColor.add,
            textColor: MyColor.textColor(backgroundColor: MyColor.add),
            icon: MyIcon.downloadLocal,
            label: Text("Import .fit\nfrom Folder"),
            onPressed: () => importLocal(),
          ),
          navigationButton(
            color: MyColor.settings,
            title: "Body Weight",
            icon: MyIcon.weight,
            nextWidget: AthleteBodyWeightWidget(athlete: widget.athlete),
          ),
          navigationButton(
            color: MyColor.settings,
            title: "Power Zone\nSchemas",
            icon: MyIcon.power,
            nextWidget: AthletePowerZoneSchemaWidget(athlete: widget.athlete),
          ),
          navigationButton(
            color: MyColor.settings,
            title: "Heart Rate\nZone Schemas",
            icon: MyIcon.heartRate,
            nextWidget:
                AthleteHeartRateZoneSchemaWidget(athlete: widget.athlete),
          ),
          navigationButton(
            color: MyColor.tag,
            title: "Tags",
            icon: MyIcon.tag,
            nextWidget: AthleteTagGroupWidget(athlete: widget.athlete),
          ),
          navigationButton(
            color: MyColor.settings,
            title: "Settings",
            icon: MyIcon.settings,
            nextWidget: AthleteSettingsWidget(athlete: widget.athlete),
          ),
          RaisedButton.icon(
            color: MyColor.danger,
            textColor: MyColor.textColor(backgroundColor: MyColor.danger),
            icon: MyIcon.delete,
            label: Text("Delete\nAthlete"),
            onPressed: () => deleteUser(),
          ),
          RaisedButton.icon(
            color: MyColor.settings,
            icon: MyIcon.settings,
            textColor: MyColor.textColor(backgroundColor: MyColor.add),
            label: Text("Recalculate\nAverages"),
            onPressed: () => recalculate(),
          ),
          RaisedButton.icon(
            color: MyColor.settings,
            textColor: MyColor.textColor(backgroundColor: MyColor.settings),
            icon: MyIcon.settings,
            label: Text("Redo\nAutotagging"),
            onPressed: () => redoAutoTagging(),
          ),
          RaisedButton.icon(
            color: MyColor.primary,
            icon: MyIcon.download,
            label: Text("Download\nDemo Data"),
            onPressed: () => downloadDemoData(),
          ),
        ],
      ),
    );
  }

  navigationButton({
    @required Widget nextWidget,
    @required Widget icon,
    @required String title,
    @required Color color,
    Color backgroundColor,
  }) {
    return RaisedButton.icon(
      color: color ?? MyColor.primary,
      textColor: MyColor.textColor(backgroundColor: color),
      icon: icon,
      label: Text(title),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowAthleteDetailScreen(
            athlete: widget.athlete,
            widget: nextWidget,
            title: title,
            backgroundColor: backgroundColor,
          ),
        ),
      ),
    );
  }

  recalculate() async {
    List<Activity> activities;
    activities = await Activity.all(athlete: widget.athlete);
    int index = 0;
    int percent;

    flushbar = Flushbar(
      message: "Calculating...",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);

    for (Activity activity in activities) {
      index += 1;
      await activity.recalculateAverages();
      flushbar.dismiss();
      percent = 100 * index ~/ activities.length;
      flushbar = Flushbar(
        titleText: LinearProgressIndicator(value: percent / 100),
        message: "$percent% done (recalculating »${activity.db.name}« )",
        duration: Duration(seconds: 2),
        animationDuration: Duration(milliseconds: 1),
      )..show(context);
    }

    flushbar.dismiss();
    Flushbar(
      message: "Averages are now up to date.",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  }

  importLocal() async {
    List<Activity> activities;

    flushbar = Flushbar(
      message: "Importing activities from local directory",
      duration: Duration(seconds: 1),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);
    await Activity.importFromLocalDirectory(athlete: widget.athlete);
    flushbar = Flushbar(
      message: "Activities moved into application",
      duration: Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    activities = await Activity.all(athlete: widget.athlete);
    var downloadedActivities = activities
        .where((activity) => activity.db.state == "downloaded")
        .toList();
    for (Activity activity in downloadedActivities) {
      await parse(activity: activity);
      await activity.autoTagger(athlete: widget.athlete);
    }
    flushbar.dismiss();
    flushbar = Flushbar(
      message: "Activities imported!",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  }

  downloadDemoData() async {
    List<Activity> activities;
    var appDocDir = await getApplicationDocumentsDirectory();
    var dio = Dio();
    var downloadDir = "https://encrateia.informatom.com/assets/fit-files/";
    var fileNames = [
      "munich_half_marathon.fit",
      "listener_meetup_run_cologne.fit",
      "stockholm_half_marathon.fit",
      "upper_palatinate_winter_challenge_half_marathon.fit",
    ];

    flushbar = Flushbar(
      message: "Downloading Demo data ...",
      duration: Duration(seconds: 1),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    for (String filename in fileNames) {
      var activity = Activity.fromLocalDirectory(athlete: widget.athlete);
      await dio.download(downloadDir + filename,
          appDocDir.path + "/" + activity.db.stravaId.toString() + ".fit");
      await activity.setState("downloaded");
    }

    flushbar = Flushbar(
      message: "Downloading demo data finished",
      duration: Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    activities = await Activity.all(athlete: widget.athlete);
    var downloadedActivities = activities
        .where((activity) => activity.db.state == "downloaded")
        .toList();
    for (Activity activity in downloadedActivities) {
      await parse(activity: activity);
      await activity.autoTagger(athlete: widget.athlete);
    }
    flushbar.dismiss();
    flushbar = Flushbar(
      message: "Activities imported!",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  }

  updateJob() async {
    List<Activity> activities;
    setState(() => floatingActionButtonVisible = false);

    await queryStrava();

    activities = await Activity.all(athlete: widget.athlete);
    var newActivities =
        activities.where((activity) => activity.db.state == "new");
    for (Activity activity in newActivities) {
      await download(activity: activity);
    }

    var downloadedActivities =
        activities.where((activity) => activity.db.state == "downloaded");
    for (Activity activity in downloadedActivities) {
      await parse(activity: activity);
      await activity.autoTagger(athlete: widget.athlete);
    }

    flushbar.dismiss();
    Flushbar(
      message: "You are now up to date!",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);

    setState(() => floatingActionButtonVisible = true);
  }

  Future queryStrava() async {
    flushbar = Flushbar(
      message: "Downloading new activities",
      duration: Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);
    await Activity.queryStrava(athlete: widget.athlete);
    flushbar.dismiss();
    Flushbar(
      message: "Download finished",
      duration: Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    setState(() {});
  }

  Future download({Activity activity}) async {
    flushbar.dismiss();
    flushbar = Flushbar(
      message: "Download .fit-File for »${activity.db.name}«",
      duration: Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    await activity.download(athlete: widget.athlete);

    flushbar.dismiss();
    Flushbar(
      message: "Download finished",
      duration: Duration(seconds: 2),
      icon: MyIcon.finishedWhite,
    )..show(context);
    setState(() {});
  }

  Future parse({Activity activity}) async {
    flushbar.dismiss();
    flushbar = Flushbar(
      message: "0% of storing »${activity.db.name}«",
      duration: Duration(seconds: 10),
      animationDuration: Duration(milliseconds: 1),
      titleText: LinearProgressIndicator(value: 0),
    )..show(context);

    var percentageStream = activity.parse(athlete: widget.athlete);
    await for (var value in percentageStream) {
      flushbar.dismiss();
      flushbar = Flushbar(
        titleText: LinearProgressIndicator(value: value / 100),
        message: "$value% of storing »${activity.db.name}«",
        duration: Duration(seconds: 20),
        animationDuration: Duration(milliseconds: 1),
      )..show(context);
    }
    setState(() {});
  }

  deleteUser() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('All the athlete\'s data including'),
                Text('activities will be deleted as well.'),
                Text('There is no undo function.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () => deleteAthleteAndPop(),
            ),
          ],
        );
      },
    );
  }

  deleteAthleteAndPop() async {
    await widget.athlete.delete();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  redoAutoTagging() async {
    flushbar = Flushbar(
      message: "Started cleaning up...",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);

    List<Activity> activities;
    activities = await Activity.all(athlete: widget.athlete);
    int index = 0;
    int percent;

    await TagGroup.deleteAllAutoTags(athlete: widget.athlete);
    Flushbar(
      message: "All existing autotaggings have been deleted.",
      duration: Duration(seconds: 2),
      icon: MyIcon.finishedWhite,
    )..show(context);

    for (Activity activity in activities) {
      index += 1;
      await activity.autoTagger(athlete: widget.athlete);
      flushbar.dismiss();
      percent = 100 * index ~/ activities.length;
      flushbar = Flushbar(
        titleText: LinearProgressIndicator(value: percent / 100),
        message: "$percent% done (autotagging »${activity.db.name}« )",
        duration: Duration(seconds: 2),
        animationDuration: Duration(milliseconds: 1),
      )..show(context);
    }

    flushbar.dismiss();
    Flushbar(
      message: "Autotaggings are now up to date.",
      duration: Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  }
}
