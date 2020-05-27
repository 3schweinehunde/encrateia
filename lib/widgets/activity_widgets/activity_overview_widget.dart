import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/activity.dart';

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
    return StaggeredGridView.count(
      staggeredTiles: List.filled(12, StaggeredTile.fit(1)),
      mainAxisSpacing: 4,
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: [
        ListTile(
          title: Text(
              '${(widget.activity.db.distance / 1000).toStringAsFixed(2)} km'),
          subtitle: Text('distance'),
        ),
        ListTile(
          title: Text(
              Duration(seconds: widget.activity.db.movingTime ?? 0).asString()),
          subtitle: Text('moving time'),
        ),
        ListTile(
          title: Text(widget.activity.db.avgSpeed.toPace() +
              " / " +
              widget.activity.db.maxSpeed.toPace()),
          subtitle: Text('avg / max pace'),
        ),
        ListTile(
          title: Text((widget.activity.weight != null)
              ? widget.activity
                      .getAttribute(ActivityAttr.ecor)
                      .toStringAsFixed(2) +
                  " W s/kg m"
              : "not available"),
          subtitle: Text('ecor'),
        ),
        ListTile(
          title: Text(
              "${widget.activity.db.avgHeartRate} / ${widget.activity.db.maxHeartRate} bpm"),
          subtitle: Text('avg / max heart rate'),
        ),
        ListTile(
          title: Text("${widget.activity.db.avgPower.toStringAsFixed(1)} W"),
          subtitle: Text('avg power'),
        ),
        ListTile(
          title: Text(
              "${(widget.activity.db.avgPower / widget.activity.db.avgHeartRate).toStringAsFixed(2)} W/bpm"),
          subtitle: Text('power / heart rate'),
        ),
        ListTile(
          title: Text('${widget.activity.db.totalCalories} kcal'),
          subtitle: Text('total calories'),
        ),
        ListTile(
          title: Text(DateFormat("dd MMM yyyy, h:mm:ss")
              .format(widget.activity.db.timeCreated)),
          subtitle: Text('time created'),
        ),
        ListTile(
          title: Text(
              "${widget.activity.db.totalAscent} - ${widget.activity.db.totalDescent}"
              " = ${widget.activity.db.totalAscent - widget.activity.db.totalDescent} m"),
          subtitle: Text('total ascent - descent = total climb'),
        ),
        ListTile(
          title: Text(
              "${(widget.activity.db.avgRunningCadence ?? 0 * 2).round()} / "
              "${widget.activity.db.maxRunningCadence ?? 0 * 2} spm"),
          subtitle: Text('avg / max steps per minute'),
        ),
        ListTile(
          title: Text(widget.activity.db.totalTrainingEffect.toString()),
          subtitle: Text('total training effect'),
        ),
      ],
    );
  }

  getData() async {
    var weight = await Weight.getBy(
      athletesId: widget.athlete.db.id,
      date: widget.activity.db.timeCreated,
    );
    setState(() {
      widget.activity.weight = weight?.db?.value;
    });
  }
}
