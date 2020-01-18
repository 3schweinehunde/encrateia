import 'package:encrateia/widgets/activity_metadata_widget.dart';
import 'package:encrateia/widgets/laps_list_widget.dart';
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
                  Tab(icon: Icon(Icons.timer)),
                  Text(" Laps"),
                ],
              )
            ],
          ),
          title: Text(
            '${activity.db.name}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: TabBarView(children: [
          ActivityMetadataWidget(activity: activity),
          LapsListWidget(activity: activity),
        ]),
      ),
    );
  }
}
