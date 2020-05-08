import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/activity_widgets/activity_metadata_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_overview_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_ratio_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_speed_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/laps_list_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_heart_rate_widget.dart';
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
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter/widgets.dart';

class ShowActivityScreen extends StatelessWidget {
  final Activity activity;
  final Athlete athlete;

  const ShowActivityScreen({
    Key key,
    @required this.activity,
    @required this.athlete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.activity,
        title: Text(
          '${activity.db.name}',
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
              color: MyColor.settings,
              title: "Overview",
              icon: MyIcon.overView,
              context: context,
              nextWidget: ActivityOverviewWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: 'Laps List',
              color: MyColor.lap,
              backgroundColor: MyColor.lap,
              icon: MyIcon.laps,
              context: context,
              nextWidget: LapsListWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Heart Rate",
              color: MyColor.navigate,
              icon: MyIcon.heartRate,
              context: context,
              nextWidget: ActivityHeartRateWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Power",
              color: MyColor.navigate,
              icon: MyIcon.power,
              context: context,
              nextWidget: ActivityPowerWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Power\nDuration",
              color: MyColor.navigate,
              icon: MyIcon.powerDuration,
              context: context,
              nextWidget: ActivityPowerDurationWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Power /\nHeart Rate",
              color: MyColor.navigate,
              icon: MyIcon.power,
              context: context,
              nextWidget: ActivityPowerPerHeartRateWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Ecor",
              color: MyColor.navigate,
              icon: MyIcon.power,
              context: context,
              nextWidget: ActivityEcorWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Speed /\nHeart Rate",
              color: MyColor.navigate,
              icon: MyIcon.speed,
              context: context,
              nextWidget: ActivitySpeedPerHeartRateWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Ground Time",
              color: MyColor.navigate,
              icon: MyIcon.groundTime,
              context: context,
              nextWidget: ActivityGroundTimeWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Form Power",
              color: MyColor.navigate,
              icon: MyIcon.formPower,
              context: context,
              nextWidget: ActivityFormPowerWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Power Ratio",
              color: MyColor.navigate,
              icon: MyIcon.formPower,
              context: context,
              nextWidget: ActivityPowerRatioWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Vertical\nOscillation",
              color: MyColor.navigate,
              icon: MyIcon.verticalOscillation,
              context: context,
              nextWidget: ActivityVerticalOscillationWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Stride Ratio",
              color: MyColor.navigate,
              icon: MyIcon.strideRatio,
              context: context,
              nextWidget: ActivityStrideRatioWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Cadence",
              color: MyColor.navigate,
              icon: MyIcon.cadence,
              context: context,
              nextWidget: ActivityStrydCadenceWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Leg Spring\nStiffness",
              color: MyColor.navigate,
              icon: MyIcon.legSpringStiffness,
              context: context,
              nextWidget: ActivityLegSpringStiffnessWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
            navigationButton(
              title: "Metadata",
              color: MyColor.settings,
              icon: MyIcon.metaData,
              context: context,
              nextWidget: ActivityMetadataWidget(
                activity: activity,
                athlete: athlete,
              ),
            ),
          ],
        );
      }),
    );
  }

  navigationButton({
    @required BuildContext context,
    @required Widget nextWidget,
    @required Widget icon,
    @required String title,
    @required Color color,
    Color backgroundColor,
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
          builder: (context) => ShowActivityDetailScreen(
            activity: activity,
            widget: nextWidget,
            title: title,
            backgroundColor: backgroundColor,
          ),
        ),
      ),
    );
  }
}
