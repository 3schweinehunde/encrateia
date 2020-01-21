import 'package:encrateia/widgets/activity_metadata_widget.dart';
import 'package:encrateia/widgets/activity_overview_widget.dart';
import 'package:encrateia/widgets/laps_list_widget.dart';
import 'package:encrateia/widgets/activity_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_power_widget.dart';
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
                  Tab(icon: Icon(Icons.timer)),
                  Text(" Laps"),
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
            '${activity.db.name}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: TabBarView(children: [
          ActivityOverviewWidget(activity: activity),
          ActivityHeartRateWidget(activity: activity),
          ActivityPowerWidget(activity: activity),
          LapsListWidget(activity: activity),
          ActivityMetadataWidget(activity: activity),
        ]),
      ),
    );
  }
}
