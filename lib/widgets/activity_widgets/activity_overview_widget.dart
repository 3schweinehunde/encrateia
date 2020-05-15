import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityOverviewWidget extends StatefulWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityOverviewWidget({
    @required this.activity,
    @required this.athlete,
  });

  @override
  _ActivityOverviewWidgetState createState() => _ActivityOverviewWidgetState();
}

class _ActivityOverviewWidgetState extends State<ActivityOverviewWidget> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    return ListTileTheme(
      iconColor: Colors.deepOrange,
      child: GridView.count(
        padding: EdgeInsets.all(5),
        crossAxisCount: MediaQuery.of(context).orientation  == Orientation.portrait ? 2 : 4,
        childAspectRatio: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        children: [
          ListTile(
            leading: MyIcon.time,
            title: Text(Duration(seconds: widget.activity.db.movingTime ?? 0)
                .asString()),
            subtitle: Text('moving time'),
          ),
          ListTile(
            leading: MyIcon.speed,
            title: Text(widget.activity.db.avgSpeed.toPace() +
                " / " +
                widget.activity.db.maxSpeed.toPace()),
            subtitle: Text('avg / max pace'),
          ),
          ListTile(
            leading: MyIcon.power,
            title: Text((widget.activity.weight != null)
                ? widget.activity
                        .get(activityAttr: ActivityAttr.ecor)
                        .toStringAsFixed(2) +
                    " W s/kg m"
                : "not available"),
            subtitle: Text('ecor'),
          ),
          ListTile(
            leading: MyIcon.heartRate,
            title: Text(
                "${widget.activity.db.avgHeartRate} bpm / ${widget.activity.db.maxHeartRate} bpm"),
            subtitle: Text('avg / max heart rate'),
          ),
          ListTile(
            leading: MyIcon.power,
            title: Text("${widget.activity.db.avgPower.toStringAsFixed(1)} W"),
            subtitle: Text('avg power'),
          ),
          ListTile(
            leading: MyIcon.power,
            title: Text(
                "${(widget.activity.db.avgPower / widget.activity.db.avgHeartRate).toStringAsFixed(2)} W/bpm"),
            subtitle: Text('power / heart rate'),
          ),
          ListTile(
            leading: MyIcon.distance,
            title: Text(
                '${(widget.activity.db.distance / 1000).toStringAsFixed(2)} km'),
            subtitle: Text('distance'),
          ),
          ListTile(
            leading: MyIcon.calories,
            title: Text('${widget.activity.db.totalCalories} kcal'),
            subtitle: Text('total calories'),
          ),
          ListTile(
            leading: MyIcon.timeStamp,
            title: Text(DateFormat("dd MMM yyyy, h:mm:ss")
                .format(widget.activity.db.timeCreated)),
            subtitle: Text('time created'),
          ),
          ListTile(
            leading: MyIcon.climb,
            title: Text(
                "${widget.activity.db.totalAscent} m - ${widget.activity.db.totalDescent} m"
                " = ${widget.activity.db.totalAscent - widget.activity.db.totalDescent} m"),
            subtitle: Text('total ascent - descent = total climb'),
          ),
          ListTile(
            leading: MyIcon.cadence,
            title: Text(
                "${(widget.activity.db.avgRunningCadence ?? 0 * 2).round()} spm / "
                "${widget.activity.db.maxRunningCadence ?? 0 * 2} spm"),
            subtitle: Text('avg / max steps per minute'),
          ),
          ListTile(
            leading: MyIcon.trainingEffect,
            title: Text(widget.activity.db.totalTrainingEffect.toString()),
            subtitle: Text('total training effect'),
          ),
        ],
      ),
    );
  }

  getData() async {
    var weight = await Weight.getBy(
      athletesId: widget.athlete.db.id,
      date: widget.activity.db.timeCreated,
    );
    setState(() {
      widget.activity.weight = weight.db.value;
    });
  }
}
