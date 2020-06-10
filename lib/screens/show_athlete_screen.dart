import 'dart:io';

import 'package:dio/dio.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/activities_list_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_ratio_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_zone_schema_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_heart_rate_zone_schema_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_tag_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/widgets/activities_feed_widget.dart';
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

import 'edit_athlete_screen.dart';

class ShowAthleteScreen extends StatefulWidget {
  const ShowAthleteScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _ShowAthleteScreenState createState() => _ShowAthleteScreenState();
}

class _ShowAthleteScreenState extends State<ShowAthleteScreen> {
  Flushbar<Object> flushbar;
  Visibility floatingActionButton;
  bool floatingActionButtonVisible;

  List<Widget> get tiles {
    return <Widget>[
      navigationButton(
        color: MyColor.activity,
        title: 'Activities Feed',
        icon: MyIcon.activities,
        backgroundColor: MyColor.activity,
        nextWidget: ActivitiesFeedWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.activity,
        title: 'Activities List',
        icon: MyIcon.activities,
        backgroundColor: MyColor.activity,
        nextWidget: ActivitiesListWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'Power',
        icon: MyIcon.power,
        nextWidget: AthletePowerWidget(athlete: widget.athlete),
      ),
      navigationButton(
        title: 'Power Ratio',
        color: MyColor.navigate,
        icon: MyIcon.power,
        nextWidget: AthletePowerRatioWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'Power / Heart Rate',
        icon: MyIcon.power,
        nextWidget: AthletePowerPerHeartRateWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'Ecor',
        icon: MyIcon.power,
        nextWidget: AthleteEcorWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'Stride Ratio',
        icon: MyIcon.strideRatio,
        nextWidget: AthleteStrideRatioWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'Speed / Heart Rate',
        icon: MyIcon.speed,
        nextWidget: AthleteSpeedPerHeartRateWidget(athlete: widget.athlete),
      ),
      RaisedButton.icon(
        color: MyColor.add,
        textColor: MyColor.textColor(backgroundColor: MyColor.add),
        icon: MyIcon.downloadLocal,
        label: const Expanded(
          child: Text('Import .fit from Folder'),
        ),
        onPressed: () => importLocal(),
      ),
      navigationButton(
        color: MyColor.settings,
        title: 'Body Weight',
        icon: MyIcon.weight,
        nextWidget: AthleteBodyWeightWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.settings,
        title: 'Power Zone Schemas',
        icon: MyIcon.power,
        nextWidget: AthletePowerZoneSchemaWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.settings,
        title: 'Heart Rate Zone Schemas',
        icon: MyIcon.heartRate,
        nextWidget: AthleteHeartRateZoneSchemaWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.tag,
        title: 'Tags',
        icon: MyIcon.tag,
        nextWidget: AthleteTagGroupWidget(athlete: widget.athlete),
      ),
      RaisedButton.icon(
        icon: MyIcon.secrets,
        color: MyColor.settings,
        onPressed: () => goToEditAthleteScreen(athlete: widget.athlete),
        label: const Expanded(
          child: Text('Credentials'),
        ),
      ),
      navigationButton(
        color: MyColor.settings,
        title: 'Settings',
        icon: MyIcon.settings,
        nextWidget: AthleteSettingsWidget(athlete: widget.athlete),
      ),
      RaisedButton.icon(
        color: MyColor.danger,
        textColor: MyColor.textColor(backgroundColor: MyColor.danger),
        icon: MyIcon.delete,
        label: const Expanded(
          child: Text('Delete Athlete'),
        ),
        onPressed: () => deleteUser(),
      ),
      RaisedButton.icon(
        color: MyColor.settings,
        icon: MyIcon.settings,
        textColor: MyColor.textColor(backgroundColor: MyColor.add),
        label: const Expanded(
          child: Text('Recalculate Averages'),
        ),
        onPressed: () => recalculate(),
      ),
      RaisedButton.icon(
        color: MyColor.settings,
        textColor: MyColor.textColor(backgroundColor: MyColor.settings),
        icon: MyIcon.settings,
        label: const Expanded(
          child: Text('Redo Autotagging'),
        ),
        onPressed: () => redoAutoTagging(),
      ),
      RaisedButton.icon(
        color: MyColor.primary,
        icon: MyIcon.download,
        label: const Expanded(
          child: Text('Download Demo Data'),
        ),
        onPressed: () => downloadDemoData(),
      ),
    ];
  }

  @override
  void initState() {
    floatingActionButtonVisible =
        widget.athlete.email != null && widget.athlete.password != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.athlete,
        title: Text(
          '${widget.athlete.firstName} ${widget.athlete.lastName}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      floatingActionButton: Visibility(
        visible: floatingActionButtonVisible,
        child: FloatingActionButton.extended(
          onPressed: () => updateJob(),
          label: const Text('from Strava'),
          icon: MyIcon.stravaDownload,
        ),
      ),
      body: StaggeredGridView.count(
        staggeredTiles: List<StaggeredTile>.filled(
          tiles.length,
          const StaggeredTile.fit(1),
        ),
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(10),
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
        children: tiles,
      ),
    );
  }

  Widget navigationButton({
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
      label: Expanded(
        child: Text(title),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<BuildContext>(
          builder: (BuildContext context) => ShowAthleteDetailScreen(
            athlete: widget.athlete,
            widget: nextWidget,
            title: title,
            backgroundColor: backgroundColor,
          ),
        ),
      ),
    );
  }

  Future<void> goToEditAthleteScreen({Athlete athlete}) async {
    await athlete.readCredentials();
    await Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) => EditAthleteScreen(athlete: athlete),
      ),
    );
  }

  Future<void> recalculate() async {
    List<Activity> activities;
    activities = await widget.athlete.activities;
    int index = 0;
    int percent;

    flushbar = Flushbar<Object>(
      message: 'Calculating...',
      duration: const Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);

    for (final Activity activity in activities) {
      index += 1;
      await activity.setAverages();
      flushbar.dismiss();
      percent = 100 * index ~/ activities.length;
      flushbar = Flushbar<Object>(
        titleText: LinearProgressIndicator(value: percent / 100),
        message: '$percent% done (recalculating »${activity.name}« )',
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 1),
      )..show(context);
    }

    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Averages are now up to date.',
      duration: const Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  }

  Future<void> importLocal() async {
    List<Activity> activities;

    flushbar = Flushbar<Object>(
      message: 'Importing activities from local directory',
      duration: const Duration(seconds: 1),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);
    await Activity.importFromLocalDirectory(athlete: widget.athlete);
    flushbar = Flushbar<Object>(
      message: 'Activities moved into application',
      duration: const Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    activities = await widget.athlete.activities;
    final List<Activity> downloadedActivities = activities
        .where((Activity activity) => activity.state == 'downloaded')
        .toList();
    for (final Activity activity in downloadedActivities) {
      await parse(activity: activity);
      await activity.autoTagger(athlete: widget.athlete);
    }
    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Activities imported!',
      duration: const Duration(seconds: 5),
      icon: MyIcon.finishedWhite,
    )..show(context);
  }

  Future<void> downloadDemoData() async {
    if (await widget.athlete.checkForSchemas()) {
      List<Activity> activities;
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Dio dio = Dio();
      const String downloadDir =
          'https://encrateia.informatom.com/assets/fit-files/';
      final List<String> fileNames = <String>[
        'munich_half_marathon.fit',
        'listener_meetup_run_cologne.fit',
        'stockholm_half_marathon.fit',
        'upper_palatinate_winter_challenge_half_marathon.fit',
      ];

      flushbar = Flushbar<Object>(
        message: 'Downloading Demo data ...',
        duration: const Duration(seconds: 1),
        icon: MyIcon.stravaDownloadWhite,
      )..show(context);

      for (final String filename in fileNames) {
        final Activity activity =
            Activity.fromLocalDirectory(athlete: widget.athlete);
        await dio.download(downloadDir + filename,
            appDocDir.path + '/' + activity.stravaId.toString() + '.fit');
        await activity.setState('downloaded');
      }

      flushbar = Flushbar<Object>(
        message: 'Downloading demo data finished',
        duration: const Duration(seconds: 1),
        icon: MyIcon.finishedWhite,
      )..show(context);

      activities = await widget.athlete.activities;
      final List<Activity> downloadedActivities = activities
          .where((Activity activity) => activity.state == 'downloaded')
          .toList();
      for (final Activity activity in downloadedActivities) {
        await parse(activity: activity);
        await activity.autoTagger(athlete: widget.athlete);
      }
      flushbar.dismiss();
      flushbar = Flushbar<Object>(
        message: 'Activities imported!',
        duration: const Duration(seconds: 5),
        icon: MyIcon.finishedWhite,
      )..show(context);
    } else {
      flushbar = Flushbar<Object>(
        message:
            'Please set up Power Zone Schema and Heart Rate Zone Schema first!',
        duration: const Duration(seconds: 5),
        icon: MyIcon.finishedWhite,
      )..show(context);
    }
  }

  Future<void> updateJob() async {
    List<Activity> activities;
    setState(() => floatingActionButtonVisible = false);

    if (await widget.athlete.checkForSchemas()) {
      await queryStrava();

      activities = await widget.athlete.activities;
      final Iterable<Activity> newActivities =
          activities.where((Activity activity) => activity.state == 'new');
      for (final Activity activity in newActivities) {
        await download(activity: activity);
      }

      final Iterable<Activity> downloadedActivities = activities
          .where((Activity activity) => activity.state == 'downloaded');
      for (final Activity activity in downloadedActivities) {
        await parse(activity: activity);
        await activity.autoTagger(athlete: widget.athlete);
      }
      flushbar.dismiss();
      flushbar = Flushbar<Object>(
        message: 'You are now up to date!',
        duration: const Duration(seconds: 5),
        icon: MyIcon.finishedWhite,
      )..show(context);

      setState(() => floatingActionButtonVisible = true);
    } else {
      flushbar = Flushbar<Object>(
        message:
            'Please set up Power Zone Schema and Heart Rate Zone Schema first!',
        duration: const Duration(seconds: 5),
        icon: MyIcon.finishedWhite,
      )..show(context);
    }
  }

  Future<void> queryStrava() async {
    flushbar = Flushbar<Object>(
      message: 'Downloading new activities',
      duration: const Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);
    await Activity.queryStrava(athlete: widget.athlete);
    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Download finished',
      duration: const Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    setState(() {});
  }

  Future<void> download({Activity activity}) async {
    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Download .fit-File for »${activity.name}«',
      duration: const Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    await activity.download(athlete: widget.athlete);

    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Download finished',
      duration: const Duration(seconds: 2),
      icon: MyIcon.finishedWhite,
    )..show(context);
    setState(() {});
  }

  Future<void> parse({Activity activity}) async {
    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: '0% of storing »${activity.name}«',
      duration: const Duration(seconds: 10),
      animationDuration: const Duration(milliseconds: 1),
      titleText: const LinearProgressIndicator(value: 0),
    )..show(context);

    final Stream<int> percentageStream =
        activity.parse(athlete: widget.athlete);
    await for (final int value in percentageStream) {
      flushbar.dismiss();
      flushbar = Flushbar<Object>(
        titleText: LinearProgressIndicator(value: value / 100),
        message: '$value% of storing »${activity.name}«',
        duration: const Duration(seconds: 20),
        animationDuration: const Duration(milliseconds: 1),
      )..show(context);
    }
    setState(() {});
  }

  Future<void> deleteUser() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('All the athlete\'s data including'),
                Text('activities will be deleted as well.'),
                Text('There is no undo function.'),
              ],
            ),
          ),
          actions: <Widget>[
            MyButton.cancel(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MyButton.delete(
              onPressed: () => deleteAthleteAndPop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAthleteAndPop() async {
    await widget.athlete.delete();
    Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
  }

  Future<void> redoAutoTagging() async {
    if (await widget.athlete.checkForSchemas()) {
      flushbar = Flushbar<Object>(
        message: 'Started cleaning up...',
        duration: const Duration(seconds: 5),
        icon: MyIcon.finishedWhite,
      )..show(context);

      List<Activity> activities;
      activities = await widget.athlete.activities;
      int index = 0;
      int percent;

      await TagGroup.deleteAllAutoTags(athlete: widget.athlete);
      flushbar = Flushbar<Object>(
        message: 'All existing autotaggings have been deleted.',
        duration: const Duration(seconds: 2),
        icon: MyIcon.finishedWhite,
      )..show(context);

      for (final Activity activity in activities) {
        index += 1;
        await activity.autoTagger(athlete: widget.athlete);
        flushbar.dismiss();
        percent = 100 * index ~/ activities.length;
        flushbar = Flushbar<Object>(
          titleText: LinearProgressIndicator(value: percent / 100),
          message: '$percent% done (autotagging »${activity.name}« )',
          duration: const Duration(seconds: 2),
          animationDuration: const Duration(milliseconds: 1),
        )..show(context);
      }

      flushbar.dismiss();
      flushbar = Flushbar<Object>(
        message: 'Autotaggings are now up to date.',
        duration: const Duration(seconds: 5),
        icon: MyIcon.finishedWhite,
      )..show(context);
    } else {
      flushbar = Flushbar<Object>(
        message:
            'Please set up Power Zone Schema and Heart Rate Zone Schema first!',
        duration: const Duration(seconds: 5),
        icon: MyIcon.finishedWhite,
      )..show(context);
    }
  }
}
