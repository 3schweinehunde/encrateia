import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/activity.dart';

class ActivityMetadataWidget extends StatelessWidget {
  const ActivityMetadataWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  List<Widget> get tiles {
    return <Widget>[
      ListTile(title: Text(activity.name)),
      ListTile(
        title: Text(
            DateFormat('dd MMM yyyy, h:mm:ss').format(activity.timeStamp)),
        subtitle: const Text('timestamp'),
      ),
      ListTile(
        title: Text(activity.event),
        subtitle: const Text('last event'),
      ),
      if (activity.totalStrides != null)
        ListTile(
          title: Text(activity.totalStrides.toString()),
          subtitle: const Text('total strides'),
        ),
      if (activity.maxRunningCadence != null)
        ListTile(
          title: Text('${activity.avgRunningCadence.round()} /'
              ' ${activity.maxRunningCadence}'),
          subtitle: const Text('avg / max running cadence'),
        ),
      ListTile(
        title: Text(
            '${activity.avgTemperature}° / ${activity.maxTemperature}°'),
        subtitle: const Text('avg / max temperature'),
      ),
      ListTile(
        title: Text(activity.avgVerticalOscillation.toStringAsFixed(2)),
        subtitle: const Text('avg vertical oscillation'),
      ),
      ListTile(
        title: Text(activity.totalFractionalCycles.toStringAsFixed(2)),
        subtitle: const Text('total fractional cycles'),
      ),
      ListTile(
        title: Text(Duration(seconds: activity.totalElapsedTime).asString()),
        subtitle: const Text('total elapsed time'),
      ),
      ListTile(
        title: Text(Duration(seconds: activity.totalTimerTime).asString()),
        subtitle: const Text('total timer time'),
      ),
      ListTile(
        title: Text('${activity.stravaId} / ${activity.serialNumber}'),
        subtitle: const Text('Strava / Garmin id'),
      ),
      ListTile(
        title: Text(activity.type +
            ' / ' +
            activity.sport +
            ' / ' +
            activity.subSport),
        subtitle: const Text('activity type / sport / sub sport'),
      ),
      ListTile(
        title: Text(activity.eventType + ' / ' + activity.trigger),
        subtitle: const Text('event type / trigger'),
      ),
      ListTile(
        title: Text('${activity.numLaps} / ${activity.numSessions}'),
        subtitle: const Text('number of laps / sessions'),
      ),
      ListTile(
        title: Text(activity.avgFractionalCadence.toStringAsFixed(2) +
            ' / ' +
            activity.maxFractionalCadence.toStringAsFixed(2)),
        subtitle: const Text('avg / max fractional cadence'),
      ),
      ListTile(
        title: Text(
            '${activity.avgStanceTime} ms / ${activity.avgStanceTimePercent} %'),
        subtitle: const Text('avg stance time / avg stance time percent'),
      ),
      ListTile(
        title: Text(activity.startPositionLong.semicirclesAsDegrees() +
            ' E\n' +
            activity.startPositionLat.semicirclesAsDegrees() +
            ' N'),
        subtitle: const Text('start position'),
      ),
      ListTile(
        title: Text(activity.necLong.semicirclesAsDegrees() +
            ' E\n' +
            activity.necLat.semicirclesAsDegrees() +
            ' N'),
        subtitle: const Text('north east corner'),
      ),
      ListTile(
        title: Text(activity.swcLong.semicirclesAsDegrees() +
            ' E\n' +
            activity.swcLat.semicirclesAsDegrees() +
            ' N'),
        subtitle: const Text('south west corner'),
      ),
      ListTile(
        title: Text((activity.avgSpeed * 3.6).toStringAsFixed(2) +
            ' km/h / ' +
            (activity.maxSpeed * 3.6).toStringAsFixed(2) +
            ' km/h'),
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
