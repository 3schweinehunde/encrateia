import 'package:encrateia/widgets/activity_metadata_widget.dart';
import 'package:encrateia/widgets/activity_overview_widget.dart';
import 'package:encrateia/widgets/laps_list_widget.dart';
import 'package:encrateia/widgets/activity_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_power_widget.dart';
import 'package:encrateia/widgets/activity_power_duration_widget.dart';
import 'package:encrateia/widgets/activity_ground_time_widget.dart';
import 'package:encrateia/widgets/activity_leg_spring_stiffness_widget.dart';
import 'package:encrateia/widgets/activity_form_power_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';

class ShowActivityScreen extends StatelessWidget {
  final Activity activity;

  const ShowActivityScreen({
    Key key,
    this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(Icons.directions_run),
                text: "Overview",
              ),
              Tab(
                icon: Icon(Icons.timer),
                text: "Laps",
              ),
              Tab(
                icon: Icon(Icons.spa),
                text: "HR",
              ),
              Tab(
                icon: Icon(Icons.ev_station),
                text: "Power",
              ),
              Tab(
                icon: Icon(Icons.multiline_chart),
                text: "Pow Dur",
              ),
              Tab(
                icon: Icon(Icons.vertical_align_bottom),
                text: "Grnd.Time",
              ),
              Tab(
                icon: Icon(Icons.airline_seat_recline_extra),
                text: "Leg Spr.Stiff.",
              ),
              Tab(
                icon: Icon(Icons.accessibility_new),
                text: "Form Power",
              ),
              Tab(
                icon: Icon(Icons.storage),
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
          ActivityGroundTimeWidget(activity: activity),
          ActivityLegSpringStiffnessWidget(activity: activity),
          ActivityFormPowerWidget(activity: activity),
          ActivityMetadataWidget(activity: activity),
        ]),
      ),
    );
  }
}
