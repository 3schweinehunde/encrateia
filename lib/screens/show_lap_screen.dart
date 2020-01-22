import 'package:encrateia/widgets/lap_metadata_widget.dart';
import 'package:encrateia/widgets/lap_overview_widget.dart';
import 'package:encrateia/widgets/lap_heart_rate_widget.dart';
import 'package:encrateia/widgets/lap_power_widget.dart';
import 'package:encrateia/widgets/lap_power_duration_widget.dart';
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
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Tab(icon: Icon(Icons.directions_run)),
                  Text(" Overview"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Tab(icon: Icon(Icons.spa)),
                  Text(" Heart Rate"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Tab(icon: Icon(Icons.ev_station)),
                  Text(" Power"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Tab(icon: Icon(Icons.multiline_chart)),
                  Text(" Power Duration"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Tab(icon: Icon(Icons.storage)),
                  Text(" Metadata"),
                ],
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
          LapMetadataWidget(lap: lap),
        ]),
      ),
    );
  }
}
