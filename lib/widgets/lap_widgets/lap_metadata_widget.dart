import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LapMetadataWidget extends StatelessWidget {
  const LapMetadataWidget({this.lap});

  final Lap lap;

  List<Widget> get tiles {
    return <Widget>[
      ListTile(
        title: PQText(value: lap.timeStamp, pq: PQ.dateTime),
        subtitle: const Text('timestamp'),
      ),
      ListTile(
        title: PQText(value: lap.event, pq: PQ.text),
        subtitle: const Text('event'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: lap.sport, pq: PQ.text),
          const Text(' / '),
          PQText(value: lap.subSport, pq: PQ.text),
        ]),
        subtitle: const Text('sport / sub sport'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: lap.eventType, pq: PQ.text),
          const Text(' / '),
          PQText(value: lap.eventGroup, pq: PQ.integer),
        ]),
        subtitle: const Text('event type / group'),
      ),
      ListTile(
        title: PQText(
            value: lap.avgVerticalOscillation, pq: PQ.verticalOscillation),
        subtitle: const Text('avg vertical oscillation'),
      ),
      ListTile(
        title: PQText(value: lap.totalElapsedTime, pq: PQ.duration),
        subtitle: const Text('total elapsed time'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: lap.avgStanceTime, pq: PQ.stanceTime),
          const Text(' / '),
          PQText(value: lap.avgStanceTimePercent, pq: PQ.percentage),
        ]),
        subtitle: const Text('avg stance time / avg stance time percent'),
      ),
      ListTile(
        title: PQText(value: lap.lapTrigger, pq: PQ.text),
        subtitle: const Text('lap trigger'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: lap.avgTemperature, pq: PQ.temperature),
          const Text(' / '),
          PQText(value: lap.maxTemperature, pq: PQ.temperature),
        ]),
        subtitle: const Text('avg / max temperature'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(
            value: lap.avgFractionalCadence,
            pq: PQ.fractionalCadence,
          ),
          const Text(' / '),
          PQText(
            value: lap.maxFractionalCadence,
            pq: PQ.fractionalCadence,
          ),
        ]),
        subtitle: const Text('avg / max fractional cadence'),
      ),
      ListTile(
        title: PQText(value: lap.totalFractionalCycles, pq: PQ.cycles),
        subtitle: const Text('total fractional cycles'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: lap.startPositionLong, pq: PQ.longitude),
              PQText(value: lap.startPositionLat, pq: PQ.latitude),
            ]),
        subtitle: const Text('start position'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: lap.endPositionLong, pq: PQ.longitude),
              PQText(value: lap.endPositionLat, pq: PQ.latitude),
            ]),
        subtitle: const Text('end position'),
      ),
      ListTile(
        title: PQText(value: lap.intensity, pq: PQ.integer),
        subtitle: const Text('intensity'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: lap.avgSpeed, pq: PQ.speed),
              PQText(value: lap.maxSpeed, pq: PQ.speed),
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
}
