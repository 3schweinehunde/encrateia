import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';

class ActivityMetadataWidget extends StatelessWidget {
  const ActivityMetadataWidget({
    required this.activity,
    required this.athlete,
  });

  final Activity? activity;
  final Athlete? athlete;

  List<Widget> get tiles {
    return <Widget>[
      ListTile(title: Text(activity!.name!)),
      ListTile(
        title: PQText(
          value: activity!.timeStamp,
          pq: PQ.dateTime,
          format: DateTimeFormat.longDateTime,
        ),
        subtitle: const Text('timestamp'),
      ),
      ListTile(
        title: PQText(value: activity!.event, pq: PQ.text),
        subtitle: const Text('last event'),
      ),
      ListTile(
        title: PQText(value: activity!.totalStrides, pq: PQ.integer),
        subtitle: const Text('total strides'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: activity!.avgRunningCadence, pq: PQ.cadence),
          const Text(' / '),
          PQText(value: activity!.maxRunningCadence, pq: PQ.cadence),
        ]),
        subtitle: const Text('avg / max running cadence'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: activity!.avgTemperature, pq: PQ.temperature),
          const Text(' / '),
          PQText(value: activity!.maxTemperature, pq: PQ.temperature),
        ]),
        subtitle: const Text('avg / max temperature'),
      ),
      ListTile(
        title: PQText(
          value: activity!.avgVerticalOscillation,
          pq: PQ.verticalOscillation,
        ),
        subtitle: const Text('avg vertical oscillation'),
      ),
      ListTile(
        title: PQText(value: activity!.totalFractionalCycles, pq: PQ.cycles),
        subtitle: const Text('total fractional cycles'),
      ),
      ListTile(
        title: PQText(value: activity!.totalElapsedTime, pq: PQ.duration),
        subtitle: const Text('total elapsed time'),
      ),
      ListTile(
        title: PQText(value: activity!.totalTimerTime, pq: PQ.duration),
        subtitle: const Text('total timer time'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: activity!.stravaId, pq: PQ.integer),
              PQText(value: activity!.serialNumber, pq: PQ.integer),
            ]),
        subtitle: const Text('Strava / Garmin id'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: activity!.type, pq: PQ.text),
              PQText(value: activity!.sport, pq: PQ.text),
              PQText(value: activity!.subSport, pq: PQ.text),
            ]),
        subtitle: const Text('activity type / sport / sub sport'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: activity!.eventType, pq: PQ.text),
          const Text(' / '),
          PQText(value: activity!.trigger, pq: PQ.text),
        ]),
        subtitle: const Text('event type / trigger'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: activity!.numLaps, pq: PQ.integer),
          const Text(' / '),
          PQText(value: activity!.numSessions, pq: PQ.integer),
        ]),
        subtitle: const Text('number of laps / sessions'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(
            value: activity!.avgFractionalCadence,
            pq: PQ.fractionalCadence,
          ),
          const Text(' / '),
          PQText(
            value: activity!.maxFractionalCadence,
            pq: PQ.fractionalCadence,
          ),
        ]),
        subtitle: const Text('avg / max fractional cadence'),
      ),
      ListTile(
        title: Row(children: <Widget>[
          PQText(value: activity!.avgStanceTime, pq: PQ.stanceTime),
          const Text(' / '),
          PQText(value: activity!.avgStanceTimePercent, pq: PQ.percentage),
        ]),
        subtitle: const Text('avg stance time / avg stance time percent'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: activity!.startPositionLong, pq: PQ.longitude),
              PQText(value: activity!.startPositionLat, pq: PQ.latitude),
            ]),
        subtitle: const Text('start position'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: activity!.necLong, pq: PQ.longitude),
              PQText(value: activity!.necLat, pq: PQ.latitude),
            ]),
        subtitle: const Text('north east corner'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: activity!.swcLong, pq: PQ.longitude),
              PQText(value: activity!.swcLat, pq: PQ.latitude),
            ]),
        subtitle: const Text('south west corner'),
      ),
      ListTile(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PQText(value: activity!.avgSpeed, pq: PQ.speed),
              PQText(value: activity!.maxSpeed, pq: PQ.speed),
            ]),
        subtitle: const Text('avg / max speed'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: tiles,
    );
  }
}
