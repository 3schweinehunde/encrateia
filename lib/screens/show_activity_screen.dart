import 'package:encrateia/widgets/activity_widgets/activity_metadata_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_overview_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_ratio_widget.dart';
import 'package:encrateia/widgets/activity_widgets/speed_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/laps_list_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_duration_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_ground_time_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_leg_spring_stiffness_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_form_power_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_stryd_cadence_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_vertical_oscillation_widget.dart';
import 'package:encrateia/screens/show_activity_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter/widgets.dart';

class ShowActivityScreen extends StatelessWidget {
  final Activity activity;

  const ShowActivityScreen({
    Key key,
    this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${activity.db.name}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Table(
        children: [
          TableRow(
            children: [
              detailTile(
                title: "Overview",
                icon: MyIcon.overView,
                context: context,
                nextWidget: ActivityOverviewWidget(activity: activity),
              ),
              detailTile(
                title: 'Laps',
                icon: MyIcon.laps,
                context: context,
                nextWidget: LapsListWidget(activity: activity),
              ),
            ],
          ),
          TableRow(children: [
            detailTile(
              title: "Heart Rate",
              icon: MyIcon.heartRate,
              context: context,
              nextWidget: ActivityHeartRateWidget(activity: activity),
            ),
            detailTile(
              title: "Power",
              icon: MyIcon.power,
              context: context,
              nextWidget: ActivityPowerWidget(activity: activity),
            ),
          ]),
          TableRow(children: [
            detailTile(
              title: "Power Duration",
              icon: MyIcon.powerDuration,
              context: context,
              nextWidget: ActivityPowerDurationWidget(activity: activity),
            ),
            detailTile(
              title: "Power / Heart Rate",
              icon: MyIcon.power,
              context: context,
              nextWidget: ActivityPowerPerHeartRateWidget(activity: activity),
            ),
          ]),
          TableRow(children: [
            detailTile(
              title: "Speed / Heart Rate",
              icon: MyIcon.speed,
              context: context,
              nextWidget: ActivitySpeedPerHeartRateWidget(activity: activity),
            ),
            detailTile(
              title: "Ground Time",
              icon: MyIcon.groundTime,
              context: context,
              nextWidget: ActivityGroundTimeWidget(activity: activity),
            ),
          ]),
          TableRow(children: [
            detailTile(
              title: "Form Power",
              icon: MyIcon.formPower,
              context: context,
              nextWidget: ActivityFormPowerWidget(activity: activity),
            ),
            detailTile(
              title: "Power Ratio",
              icon: MyIcon.formPower,
              context: context,
              nextWidget: ActivityPowerRatioWidget(activity: activity),
            ),
          ]),
          TableRow(children: [
            detailTile(
              title: "Cadence",
              icon: MyIcon.cadence,
              context: context,
              nextWidget: ActivityStrydCadenceWidget(activity: activity),
            ),
            detailTile(
              title: "Vertical Oscillation",
              icon: MyIcon.verticalOscillation,
              context: context,
              nextWidget: ActivityVerticalOscillationWidget(activity: activity),
            ),
          ]),
          TableRow(children: [
            detailTile(
              title: "Leg Spring Stiffness",
              icon: MyIcon.legSpringStiffness,
              context: context,
              nextWidget: ActivityLegSpringStiffnessWidget(activity: activity),
            ),
            detailTile(
              title: "Metadata",
              icon: MyIcon.metaData,
              context: context,
              nextWidget: ActivityMetadataWidget(activity: activity),
            ),
          ]),
        ],
      ),
    );
  }

  detailTile({
    BuildContext context,
    Widget nextWidget,
    Widget icon,
    String title,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: ListTile(
        leading: icon,
        title: Text(title),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowActivityDetailScreen(
              activity: activity,
              widget: nextWidget,
              title: title,
            ),
          ),
        ),
      ),
    );
  }
}
