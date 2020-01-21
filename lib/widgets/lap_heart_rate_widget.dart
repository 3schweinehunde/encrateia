import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';

class LapHeartRateWidget extends StatelessWidget {
  final Lap lap;

  LapHeartRateWidget({this.lap});

  @override
  Widget build(context) {
    return FutureBuilder<List<Event>>(
      future: Event.recordsByLap(lap: lap),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          var records = snapshot.data;
          return ListTileTheme(
            iconColor: Colors.lightGreen,
            child: ListView(
              padding: EdgeInsets.only(left: 25),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.playlist_add),
                  title: Text(records.length.toString()),
                  subtitle: Text("number of measurements"),
                ),
                ListTile(
                  leading: Icon(Icons.pets),
                  title: Text(Lap.averageHeartRate(records: records)),
                  subtitle: Text("average heart rate"),
                ),
                ListTile(
                  leading: Icon(Icons.expand_more),
                  title: Text(Lap.minHeartRate(records: records)),
                  subtitle: Text("minimum heart rate"),
                ),
                ListTile(
                  leading: Icon(Icons.expand_less),
                  title: Text(Lap.maxHeartRate(records: records)),
                  subtitle: Text("maximum heart rate"),
                ),
                ListTile(
                  leading: Icon(Icons.unfold_more),
                  title: Text(Lap.sdevHeartRate(records: records)),
                  subtitle: Text("standard deviation heart rate"),

                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text("Loading"),
          );
        }
      },
    );
  }
}
