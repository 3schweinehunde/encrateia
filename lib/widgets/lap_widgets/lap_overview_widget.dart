import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:encrateia/models/lap.dart';

class LapOverviewWidget extends StatefulWidget {
  const LapOverviewWidget({
    this.lap,
    this.athlete,
  });

  final Lap lap;
  final Athlete athlete;

  @override
  _LapOverviewWidgetState createState() => _LapOverviewWidgetState();
}

class _LapOverviewWidgetState extends State<LapOverviewWidget> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<Widget> get tiles {
    return <Widget>[
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.lap.avgSpeed, pq: PQ.pace),
          const Text(' / '),
          PQText(value: widget.lap.maxSpeed, pq: PQ.pace),
        ]),
        subtitle: const Text('avg / max pace'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.lap.avgHeartRate, pq: PQ.heartRate),
          const Text(' / '),
          PQText(value: widget.lap.maxHeartRate, pq: PQ.heartRate),
        ]),
        subtitle: const Text('avg / max heart rate'),
      ),
      ListTile(
        title: PQText(value: widget.lap.avgPower, pq: PQ.power),
        subtitle: const Text('avg power'),
      ),
      ListTile(
        title: PQText(
            value: widget.lap.avgPowerPerHeartRate, pq: PQ.powerPerHeartRate),
        subtitle: const Text('power / heart rate'),
      ),
      ListTile(
        title: PQText(value: widget.lap.startTime, pq: PQ.dateTime),
        subtitle: const Text('start time'),
      ),
      ListTile(
        title: PQText(value: widget.lap.totalDistance, pq: PQ.distance),
        subtitle: const Text('distance'),
      ),
      ListTile(
        title: PQText(value: widget.lap.totalCalories, pq: PQ.calories),
        subtitle: const Text('total calories'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.lap.totalAscent, pq: PQ.integer),
          const Text(' - '),
          PQText(value: widget.lap.totalDescent, pq: PQ.integer),
          const Text(' = '),
          PQText(value: widget.lap.elevationDifference, pq: PQ.elevation),
        ]),
        subtitle: const Text('total ascent - descent = total climb'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.lap.avgRunningCadence, pq: PQ.cadence),
          const Text(' / '),
          PQText(value: widget.lap.maxRunningCadence.toDouble(), pq: PQ.cadence),
        ]),
        subtitle: const Text('avg / max steps per minute'),
      ),
      ListTile(
        title: PQText(value: widget.lap.totalStrides, pq: PQ.integer),
        subtitle: const Text('total strides'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      staggeredTiles:
          List<StaggeredTile>.filled(tiles.length, const StaggeredTile.fit(1)),
      mainAxisSpacing: 4,
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: tiles,
    );
  }

  Future<void> getData() async {
    final Weight weight = await Weight.getBy(
      athletesId: widget.athlete.id,
      date: widget.lap.timeStamp,
    );
    setState(() {
      widget.lap.weight = weight?.value;
    });
  }
}
