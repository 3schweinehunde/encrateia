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
                icon: MyIcon.overView,
                text: "Overview",
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
                text: "Power Duration",
              ),
              Tab(
                icon: MyIcon.groundTime,
                text: "Ground Time",
              ),
              Tab(
                icon: MyIcon.legSpringStiffness,
                text: "Leg spr.stiff.",
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
