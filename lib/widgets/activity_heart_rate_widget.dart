import 'package:encrateia/widgets/activity_heart_rate_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'activity_heart_rate_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityHeartRateWidget extends StatelessWidget {
  final Activity activity;

  ActivityHeartRateWidget({this.activity});

  @override
  Widget build(context) {
    return FutureBuilder<List<Event>>(
      future: activity.records,
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          var heartRates =
              snapshot.data.map((value) => value.db.heartRate).nonZeroInts();
          if (heartRates.length > 0) {
            var records = snapshot.data;
            return ListTileTheme(
              iconColor: Colors.deepOrange,
              child: ListView(
                padding: EdgeInsets.only(left: 25),
                children: <Widget>[
                  ActivityHeartRateChart(records: records, activity: activity),
                  ListTile(
                    leading: MyIcon.average,
                    title: Text(activity.db.avgHeartRate.toString()),
                    subtitle: Text("average heart rate"),
                  ),
                  ListTile(
                    leading: MyIcon.minimum,
                    title: Text(Lap.minHeartRate(records: records)),
                    subtitle: Text("minimum heart rate"),
                  ),
                  ListTile(
                    leading: MyIcon.maximum,
                    title: Text(activity.db.maxHeartRate.toString()),
                    subtitle: Text("maximum heart rate"),
                  ),
                  ListTile(
                    leading: MyIcon.standardDeviation,
                    title: Text(Lap.sdevHeartRate(records: records)),
                    subtitle: Text("standard deviation heart rate"),
                  ),
                  ListTile(
                    leading: MyIcon.amount,
                    title: Text(records.length.toString()),
                    subtitle: Text("number of measurements"),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text("No heart rate data available."),
            );
          }
        } else {
          return Center(
            child: Text("Loading"),
          );
        }
      },
    );
  }
}
