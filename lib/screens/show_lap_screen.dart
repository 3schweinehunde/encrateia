import 'package:encrateia/widgets/lap_metadata_widget.dart';
import 'package:encrateia/widgets/lap_overview_widget.dart';
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
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
          LapMetadataWidget(lap: lap),
        ]),
      ),
    );
  }
}
