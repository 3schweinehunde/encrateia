import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/weight.dart';
import '/screens/show_activity_detail_screen.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button_style.dart';
import '/utils/my_color.dart';
import '/widgets/activity_widgets/activity_altitude_widget.dart';
import '/widgets/activity_widgets/activity_bargraph_widget.dart';
import '/widgets/activity_widgets/activity_ecor_widget.dart';
import '/widgets/activity_widgets/activity_event_list_widget.dart';
import '/widgets/activity_widgets/activity_form_power_widget.dart';
import '/widgets/activity_widgets/activity_ftp_widget.dart';
import '/widgets/activity_widgets/activity_ground_time_widget.dart';
import '/widgets/activity_widgets/activity_heart_rate_widget.dart';
import '/widgets/activity_widgets/activity_leg_spring_stiffness_widget.dart';
import '/widgets/activity_widgets/activity_metadata_widget.dart';
import '/widgets/activity_widgets/activity_overview_widget.dart';
import '/widgets/activity_widgets/activity_pace_widget.dart';
import '/widgets/activity_widgets/activity_path_widget.dart';
import '/widgets/activity_widgets/activity_power_duration_widget.dart';
import '/widgets/activity_widgets/activity_power_per_heart_rate_widget.dart';
import '/widgets/activity_widgets/activity_power_ratio_widget.dart';
import '/widgets/activity_widgets/activity_power_widget.dart';
import '/widgets/activity_widgets/activity_speed_per_heart_rate_widget.dart';
import '/widgets/activity_widgets/activity_speed_widget.dart';
import '/widgets/activity_widgets/activity_stride_ratio_widget.dart';
import '/widgets/activity_widgets/activity_stryd_cadence_widget.dart';
import '/widgets/activity_widgets/activity_tag_widget.dart';
import '/widgets/activity_widgets/activity_vertical_oscillation_widget.dart';
import '/widgets/activity_widgets/activity_work_widget.dart';
import '/widgets/activity_widgets/edit_activity_widget.dart';
import '/widgets/intervals_list_widget.dart';
import '/widgets/laps_list_widget.dart';

class ShowActivityScreen extends StatefulWidget {
  const ShowActivityScreen({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity activity;
  final Athlete athlete;

  @override
  _ShowActivityScreenState createState() => _ShowActivityScreenState();
}

class _ShowActivityScreenState extends State<ShowActivityScreen> {
  Weight? weight;

  List<Widget> get tiles {
    return <Widget>[
      navigationButton(
        color: MyColor.settings,
        title: 'Overview',
        icon: MyIcon.overView,
        context: context,
        nextWidget: ActivityOverviewWidget(
          activity: widget.activity,
          athlete: widget.athlete,
        ),
      ),
      navigationButton(
        color: MyColor.settings,
        title: 'Bargraphs',
        icon: MyIcon.barGraph,
        context: context,
        nextWidget: ActivityBarGraphWidget(
          activity: widget.activity,
          athlete: widget.athlete,
        ),
      ),
      if (widget.activity.cachedLaps.isNotEmpty)
        navigationButton(
          title: 'Laps List',
          color: MyColor.lap,
          backgroundColor: MyColor.lap,
          icon: MyIcon.laps,
          context: context,
          nextWidget: LapsListWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      navigationButton(
        title: 'Intervals',
        color: MyColor.interval,
        backgroundColor: MyColor.interval,
        icon: MyIcon.laps,
        context: context,
        nextWidget: IntervalsListWidget(
          activity: widget.activity,
          athlete: widget.athlete,
        ),
      ),
      navigationButton(
        title: 'Path',
        color: MyColor.navigate,
        backgroundColor: MyColor.navigate,
        icon: MyIcon.map,
        context: context,
        nextWidget: ActivityPathWidget(
          activity: widget.activity,
          athlete: widget.athlete,
        ),
      ),
      if (widget.activity.heartRateAvailable)
        navigationButton(
          title: 'Heart Rate',
          color: MyColor.navigate,
          icon: MyIcon.heartRate,
          context: context,
          nextWidget: ActivityHeartRateWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.powerAvailable)
        navigationButton(
          title: 'Power',
          color: MyColor.navigate,
          icon: MyIcon.power,
          context: context,
          nextWidget: ActivityPowerWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.powerAvailable)
        navigationButton(
          title: 'Power Duration',
          color: MyColor.navigate,
          icon: MyIcon.powerDuration,
          context: context,
          nextWidget: ActivityPowerDurationWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.powerAvailable && widget.activity.heartRateAvailable)
        navigationButton(
          title: 'Power / Heart Rate',
          color: MyColor.navigate,
          icon: MyIcon.power,
          context: context,
          nextWidget: ActivityPowerPerHeartRateWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.paceAvailable)
        navigationButton(
          title: 'Pace',
          color: MyColor.navigate,
          icon: MyIcon.speed,
          context: context,
          nextWidget: ActivityPaceWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.speedAvailable)
        navigationButton(
          title: 'Speed',
          color: MyColor.navigate,
          backgroundColor: MyColor.navigate,
          icon: MyIcon.speed,
          context: context,
          nextWidget: ActivitySpeedWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.ecorAvailable)
        navigationButton(
          title: 'Ecor',
          color: MyColor.navigate,
          icon: MyIcon.power,
          context: context,
          nextWidget: ActivityEcorWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.speedAvailable)
        navigationButton(
          title: 'Speed / Heart Rate',
          color: MyColor.navigate,
          icon: MyIcon.speed,
          context: context,
          nextWidget: ActivitySpeedPerHeartRateWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.groundTimeAvailable)
        navigationButton(
          title: 'Ground Time',
          color: MyColor.navigate,
          icon: MyIcon.groundTime,
          context: context,
          nextWidget: ActivityGroundTimeWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.formPowerAvailable)
        navigationButton(
          title: 'Form Power',
          color: MyColor.navigate,
          icon: MyIcon.formPower,
          context: context,
          nextWidget: ActivityFormPowerWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.powerRatioAvailable)
        navigationButton(
          title: 'Power Ratio',
          color: MyColor.navigate,
          icon: MyIcon.formPower,
          context: context,
          nextWidget: ActivityPowerRatioWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.verticalOscillationAvailable)
        navigationButton(
          title: 'Vertical Oscillation',
          color: MyColor.navigate,
          icon: MyIcon.verticalOscillation,
          context: context,
          nextWidget: ActivityVerticalOscillationWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.strideRatioAvailable)
        navigationButton(
          title: 'Stride Ratio',
          color: MyColor.navigate,
          icon: MyIcon.strideRatio,
          context: context,
          nextWidget: ActivityStrideRatioWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.strideCadenceAvailable)
        navigationButton(
          title: 'Cadence',
          color: MyColor.navigate,
          icon: MyIcon.cadence,
          context: context,
          nextWidget: ActivityStrydCadenceWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.legSpringStiffnessAvailable)
        navigationButton(
          title: 'Leg Spring Stiffness',
          color: MyColor.navigate,
          icon: MyIcon.legSpringStiffness,
          context: context,
          nextWidget: ActivityLegSpringStiffnessWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (widget.activity.powerAvailable)
        navigationButton(
          title: 'FTP',
          color: MyColor.navigate,
          icon: MyIcon.ftp,
          context: context,
          nextWidget: ActivityFtpWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      if (kDebugMode && widget.activity.powerAvailable)
        navigationButton(
          title: 'Work / CP',
          color: MyColor.navigate,
          icon: MyIcon.work,
          context: context,
          nextWidget: ActivityWorkWidget(
            activity: widget.activity,
            athlete: widget.athlete,
          ),
        ),
      navigationButton(
        title: 'Altitude',
        color: MyColor.navigate,
        icon: MyIcon.altitude,
        context: context,
        nextWidget: ActivityAltitudeWidget(
          activity: widget.activity,
          athlete: widget.athlete,
        ),
      ),
      navigationButton(
        title: 'Metadata',
        color: MyColor.settings,
        icon: MyIcon.metaData,
        context: context,
        nextWidget: ActivityMetadataWidget(
          activity: widget.activity,
          athlete: widget.athlete,
        ),
      ),
      navigationButton(
        title: 'Tags',
        color: MyColor.tag,
        icon: MyIcon.tag,
        context: context,
        nextWidget: ActivityTagWidget(
          activity: widget.activity,
          athlete: widget.athlete,
        ),
      ),
      ElevatedButton.icon(
        style: MyButtonStyle.raisedButtonStyle(
            color: MyColor.add,
            textColor: MyColor.textColor(backgroundColor: MyColor.add)),
        icon: MyIcon.settings,
        label: const Text('Rerun Autotagging'),
        onPressed: () => autoTagger(),
      ),
      if (<String>['new', 'downloaded', 'persisted']
          .contains(widget.activity.state))
        ElevatedButton.icon(
          style: MyButtonStyle.raisedButtonStyle(
              color: MyColor.add,
              textColor: MyColor.textColor(backgroundColor: MyColor.add)),
          icon: MyIcon.download,
          label: const Text('Download fit file'),
          onPressed: () => download(),
        ),
      if (<String>['downloaded', 'persisted'].contains(widget.activity.state))
        ElevatedButton.icon(
          style: MyButtonStyle.raisedButtonStyle(
              color: MyColor.add,
              textColor: MyColor.textColor(backgroundColor: MyColor.add)),
          icon: MyIcon.parse,
          label: const Text('Parse fit file'),
          onPressed: () => parse(),
        ),
      if (widget.activity.excluded == true)
        ElevatedButton.icon(
          style: MyButtonStyle.raisedButtonStyle(
              color: MyColor.include,
              textColor: MyColor.textColor(backgroundColor: MyColor.include)),
          icon: MyIcon.filter,
          label: const Text('Include in Analysis'),
          onPressed: () => include(),
        )
      else
        ElevatedButton.icon(
          style: MyButtonStyle.raisedButtonStyle(
              color: MyColor.exclude,
              textColor: MyColor.textColor(backgroundColor: MyColor.exclude)),
          icon: MyIcon.filter,
          label: const Text('Exclude from Analysis'),
          onPressed: () => exclude(),
        ),
      navigationButton(
        title: 'Data Points',
        color: MyColor.navigate,
        icon: MyIcon.metaData,
        context: context,
        nextWidget: ActivityEventListWidget(
          activity: widget.activity,
          athlete: widget.athlete,
        ),
      ),
      navigationButton(
        title: 'Edit Activity',
        color: MyColor.activity,
        icon: MyIcon.addActivity,
        context: context,
        nextWidget: EditActivityWidget(
          activity: widget.activity,
        ),
      ),
      if (<String>['new', 'downloaded', 'persisted']
          .contains(widget.activity.state))
        ElevatedButton.icon(
          style: MyButtonStyle.raisedButtonStyle(
              color: MyColor.delete,
              textColor: MyColor.textColor(backgroundColor: MyColor.delete)),
          icon: MyIcon.delete,
          label: const Text('Delete Activity'),
          onPressed: () => delete(),
        ),
    ];
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.activity,
        title: Text(
          widget.activity.name ?? '',
          overflow: TextOverflow.ellipsis,
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
    required BuildContext context,
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
          builder: (BuildContext context) => ShowActivityDetailScreen(
            activity: widget.activity,
            widget: nextWidget,
            title: title,
            backgroundColor: backgroundColor,
          ),
        ),
      ),
    );
  }

  Future<void> autoTagger() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Row(
          children: [
            MyIcon.stravaDownloadWhite,
            const Text(' Starting Autotagger'),
          ],
        ),
      ),
    );

    await widget.activity.autoTagger(athlete: widget.athlete);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text(' Autotagging finished'),
          ],
        ),
      ),
    );
    setState(() {});
  }

  Future<void> exclude() async {
    widget.activity.excluded = true;
    await widget.activity.save();
    setState(() {});
  }

  Future<void> include() async {
    widget.activity.excluded = false;
    await widget.activity.save();
    setState(() {});
  }

  Future<void> delete() async {
    await widget.activity.delete();
    Navigator.of(context).pop();
  }

  Future<void> download() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Row(
          children: [
            MyIcon.stravaDownloadWhite,
            Text(' Download .fit-File for »${widget.activity.name}«'),
          ],
        ),
      ),
    );

    await widget.activity.download(athlete: widget.athlete);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Row(
          children: [
            MyIcon.finishedWhite,
            const Text(' Download finished'),
          ],
        ),
      ),
    );

    await parse();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text('Analysis finished for »${widget.activity.name}«'),
      ),
    );
  }

  Future<void> parse() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Row(
          children: [
            CircularProgressIndicator(value: 0, color: MyColor.progress),
            Text(' storing »${widget.activity.name}«'),
          ],
        ),
      ),
    );

    final Stream<int> percentageStream =
        widget.activity.parse(athlete: widget.athlete);
    await for (final int value in percentageStream) {
      if (value == -2) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      } else if (value == -1) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text('Analysing »${widget.activity.name}«'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Row(
              children: [
                CircularProgressIndicator(
                    value: value / 100, color: MyColor.progress),
                Text(' storing »${widget.activity.name}«'),
              ],
            ),
          ),
        );
      }
    }
    setState(() {});
  }

  Future<void> getData() async {
    await widget.activity.laps;
    await widget.activity.weight;
    setState(() {});
  }
}
