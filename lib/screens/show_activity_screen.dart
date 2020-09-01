import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/activity_widgets/activity_bargraph_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_ftp_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_speed_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_metadata_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_overview_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_pace_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_altitude_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_ratio_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_record_list_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_speed_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_tag_widget.dart';
import 'package:encrateia/widgets/intervals_list_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_work_widget.dart';
import 'package:encrateia/widgets/laps_list_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_path_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_ecor_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_duration_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_ground_time_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_leg_spring_stiffness_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_form_power_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_stryd_cadence_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_stride_ratio_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_vertical_oscillation_widget.dart';
import 'package:encrateia/screens/show_activity_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShowActivityScreen extends StatefulWidget {
  const ShowActivityScreen({
    Key key,
    @required this.activity,
    @required this.athlete,
  }) : super(key: key);

  final Activity activity;
  final Athlete athlete;

  @override
  _ShowActivityScreenState createState() => _ShowActivityScreenState();
}

class _ShowActivityScreenState extends State<ShowActivityScreen> {
  Flushbar<Object> flushbar = Flushbar<Object>();
  Weight weight;

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
      if (kDebugMode)
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
      RaisedButton.icon(
        color: MyColor.add,
        icon: MyIcon.settings,
        textColor: MyColor.textColor(backgroundColor: MyColor.add),
        label: const Expanded(
          child: Text('Rerun Autotagging'),
        ),
        onPressed: () => autoTagger(),
      ),
      if (<String>['new', 'downloaded', 'persisted']
          .contains(widget.activity.state))
        RaisedButton.icon(
          color: MyColor.add,
          icon: MyIcon.download,
          textColor: MyColor.textColor(backgroundColor: MyColor.add),
          label: const Expanded(
            child: Text('Download fit file'),
          ),
          onPressed: () => download(),
        ),
      if (<String>['downloaded', 'persisted'].contains(widget.activity.state))
        RaisedButton.icon(
          color: MyColor.add,
          icon: MyIcon.parse,
          textColor: MyColor.textColor(backgroundColor: MyColor.add),
          label: const Expanded(
            child: Text('Parse fit file'),
          ),
          onPressed: () => parse(),
        ),
      if (widget.activity.excluded == true)
        RaisedButton.icon(
          color: MyColor.include,
          icon: MyIcon.filter,
          textColor: MyColor.textColor(backgroundColor: MyColor.include),
          label: const Expanded(
            child: Text('Include in Analysis'),
          ),
          onPressed: () => include(),
        )
      else
        RaisedButton.icon(
          color: MyColor.exclude,
          icon: MyIcon.filter,
          textColor: MyColor.textColor(backgroundColor: MyColor.exclude),
          label: const Expanded(
            child: Text('Exclude from Analysis'),
          ),
          onPressed: () => exclude(),
        ),
      navigationButton(
        title: 'Data Points',
        color: MyColor.navigate,
        icon: MyIcon.metaData,
        context: context,
        nextWidget: ActivityRecordListWidget(
          activity: widget.activity,
          athlete: widget.athlete,
        ),
      ),
      if (<String>['new', 'downloaded', 'persisted']
          .contains(widget.activity.state))
        RaisedButton.icon(
          color: MyColor.delete,
          icon: MyIcon.delete,
          textColor: MyColor.textColor(backgroundColor: MyColor.delete),
          label: const Expanded(
            child: Text('Delete Activity'),
          ),
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
          widget.activity.name,
          overflow: TextOverflow.ellipsis,
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
    @required BuildContext context,
    @required Widget nextWidget,
    @required Widget icon,
    @required String title,
    @required Color color,
    Color backgroundColor,
  }) {
    return RaisedButton.icon(
      color: color,
      textColor: MyColor.textColor(backgroundColor: color),
      icon: icon,
      label: Expanded(
        child: Text(title),
      ),
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
    flushbar = Flushbar<Object>(
      message: 'Starting Autotagger',
      duration: const Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    await widget.activity.autoTagger(athlete: widget.athlete);

    await flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Autotagging finished',
      duration: const Duration(seconds: 2),
      icon: MyIcon.finishedWhite,
    )..show(context);
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
    flushbar = Flushbar<Object>(
      message: 'Download .fit-File for »${widget.activity.name}«',
      duration: const Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    await widget.activity.download(athlete: widget.athlete);

    await flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Download finished',
      duration: const Duration(seconds: 1),
      icon: MyIcon.finishedWhite,
    )..show(context);

    await parse();
    flushbar = Flushbar<Object>(
      message: 'Analysis finished for »${widget.activity.name}«',
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 0),
    )..show(context);
  }

  Future<void> parse() async {
    Flushbar<Object> flushbar = Flushbar<Object>(
      message: '0% of storing »${widget.activity.name}«',
      duration: const Duration(seconds: 10),
      animationDuration: const Duration(milliseconds: 0),
      titleText: const LinearProgressIndicator(value: 0),
    )..show(context);

    final Stream<int> percentageStream =
        widget.activity.parse(athlete: widget.athlete);
    await for (final int value in percentageStream) {
      if (value == -2)
        await flushbar?.dismiss();
      else if (value == -1) {
        await flushbar?.dismiss();
        flushbar = Flushbar<Object>(
          message: 'Analysing »${widget.activity.name}«',
          duration: const Duration(seconds: 1),
          animationDuration: const Duration(milliseconds: 0),
        )..show(context);
      } else {
        await flushbar.dismiss();
        flushbar = Flushbar<Object>(
          titleText: LinearProgressIndicator(value: value / 100),
          message: '$value% of storing »${widget.activity.name}«',
          duration: const Duration(seconds: 3),
          animationDuration: const Duration(milliseconds: 0),
        )..show(context);
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
