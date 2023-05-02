import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/interval.dart' as encrateia;
import '/screens/show_interval_detail_screen.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button_style.dart';
import '/utils/my_color.dart';
import '/widgets/interval_widgets/interval_altitude_widget.dart';
import '/widgets/interval_widgets/interval_ecor_widget.dart';
import '/widgets/interval_widgets/interval_form_power_widget.dart';
import '/widgets/interval_widgets/interval_ground_time_widget.dart';
import '/widgets/interval_widgets/interval_heart_rate_widget.dart';
import '/widgets/interval_widgets/interval_leg_spring_stiffness_widget.dart';
import '/widgets/interval_widgets/interval_overview_widget.dart';
import '/widgets/interval_widgets/interval_pace_widget.dart';
import '/widgets/interval_widgets/interval_power_duration.dart';
import '/widgets/interval_widgets/interval_power_widget.dart';
import '/widgets/interval_widgets/interval_speed_widget.dart';
import '/widgets/interval_widgets/interval_stryd_cadence_widget.dart';
import '/widgets/interval_widgets/interval_tag_widget.dart';
import '/widgets/interval_widgets/interval_vertical_oscillation_widget.dart';

class ShowIntervalScreen extends StatelessWidget {
  const ShowIntervalScreen({
    Key? key,
    required this.interval,
    required this.intervals,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final encrateia.Interval interval;
  final List<encrateia.Interval> intervals;
  final Athlete? athlete;
  final Activity? activity;

  List<Widget> tiles({required BuildContext context}) {
    return <Widget>[
      navigationButton(
        title: 'Overview',
        color: MyColor.settings,
        icon: MyIcon.metaData,
        context: context,
        nextWidget: ({encrateia.Interval? interval}) => IntervalOverviewWidget(
          interval: interval,
          athlete: athlete,
        ),
      ),
      if (interval.heartRateAvailable)
        navigationButton(
          title: 'Heart Rate',
          color: MyColor.navigate,
          icon: MyIcon.heartRate,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalHeartRateWidget(interval: interval),
        ),
      if (interval.powerAvailable)
        navigationButton(
          title: 'Power',
          color: MyColor.navigate,
          icon: MyIcon.power,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalPowerWidget(interval: interval),
        ),
      if (interval.powerAvailable)
        navigationButton(
          title: 'Power Duration',
          color: MyColor.navigate,
          icon: MyIcon.powerDuration,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalPowerDurationWidget(interval: interval),
        ),
      if (interval.paceAvailable)
        navigationButton(
          title: 'Pace',
          color: MyColor.navigate,
          icon: MyIcon.speed,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalPaceWidget(interval: interval),
        ),
      if (interval.speedAvailable)
        navigationButton(
          title: 'Speed',
          color: MyColor.navigate,
          icon: MyIcon.speed,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalSpeedWidget(interval: interval),
        ),
      if (interval.speedAvailable && interval.powerAvailable)
        navigationButton(
          title: 'Ecor',
          color: MyColor.navigate,
          icon: MyIcon.power,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) => IntervalEcorWidget(
            interval: interval,
            athlete: athlete,
          ),
        ),
      if (interval.groundTimeAvailable)
        navigationButton(
          title: 'Ground Time',
          color: MyColor.navigate,
          icon: MyIcon.groundTime,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalGroundTimeWidget(interval: interval),
        ),
      if (interval.groundTimeAvailable)
        navigationButton(
          title: 'Leg Spring Stiffness',
          color: MyColor.navigate,
          icon: MyIcon.legSpringStiffness,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalLegSpringStiffnessWidget(interval: interval),
        ),
      if (interval.formPowerAvailable)
        navigationButton(
          title: 'Form Power',
          color: MyColor.navigate,
          icon: MyIcon.formPower,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalFormPowerWidget(interval: interval),
        ),
      if (interval.cadenceAvailable)
        navigationButton(
          title: 'Cadence',
          color: MyColor.navigate,
          icon: MyIcon.cadence,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalStrydCadenceWidget(interval: interval),
        ),
      if (interval.verticalOscillationAvailable)
        navigationButton(
          title: 'Vertical Oscillation',
          color: MyColor.navigate,
          icon: MyIcon.verticalOscillation,
          context: context,
          nextWidget: ({encrateia.Interval? interval}) =>
              IntervalVerticalOscillationWidget(interval: interval),
        ),
      navigationButton(
        title: 'Altitude',
        color: MyColor.navigate,
        icon: MyIcon.altitude,
        context: context,
        nextWidget: ({encrateia.Interval? interval}) =>
            IntervalAltitudeWidget(interval: interval),
      ),
      navigationButton(
        title: 'Tags',
        color: MyColor.tag,
        icon: MyIcon.tag,
        context: context,
        nextWidget: ({encrateia.Interval? interval}) => IntervalTagWidget(
          interval: interval,
          athlete: athlete,
        ),
      ),
      ElevatedButton.icon(
        style: MyButtonStyle.raisedButtonStyle(
            color: MyColor.delete,
            textColor: MyColor.textColor(backgroundColor: MyColor.delete)),
        icon: MyIcon.delete,
        label: const Expanded(
          child: Text('Delete Interval'),
        ),
        onPressed: () async {
          await interval.delete();
          activity!.cachedIntervals = <encrateia.Interval>[];
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.interval,
        title: Text(
          'Interval ${intervals.reversed.toList().indexOf(interval) + 1}',
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
          children: tiles(context: context),
        ),
      ),
    );
  }

  Widget navigationButton({
    required BuildContext context,
    required Widget Function({encrateia.Interval? interval}) nextWidget,
    required Widget icon,
    required String title,
    required Color color,
  }) {
    return ElevatedButton.icon(
      style: MyButtonStyle.raisedButtonStyle(
          color: color, textColor: MyColor.textColor(backgroundColor: color)),
      icon: icon,
      label: Expanded(
        child: Text(title),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<BuildContext>(
          builder: (BuildContext context) => ShowIntervalDetailScreen(
            interval: interval,
            intervals: intervals,
            nextWidget: nextWidget,
            title: title,
          ),
        ),
      ),
    );
  }
}
