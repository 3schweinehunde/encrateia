import 'package:flutter/material.dart';

import '/models/athlete.dart';
import '/models/lap.dart';
import '/screens/show_lap_detail_screen.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button_style.dart';
import '/utils/my_color.dart';
import '/widgets/lap_widgets/lap_altitude_widget.dart';
import '/widgets/lap_widgets/lap_ecor_widget.dart';
import '/widgets/lap_widgets/lap_form_power_widget.dart';
import '/widgets/lap_widgets/lap_ground_time_widget.dart';
import '/widgets/lap_widgets/lap_heart_rate_widget.dart';
import '/widgets/lap_widgets/lap_leg_spring_stiffness_widget.dart';
import '/widgets/lap_widgets/lap_metadata_widget.dart';
import '/widgets/lap_widgets/lap_overview_widget.dart';
import '/widgets/lap_widgets/lap_pace_widget.dart';
import '/widgets/lap_widgets/lap_power_duration_widget.dart';
import '/widgets/lap_widgets/lap_power_widget.dart';
import '/widgets/lap_widgets/lap_speed_widget.dart';
import '/widgets/lap_widgets/lap_stryd_cadence_widget.dart';
import '/widgets/lap_widgets/lap_tag_widget.dart';
import '/widgets/lap_widgets/lap_vertical_oscillation_widget.dart';

class ShowLapScreen extends StatelessWidget {
  const ShowLapScreen({
    Key? key,
    required this.lap,
    required this.laps,
    required this.athlete,
  }) : super(key: key);

  final Lap lap;
  final List<Lap> laps;
  final Athlete? athlete;

  List<Widget> tiles({required BuildContext context}) {
    return <Widget>[
      navigationButton(
        title: 'Overview',
        color: MyColor.settings,
        icon: MyIcon.metaData,
        context: context,
        nextWidget: ({Lap? lap}) =>
            LapOverviewWidget(lap: lap, athlete: athlete),
      ),
      if (lap.heartRateAvailable)
        navigationButton(
          title: 'Heart Rate',
          color: MyColor.navigate,
          icon: MyIcon.heartRate,
          context: context,
          nextWidget: ({Lap? lap}) => LapHeartRateWidget(lap: lap),
        ),
      if (lap.powerAvailable)
        navigationButton(
          title: 'Power',
          color: MyColor.navigate,
          icon: MyIcon.power,
          context: context,
          nextWidget: ({Lap? lap}) => LapPowerWidget(lap: lap),
        ),
      if (lap.powerAvailable)
        navigationButton(
          title: 'Power Duration',
          color: MyColor.navigate,
          icon: MyIcon.powerDuration,
          context: context,
          nextWidget: ({Lap? lap}) => LapPowerDurationWidget(lap: lap),
        ),
      if (lap.paceAvailable)
        navigationButton(
          title: 'Pace',
          color: MyColor.navigate,
          icon: MyIcon.speed,
          context: context,
          nextWidget: ({Lap? lap}) => LapPaceWidget(lap: lap),
        ),
      if (lap.speedAvailable)
        navigationButton(
          title: 'Speed',
          color: MyColor.navigate,
          icon: MyIcon.speed,
          context: context,
          nextWidget: ({Lap? lap}) => LapSpeedWidget(lap: lap),
        ),
      if (lap.speedAvailable && lap.powerAvailable)
        navigationButton(
          title: 'Ecor',
          color: MyColor.navigate,
          icon: MyIcon.power,
          context: context,
          nextWidget: ({Lap? lap}) => LapEcorWidget(
            lap: lap,
            athlete: athlete,
          ),
        ),
      if (lap.groundTimeAvailable)
        navigationButton(
          title: 'Ground Time',
          color: MyColor.navigate,
          icon: MyIcon.groundTime,
          context: context,
          nextWidget: ({Lap? lap}) => LapGroundTimeWidget(lap: lap),
        ),
      if (lap.groundTimeAvailable)
        navigationButton(
          title: 'Leg Spring Stiffness',
          color: MyColor.navigate,
          icon: MyIcon.legSpringStiffness,
          context: context,
          nextWidget: ({Lap? lap}) => LapLegSpringStiffnessWidget(lap: lap),
        ),
      if (lap.formPowerAvailable)
        navigationButton(
          title: 'Form Power',
          color: MyColor.navigate,
          icon: MyIcon.formPower,
          context: context,
          nextWidget: ({Lap? lap}) => LapFormPowerWidget(lap: lap),
        ),
      if (lap.cadenceAvailable)
        navigationButton(
          title: 'Cadence',
          color: MyColor.navigate,
          icon: MyIcon.cadence,
          context: context,
          nextWidget: ({Lap? lap}) => LapStrydCadenceWidget(lap: lap),
        ),
      if (lap.verticalOscillationAvailable)
        navigationButton(
          title: 'Vertical Oscillation',
          color: MyColor.navigate,
          icon: MyIcon.verticalOscillation,
          context: context,
          nextWidget: ({Lap? lap}) => LapVerticalOscillationWidget(lap: lap),
        ),
      navigationButton(
        title: 'Altitude',
        color: MyColor.navigate,
        icon: MyIcon.altitude,
        context: context,
        nextWidget: ({Lap? lap}) => LapAltitudeWidget(lap: lap),
      ),
      navigationButton(
        title: 'Metadata',
        color: MyColor.settings,
        icon: MyIcon.metaData,
        context: context,
        nextWidget: ({Lap? lap}) => LapMetadataWidget(lap: lap),
      ),
      navigationButton(
        title: 'Tags',
        color: MyColor.tag,
        icon: MyIcon.tag,
        context: context,
        nextWidget: ({Lap? lap}) => LapTagWidget(
          lap: lap,
          athlete: athlete,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.lap,
        title: Text(
          'Lap ${lap.index}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: GridView.count(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
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
    required BuildContext context,
    required Widget Function({Lap? lap}) nextWidget,
    required Widget icon,
    required String title,
    required Color color,
  }) {
    return ElevatedButton.icon(
      style: MyButtonStyle.raisedButtonStyle(
          color: color ?? MyColor.primary,
          textColor: MyColor.textColor(backgroundColor: color)),
      icon: icon,
      label: Expanded(
        child: Text(title),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<BuildContext>(
          builder: (BuildContext context) => ShowLapDetailScreen(
            lap: lap,
            laps: laps,
            nextWidget: nextWidget,
            title: title,
          ),
        ),
      ),
    );
  }
}
