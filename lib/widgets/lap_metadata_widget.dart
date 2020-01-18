import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/lap.dart';

class LapMetadataWidget extends StatelessWidget {
  final Lap lap;

  LapMetadataWidget({this.lap});

  @override
  Widget build(context) {
    return new ListTileTheme(
      dense: true,
      iconColor: Colors.lightGreen,
      child: ListView(
        padding: EdgeInsets.only(left: 8, right: 8),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.repeat_one),
            title: Text('Lap ${lap.index}'),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(lap.db.event),
            trailing: Text("event"),
          ),
          ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text(lap.db.sport + '/' + lap.db.subSport),
            trailing: Text('sport / sub sport'),
          ),
        ],
      ),
    );
  }
}
