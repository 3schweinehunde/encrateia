import 'package:encrateia/widgets/lap_metadata_widget.dart';
import 'package:encrateia/widgets/lap_overview_widget.dart';
import 'package:encrateia/widgets/lap_heart_rate_widget.dart';
import 'package:encrateia/widgets/lap_power_widget.dart';
import 'package:encrateia/widgets/lap_power_duration_widget.dart';
import 'package:encrateia/widgets/lap_ground_time_widget.dart';
import 'package:encrateia/widgets/lap_leg_spring_stiffness_widget.dart';
import 'package:encrateia/widgets/lap_form_power_widget.dart';
import 'package:encrateia/widgets/lap_stryd_cadence_widget.dart';
import 'package:encrateia/widgets/lap_vertical_oscillation_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';

class ShowLapScreen extends StatelessWidget {
  final Lap lap;

  const ShowLapScreen({
    Key key,
    this.lap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(Icons.directions_run),
                text: "Overview",
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
                text: "Power Duration",
              ),
              Tab(
                icon: Icon(Icons.vertical_align_bottom),
                text: "Ground Time",
              ),
              Tab(
                icon: Icon(Icons.airline_seat_recline_extra),
                text: "Leg spr.stiff.",
              ),
              Tab(
                icon: Icon(Icons.accessibility_new),
                text: "Form Power",
              ),
              Tab(
                icon: Icon(Icons.pets),
                text: "Cadence",
              ),
              Tab(
                icon: Icon(Icons.unfold_more),
                text: "Vertical Oscillation",
              ),
              Tab(
                icon: Icon(Icons.storage),
                text: "Metadata",
              ),
            ],
          ),
          title: Text(
            'Lap ${lap.index}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: TabBarView(children: [
          LapOverviewWidget(lap: lap),
          LapHeartRateWidget(lap: lap),
          LapPowerWidget(lap: lap),
          LapPowerDurationWidget(lap: lap),
          LapGroundTimeWidget(lap: lap),
          LapLegSpringStiffnessWidget(lap: lap),
          LapFormPowerWidget(lap: lap),
          LapStrydCadenceWidget(lap: lap),
          LapVerticalOscillationWidget(lap: lap),
          LapMetadataWidget(lap: lap),
        ]),
      ),
    );
  }
}
