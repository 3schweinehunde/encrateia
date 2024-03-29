import 'package:flutter/material.dart';
import '/actions/analyse_activities.dart';
import '/actions/auto_tagging.dart';
import '/actions/delete_athlete.dart';
import '/actions/download_demo_data.dart';
import '/actions/import_activities_locally.dart';
import '/actions/update_job.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/screens/show_athlete_detail_screen.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button_style.dart';
import '/utils/my_color.dart';
import '/widgets/activities_feed_widget.dart';
import '/widgets/activities_list_widget.dart';
import '/widgets/athlete_widgets/athlete_body_weight_widget.dart';
import '/widgets/athlete_widgets/athlete_distance_widget.dart';
import '/widgets/athlete_widgets/athlete_ecor_widget.dart';
import '/widgets/athlete_widgets/athlete_ftp_widget.dart';
import '/widgets/athlete_widgets/athlete_heart_rate_widget.dart';
import '/widgets/athlete_widgets/athlete_heart_rate_zone_schema_widget.dart';
import '/widgets/athlete_widgets/athlete_moving_time_widget.dart';
import '/widgets/athlete_widgets/athlete_pace_vs_distance.dart';
import '/widgets/athlete_widgets/athlete_pace_widget.dart';
import '/widgets/athlete_widgets/athlete_power_per_heart_rate_widget.dart';
import '/widgets/athlete_widgets/athlete_power_ratio_widget.dart';
import '/widgets/athlete_widgets/athlete_power_vs_distance.dart';
import '/widgets/athlete_widgets/athlete_power_widget.dart';
import '/widgets/athlete_widgets/athlete_power_zone_schema_widget.dart';
import '/widgets/athlete_widgets/athlete_settings_widget.dart';
import '/widgets/athlete_widgets/athlete_speed_per_heart_rate_widget.dart';
import '/widgets/athlete_widgets/athlete_stride_ratio_widget.dart';
import '/widgets/athlete_widgets/athlete_stryd_cadence_widget.dart';
import '/widgets/athlete_widgets/athlete_tag_group_widget.dart';
import '/widgets/intervals_feed_widget.dart';
import 'create_activity_screen.dart';
import 'edit_athlete_screen.dart';

class ShowAthleteScreen extends StatefulWidget {
  const ShowAthleteScreen({
    Key? key,
    required this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  ShowAthleteScreenState createState() => ShowAthleteScreenState();
}

class ShowAthleteScreenState extends State<ShowAthleteScreen> {
  Visibility? floatingActionButton;
  late bool floatingActionButtonVisible;

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
      navigationButton(
        color: MyColor.navigate,
        title: 'Distance over Time',
        icon: MyIcon.volume,
        nextWidget: AthleteDistanceWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'Moving Time over Time',
        icon: MyIcon.volume,
        nextWidget: AthleteMovingTimeWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'Pace vs Distance',
        icon: MyIcon.versus,
        nextWidget: AthletePaceVsDistanceWidget(athlete: widget.athlete),
      ),
      navigationButton(
        color: MyColor.navigate,
        title: 'Power vs Distance',
        icon: MyIcon.versus,
        nextWidget: AthletePowerVsDistanceWidget(athlete: widget.athlete),
      ),
      ElevatedButton.icon(
        style: MyButtonStyle.raisedButtonStyle(
            color: MyColor.add,
            textColor: MyColor.textColor(backgroundColor: MyColor.add)),
        icon: MyIcon.downloadLocal,
        label: const Text('Import .fit from Folder'),
        onPressed: () async {
          await importActivitiesLocally(
            context: context,
            athlete: widget.athlete,
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
      ElevatedButton.icon(
        style: MyButtonStyle.raisedButtonStyle(color: MyColor.activity),
        icon: MyIcon.addActivity,
        onPressed: () => goToEditActivityScreen(athlete: widget.athlete),
        label: const Text('Create Activity manually'),
      ),
      ElevatedButton.icon(
        style: MyButtonStyle.raisedButtonStyle(color: MyColor.settings),
        icon: MyIcon.secrets,
        onPressed: () => goToEditAthleteScreen(athlete: widget.athlete),
        label: const Text('Credentials'),
      ),
      navigationButton(
        color: MyColor.settings,
        title: 'Settings',
        icon: MyIcon.settings,
        nextWidget: AthleteSettingsWidget(athlete: widget.athlete),
      ),
      ElevatedButton.icon(
        style: MyButtonStyle.raisedButtonStyle(
            color: MyColor.danger,
            textColor: MyColor.textColor(backgroundColor: MyColor.danger)),
        icon: MyIcon.delete,
        label: const Text('Delete Athlete'),
        onPressed: () => deleteAthlete(
          context: context,
          athlete: widget.athlete,
        ),
      ),
      ElevatedButton.icon(
        style: MyButtonStyle.raisedButtonStyle(
            color: MyColor.settings,
            textColor: MyColor.textColor(backgroundColor: MyColor.settings)),
        icon: MyIcon.settings,
        label: const Text('Reanalyse Activities'),
        onPressed: () => analyseActivities(
          context: context,
          athlete: widget.athlete,
        ),
      ),
      ElevatedButton.icon(
        style: MyButtonStyle.raisedButtonStyle(
            color: MyColor.settings,
            textColor: MyColor.textColor(backgroundColor: MyColor.settings)),
        icon: MyIcon.settings,
        label: const Text('Redo Autotagging'),
        onPressed: () => autoTagging(
          context: context,
          athlete: widget.athlete,
        ),
      ),
      ElevatedButton.icon(
        style: MyButtonStyle.raisedButtonStyle(color: MyColor.primary),
        icon: MyIcon.download,
        label: const Text('Download Demo Data'),
        onPressed: () => downloadDemoData(
          context: context,
          athlete: widget.athlete,
        ),
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
          onPressed: () {
            setState(() => floatingActionButtonVisible = false);
            updateJob(
              context: context,
              athlete: widget.athlete,
            );
            setState(() => floatingActionButtonVisible = true);
          },
          label: const Text('from Strava'),
          icon: MyIcon.stravaDownload,
        ),
      ),
      body: SafeArea(
        child: GridView.extent(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 5,
          padding: const EdgeInsets.all(10),
          maxCrossAxisExtent: 250,
          children: tiles,
        ),
      ),
    );
  }

  Widget navigationButton({
    required Widget nextWidget,
    required Widget icon,
    required String title,
    required Color color,
    Color? backgroundColor,
  }) {
    return ElevatedButton.icon(
      style: MyButtonStyle.raisedButtonStyle(
          color: color, textColor: MyColor.textColor(backgroundColor: color)),
      icon: icon,
      label: Text(title),
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

  Future<void> goToEditAthleteScreen({required Athlete athlete}) async {
    await athlete.readCredentials();
    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute<BuildContext>(
          builder: (BuildContext context) =>
              EditAthleteScreen(athlete: athlete),
        ),
      );
    }
  }

  Future<void> goToEditActivityScreen({required Athlete athlete}) async {
    final Activity activity = Activity.manual(athlete: athlete);
    await Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) =>
            EditActivityScreen(activity: activity),
      ),
    );
  }
}
