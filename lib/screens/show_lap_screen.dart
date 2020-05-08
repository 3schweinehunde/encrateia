import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/screens/show_lap_detail_screen.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/lap_widgets/lap_ecor_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_metadata_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_overview_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_heart_rate_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_power_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_power_duration_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_ground_time_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_leg_spring_stiffness_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_form_power_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_stryd_cadence_widget.dart';
import 'package:encrateia/widgets/lap_widgets/lap_vertical_oscillation_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ShowLapScreen extends StatelessWidget {
  final Lap lap;
  final List<Lap> laps;
  final Athlete athlete;

  const ShowLapScreen({
    Key key,
    @required this.lap,
    @required this.laps,
    @required this.athlete,
  }) : super(key: key);

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
      body: new OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
          padding: EdgeInsets.all(5),
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          childAspectRatio: 3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          children: [
            navigationButton(
              title: "Overview",
              color: MyColor.settings,
              icon: MyIcon.metaData,
              context: context,
              nextWidget: ({lap}) => LapOverviewWidget(lap: lap),
            ),
            navigationButton(
              title: "Heart Rate",
              color: MyColor.navigate,
              icon: MyIcon.heartRate,
              context: context,
              nextWidget: ({lap}) => LapHeartRateWidget(lap: lap),
            ),
            navigationButton(
              title: "Power",
              color: MyColor.navigate,
              icon: MyIcon.power,
              context: context,
              nextWidget: ({lap}) => LapPowerWidget(lap: lap),
            ),
            navigationButton(
              title: "Power\nDuration",
              color: MyColor.navigate,
              icon: MyIcon.powerDuration,
              context: context,
              nextWidget: ({lap}) => LapPowerDurationWidget(lap: lap),
            ),
            navigationButton(
              title: "Ecor",
              color: MyColor.navigate,
              icon: MyIcon.power,
              context: context,
              nextWidget: ({lap}) => LapEcorWidget(
                lap: lap,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Ground Time",
              color: MyColor.navigate,
              icon: MyIcon.groundTime,
              context: context,
              nextWidget: ({lap}) => LapGroundTimeWidget(lap: lap),
            ),
            navigationButton(
              title: "Leg Spring\nStiffness",
              color: MyColor.navigate,
              icon: MyIcon.legSpringStiffness,
              context: context,
              nextWidget: ({lap}) => LapLegSpringStiffnessWidget(lap: lap),
            ),
            navigationButton(
              title: "Form Power",
              color: MyColor.navigate,
              icon: MyIcon.formPower,
              context: context,
              nextWidget: ({lap}) => LapFormPowerWidget(lap: lap),
            ),
            navigationButton(
              title: "Cadence",
              color: MyColor.navigate,
              icon: MyIcon.cadence,
              context: context,
              nextWidget: ({lap}) => LapStrydCadenceWidget(lap: lap),
            ),
            navigationButton(
              title: "Vertical\nOscillation",
              color: MyColor.navigate,
              icon: MyIcon.verticalOscillation,
              context: context,
              nextWidget: ({lap}) => LapVerticalOscillationWidget(lap: lap),
            ),
            navigationButton(
              title: "Metadata",
              color: MyColor.settings,
              icon: MyIcon.metaData,
              context: context,
              nextWidget: ({lap}) => LapMetadataWidget(lap: lap),
            ),
          ],
        );
      }),
    );
  }

  navigationButton({
    @required BuildContext context,
    @required Function({Lap lap}) nextWidget,
    @required Widget icon,
    @required String title,
    @required Color color,
    Color textColor,
  }) {
    return RaisedButton.icon(
      color: color ?? MyColor.primary,
      textColor: textColor ?? MyColor.black,
      icon: icon,
      label: Text(title),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowLapDetailScreen(
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
