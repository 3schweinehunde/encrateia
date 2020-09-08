import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/screens/show_interval_detail_screen.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/interval_widgets/interval_ground_time_widget.dart';
import 'package:encrateia/widgets/interval_widgets/interval_heart_rate_widget.dart';
import 'package:encrateia/widgets/interval_widgets/interval_overview_widget.dart';
import 'package:encrateia/widgets/interval_widgets/lap_power_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShowIntervalScreen extends StatelessWidget {
  const ShowIntervalScreen({
    Key key,
    @required this.interval,
    @required this.intervals,
    @required this.athlete,
  }) : super(key: key);

  final encrateia.Interval interval;
  final List<encrateia.Interval> intervals;
  final Athlete athlete;

  List<Widget> tiles({@required BuildContext context}) {
    return <Widget>[
      navigationButton(
        title: 'Overview',
        color: MyColor.settings,
        icon: MyIcon.metaData,
        context: context,
        nextWidget: ({encrateia.Interval interval}) => IntervalOverviewWidget(
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
            nextWidget: ({encrateia.Interval interval}) =>
                IntervalHeartRateWidget(interval: interval),
            ),
      if (interval.powerAvailable)
        navigationButton(
            title: 'Power',
            color: MyColor.navigate,
            icon: MyIcon.power,
            context: context,
            nextWidget: ({encrateia.Interval interval}) =>
                IntervalPowerWidget(interval: interval),
            ),
      if (interval.powerAvailable)
        navigationButton(
            title: 'Power Duration',
            color: MyColor.navigate,
            icon: MyIcon.powerDuration,
            context: context,
            nextWidget: ({encrateia.Interval interval}) => const Text(
                '') // IntervalPowerDurationWidget(interval: interval),
            ),
      if (interval.paceAvailable)
        navigationButton(
            title: 'Pace',
            color: MyColor.navigate,
            icon: MyIcon.speed,
            context: context,
            nextWidget: ({encrateia.Interval interval}) =>
                const Text('') // IntervalPaceWidget(interval: interval),
            ),
      if (interval.speedAvailable)
        navigationButton(
            title: 'Speed',
            color: MyColor.navigate,
            icon: MyIcon.speed,
            context: context,
            nextWidget: ({encrateia.Interval interval}) =>
                const Text('') // IntervalSpeedWidget(interval: interval),
            ),
      if (interval.speedAvailable && interval.powerAvailable)
        navigationButton(
            title: 'Ecor',
            color: MyColor.navigate,
            icon: MyIcon.power,
            context: context,
            nextWidget: ({encrateia.Interval interval}) => const Text(
                '') // IntervalEcorWidget(            interval: interval,            athlete: athlete,          ),
            ),
      if (interval.groundTimeAvailable)
        navigationButton(
            title: 'Ground Time',
            color: MyColor.navigate,
            icon: MyIcon.groundTime,
            context: context,
            nextWidget: ({encrateia.Interval interval}) =>
                IntervalGroundTimeWidget(interval: interval),
            ),
      if (interval.groundTimeAvailable)
        navigationButton(
            title: 'Leg Spring Stiffness',
            color: MyColor.navigate,
            icon: MyIcon.legSpringStiffness,
            context: context,
            nextWidget: ({encrateia.Interval interval}) => const Text(
                '') // IntervalLegSpringStiffnessWidget(interval: interval),
            ),
      if (interval.formPowerAvailable)
        navigationButton(
            title: 'Form Power',
            color: MyColor.navigate,
            icon: MyIcon.formPower,
            context: context,
            nextWidget: ({encrateia.Interval interval}) =>
                const Text('') // IntervalFormPowerWidget(interval: interval),
            ),
      if (interval.cadenceAvailable)
        navigationButton(
            title: 'Cadence',
            color: MyColor.navigate,
            icon: MyIcon.cadence,
            context: context,
            nextWidget: ({encrateia.Interval interval}) => const Text(
                '') // IntervalStrydCadenceWidget(interval: interval),
            ),
      if (interval.verticalOscillationAvailable)
        navigationButton(
            title: 'Vertical Oscillation',
            color: MyColor.navigate,
            icon: MyIcon.verticalOscillation,
            context: context,
            nextWidget: ({encrateia.Interval interval}) => const Text(
                '') // IntervalVerticalOscillationWidget(interval: interval),
            ),
      navigationButton(
          title: 'Altitude',
          color: MyColor.navigate,
          icon: MyIcon.altitude,
          context: context,
          nextWidget: ({encrateia.Interval interval}) =>
              const Text('') // IntervalAltitudeWidget(interval: interval),
          ),
      navigationButton(
          title: 'Tags',
          color: MyColor.tag,
          icon: MyIcon.tag,
          context: context,
          nextWidget: ({encrateia.Interval interval}) => const Text(
              '') // IntervalTagWidget(          interval: interval,          athlete: athlete,        ),
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.interval,
        title: Text(
          'Interval ${interval.index}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: StaggeredGridView.count(
          staggeredTiles: List<StaggeredTile>.filled(
            tiles(context: context).length,
            const StaggeredTile.fit(1),
          ),
          crossAxisSpacing: 10,
          padding: const EdgeInsets.all(10),
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 2
                  : 4,
          children: tiles(context: context),
        ),
      ),
    );
  }

  Widget navigationButton({
    @required BuildContext context,
    @required Widget Function({encrateia.Interval interval}) nextWidget,
    @required Widget icon,
    @required String title,
    @required Color color,
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
