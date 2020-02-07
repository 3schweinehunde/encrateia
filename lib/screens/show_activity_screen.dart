import 'package:encrateia/widgets/activity_widgets/activity_metadata_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_overview_widget.dart';
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
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ShowActivityScreen extends StatelessWidget {
  final Activity activity;

  const ShowActivityScreen({
    Key key,
    this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 13,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: MyIcon.overView,
                text: "Overview",
              ),
              Tab(
                icon: MyIcon.laps,
                text: "Laps",
              ),
              Tab(
                icon: MyIcon.heartRate,
                text: "HR",
              ),
              Tab(
                icon: MyIcon.power,
                text: "Power",
              ),
              Tab(
                icon: MyIcon.powerDuration,
                text: "Pow Dur",
              ),
              Tab(
                icon: MyIcon.power,
                text: "Power/HR",
              ),
              Tab(
                icon: MyIcon.speed,
                text: "speed/HR",
              ),
              Tab(
                icon: MyIcon.groundTime,
                text: "Grnd.Time",
              ),
              Tab(
                icon: MyIcon.legSpringStiffness,
                text: "Leg Spr.Stiff.",
              ),
              Tab(
                icon: MyIcon.formPower,
                text: "Form Power",
              ),
              Tab(
                icon: MyIcon.cadence,
                text: "Cadence",
              ),
              Tab(
                icon: MyIcon.verticalOscillation,
                text: "Vertical Oscillation",
              ),
              Tab(
                icon: MyIcon.metaData,
                text: "Metadata",
              ),
            ],
          ),
          title: Text(
            '${activity.db.name}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: TabBarView(children: [
          ActivityOverviewWidget(activity: activity),
          LapsListWidget(activity: activity),
          ActivityHeartRateWidget(activity: activity),
          ActivityPowerWidget(activity: activity),
          ActivityPowerDurationWidget(activity: activity),
          ActivityPowerPerHeartRateWidget(activity: activity),
          ActivitySpeedPerHeartRateWidget(activity: activity),
          ActivityGroundTimeWidget(activity: activity),
          ActivityLegSpringStiffnessWidget(activity: activity),
          ActivityFormPowerWidget(activity: activity),
          ActivityStrydCadenceWidget(activity: activity),
          ActivityVerticalOscillationWidget(activity: activity),
          ActivityMetadataWidget(activity: activity),
        ]),
      ),
    );
  }
}
