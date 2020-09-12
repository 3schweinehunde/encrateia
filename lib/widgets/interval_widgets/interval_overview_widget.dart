import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:encrateia/models/interval.dart' as encrateia;

class IntervalOverviewWidget extends StatefulWidget {
  const IntervalOverviewWidget({
    this.interval,
    this.athlete,
  });

  final encrateia.Interval interval;
  final Athlete athlete;

  @override
  _IntervalOverviewWidgetState createState() => _IntervalOverviewWidgetState();
}

class _IntervalOverviewWidgetState extends State<IntervalOverviewWidget> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<Widget> get tiles {
    return <Widget>[
      ListTile(
        title: PQText(
            value: widget.interval.distance.toInt(), pq: PQ.distance),
        subtitle: const Text('distance'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(
              value: widget.interval.avgSpeedByDistance, pq: PQ.paceFromSpeed),
          const Text(' / '),
          PQText(value: widget.interval.maxSpeed, pq: PQ.paceFromSpeed),
        ]),
        subtitle: const Text('avg / max pace'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.interval.avgHeartRate, pq: PQ.heartRate),
          const Text(' / '),
          PQText(value: widget.interval.maxHeartRate, pq: PQ.heartRate),
        ]),
        subtitle: const Text('avg / max heart rate'),
      ),
      ListTile(
        title: PQText(value: widget.interval.avgPower, pq: PQ.power),
        subtitle: const Text('avg power'),
      ),
      ListTile(
        title: PQText(
            value: widget.interval.avgPowerPerHeartRate,
            pq: PQ.powerPerHeartRate),
        subtitle: const Text('power / heart rate'),
      ),
      ListTile(
        title: PQText(value: widget.interval.movingTime, pq: PQ.duration),
        subtitle: const Text('moving time'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: widget.interval.totalAscent, pq: PQ.integer),
          const Text(' - '),
          PQText(value: widget.interval.totalDescent, pq: PQ.integer),
          const Text(' = '),
          PQText(value: widget.interval.elevationDifference, pq: PQ.elevation),
        ]),
        subtitle: const Text('total ascent - descent = total climb'),
      ),
      ListTile(
        title: PQText(value: widget.interval.timeStamp, pq: PQ.dateTime),
        subtitle: const Text('timestamp'),
      ),
      ListTile(
        title: PQText(
            value: widget.interval.avgVerticalOscillation,
            pq: PQ.verticalOscillation),
        subtitle: const Text('avg vertical oscillation'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: widget.interval.avgSpeedByDistance, pq: PQ.speed),
              PQText(value: widget.interval.maxSpeed, pq: PQ.speed),
            ]),
        subtitle: const Text('avg / max speed'),
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
      date: widget.interval.timeStamp,
    );
    setState(() => widget.interval.weight = weight?.value);
  }
}
