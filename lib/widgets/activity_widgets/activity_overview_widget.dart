import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';

class ActivityOverviewWidget extends StatefulWidget {
  const ActivityOverviewWidget({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  ActivityOverviewWidgetState createState() => ActivityOverviewWidgetState();
}

class ActivityOverviewWidgetState extends State<ActivityOverviewWidget> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<Widget> get tiles {
    return <ListTile>[
      ListTile(
        title: PQText(
          value: widget.activity!.distance,
          pq: PQ.distance,
        ),
        subtitle: const Text('distance'),
      ),
      ListTile(
        title: PQText(value: widget.activity!.movingTime, pq: PQ.duration),
        subtitle: const Text('moving time'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.activity!.avgSpeed, pq: PQ.paceFromSpeed),
          const Text(' / '),
          PQText(value: widget.activity!.maxSpeed, pq: PQ.paceFromSpeed),
        ]),
        subtitle: const Text('avg / max pace'),
      ),
      ListTile(
        title: PQText(value: widget.activity!.cachedEcor, pq: PQ.ecor),
        subtitle: const Text('ecor'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.activity!.avgHeartRate, pq: PQ.heartRate),
          const Text(' / '),
          PQText(value: widget.activity!.maxHeartRate, pq: PQ.heartRate),
        ]),
        subtitle: const Text('avg / max heart rate'),
      ),
      ListTile(
        title: PQText(value: widget.activity!.avgPower, pq: PQ.power),
        subtitle: const Text('avg power'),
      ),
      ListTile(
        title: PQText(
            value: widget.activity!.avgPowerPerHeartRate,
            pq: PQ.powerPerHeartRate),
        subtitle: const Text('power / heart rate'),
      ),
      ListTile(
        title: PQText(value: widget.activity!.totalCalories, pq: PQ.calories),
        subtitle: const Text('total calories'),
      ),
      ListTile(
        title: PQText(
          value: widget.activity!.timeCreated,
          pq: PQ.dateTime,
          format: DateTimeFormat.longDateTime,
        ),
        subtitle: const Text('time created'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.activity!.totalAscent, pq: PQ.integer),
          const Text(' - '),
          PQText(value: widget.activity!.totalDescent, pq: PQ.integer),
          const Text(' = '),
          PQText(value: widget.activity!.elevationDifference, pq: PQ.elevation),
        ]),
        subtitle: const Text('total ascent - descent = total climb'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.activity!.avgRunningCadence, pq: PQ.cadence),
          const Text(' / '),
          PQText(value: widget.activity!.maxRunningCadence, pq: PQ.cadence),
        ]),
        subtitle: const Text('avg / max steps per minute'),
      ),
      ListTile(
        title: PQText(
          value: widget.activity!.totalTrainingEffect,
          pq: PQ.trainingEffect,
        ),
        subtitle: const Text('total training effect'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      maxCrossAxisExtent: 600,
      childAspectRatio: 5,
      children: tiles,
    );
  }

  Future<void> getData() async {
    await widget.activity!.weight;
    await widget.activity!.ecor;
    setState(() {});
  }
}
