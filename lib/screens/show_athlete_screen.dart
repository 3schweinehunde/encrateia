import 'package:encrateia/actions/analyse_activities.dart';
import 'package:encrateia/actions/import_activities_locally.dart';
import 'package:encrateia/models/strava_token.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/activities_list_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_ftp_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_heart_rate_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_pace_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_ratio_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_zone_schema_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_heart_rate_zone_schema_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_stryd_cadence_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_tag_group_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_volume_widget.dart';
import 'package:encrateia/widgets/intervals_feed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/actions/auto_tagging.dart';
import 'package:encrateia/actions/delete_athlete.dart';
import 'package:encrateia/actions/download_demo_data.dart';
import 'package:encrateia/actions/update_job.dart';
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
import 'create_activity_screen.dart';
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
  Flushbar<Object> flushbar = Flushbar<Object>();
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
        color: MyColor.interval,
        title: 'Interval Feed',
        icon: MyIcon.intervals,
        backgroundColor: MyColor.activity,
        nextWidget: IntervalsFeedWidget(athlete: widget.athlete),
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
        title: 'Pace',
        icon: MyIcon.speed,
        nextWidget: AthletePaceWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'Heart Rate',
        icon: MyIcon.heartRate,
        nextWidget: AthleteHeartRateWidget(athlete: widget.athlete),
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
      navigationButton(
        color: MyColor.navigate,
        title: 'Cadence',
        icon: MyIcon.cadence,
        nextWidget: AthleteStrydCadenceWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'FTP',
        icon: MyIcon.ftp,
        nextWidget: AthleteFtpWidget(athlete: widget.athlete),
      ),
      if (kDebugMode)
        navigationButton(
          color: MyColor.navigate,
          title: 'Volume',
          icon: MyIcon.volume,
          nextWidget: AthleteVolumeWidget(athlete: widget.athlete),
        ),
      RaisedButton.icon(
        color: MyColor.add,
        textColor: MyColor.textColor(backgroundColor: MyColor.add),
        icon: MyIcon.downloadLocal,
        label: const Expanded(
          child: Text('Import .fit from Folder'),
        ),
        onPressed: () async {
          await importActivitiesLocally(
            context: context,
            athlete: widget.athlete,
            flushbar: flushbar,
          );
        },
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
        icon: MyIcon.addActivity,
        color: MyColor.activity,
        onPressed: () => goToEditActivityScreen(athlete: widget.athlete),
        label: const Expanded(
          child: Text('Create Activity manually'),
        ),
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
        onPressed: () => deleteAthlete(
          context: context,
          athlete: widget.athlete,
          flushbar: flushbar,
        ),
      ),
      RaisedButton.icon(
        color: MyColor.settings,
        icon: MyIcon.settings,
        textColor: MyColor.textColor(backgroundColor: MyColor.add),
        label: const Expanded(
          child: Text('Reanalyse Activities'),
        ),
        onPressed: () => analyseActivities(
          context: context,
          athlete: widget.athlete,
          flushbar: flushbar,
        ),
      ),
      RaisedButton.icon(
        color: MyColor.settings,
        textColor: MyColor.textColor(backgroundColor: MyColor.settings),
        icon: MyIcon.settings,
        label: const Expanded(
          child: Text('Redo Autotagging'),
        ),
        onPressed: () => autoTagging(
          context: context,
          athlete: widget.athlete,
          flushbar: flushbar,
        ),
      ),
      RaisedButton.icon(
        color: MyColor.primary,
        icon: MyIcon.download,
        label: const Expanded(
          child: Text('Download Demo Data'),
        ),
        onPressed: () => downloadDemoData(
          context: context,
          athlete: widget.athlete,
          flushbar: flushbar,
        ),
      ),
      if (widget.athlete.stravaId != null)
        RaisedButton.icon(
            color: MyColor.settings,
            textColor: MyColor.textColor(backgroundColor: MyColor.settings),
            icon: MyIcon.settings,
            label: const Expanded(
              child: Text('Delete Strava Token'),
            ),
            onPressed: () async {
              await StravaToken.deleteTokenData(athlete: widget.athlete);
              setState(() {});
            }),
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
          onPressed: () {
            setState(() => floatingActionButtonVisible = false);
            updateJob(
              context: context,
              athlete: widget.athlete,
              flushbar: flushbar,
            );
            setState(() => floatingActionButtonVisible = true);
          },
          label: const Text('from Strava'),
          icon: MyIcon.stravaDownload,
        ),
      ),
      body: SafeArea(
        child: StaggeredGridView.count(
          staggeredTiles: List<StaggeredTile>.filled(
            tiles.length,
            const StaggeredTile.fit(1),
          ),
          crossAxisSpacing: 10,
          padding: const EdgeInsets.all(10),
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 2
                  : 4,
          children: tiles,
        ),
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

  Future<void> goToEditAthleteScreen({@required Athlete athlete}) async {
    await athlete.readCredentials();
    await Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) => EditAthleteScreen(athlete: athlete),
      ),
    );
  }

  Future<void> goToEditActivityScreen({@required Athlete athlete}) async {
    final Activity activity = Activity.manual(athlete: athlete);
    await Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) => EditActivityScreen(activity: activity),
      ),
    );
  }
}
