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

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      staggeredTiles: List<StaggeredTile>.filled(22, const StaggeredTile.fit(1)),
      mainAxisSpacing: 4,
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: <Widget>[
        ListTile(
          title: Text(activity.db.name),
        ),
        ListTile(
          title: Text(
              DateFormat('dd MMM yyyy, h:mm:ss').format(activity.db.timeStamp)),
          subtitle: const Text('timestamp'),
        ),
        ListTile(
          title: Text(activity.db.event),
          subtitle: const Text('last event'),
        ),
        if (activity.db.totalStrides != null)
          ListTile(
            title: Text(activity.db.totalStrides.toString()),
            subtitle: const Text('total strides'),
          ),
        if (activity.db.maxRunningCadence != null)
          ListTile(
            title: Text('${activity.db.avgRunningCadence.round()} /'
                ' ${activity.db.maxRunningCadence}'),
            subtitle: const Text('avg / max running cadence'),
          ),
        ListTile(
          title: Text(
              '${activity.db.avgTemperature}° / ${activity.db.maxTemperature}°'),
          subtitle: const Text('avg / max temperature'),
        ),
        ListTile(
          title: Text(activity.db.avgVerticalOscillation.toStringAsFixed(2)),
          subtitle: const Text('avg vertical oscillation'),
        ),
        ListTile(
          title: Text(activity.db.totalFractionalCycles.toStringAsFixed(2)),
          subtitle: const Text('total fractional cycles'),
        ),
        ListTile(
          title:
              Text(Duration(seconds: activity.db.totalElapsedTime).asString()),
          subtitle: const Text('total elapsed time'),
        ),
        ListTile(
          title: Text(Duration(seconds: activity.db.totalTimerTime).asString()),
          subtitle: const Text('total timer time'),
        ),
        ListTile(
          title: Text('${activity.db.stravaId} / ${activity.db.serialNumber}'),
          subtitle: const Text('Strava / Garmin id'),
        ),
        ListTile(
          title: Text(activity.db.type +
              ' / ' +
              activity.db.sport +
              ' / ' +
              activity.db.subSport),
          subtitle: const Text('activity type / sport / sub sport'),
        ),
        ListTile(
          title: Text(activity.db.eventType + ' / ' + activity.db.trigger),
          subtitle: const Text('event type / trigger'),
        ),
        ListTile(
          title: Text('${activity.db.numLaps} / ${activity.db.numSessions}'),
          subtitle: const Text('number of laps / sessions'),
        ),
        ListTile(
          title: Text(activity.db.avgFractionalCadence.toStringAsFixed(2) +
              ' / ' +
              activity.db.maxFractionalCadence.toStringAsFixed(2)),
          subtitle: const Text('avg / max fractional cadence'),
        ),
        ListTile(
          title: Text(
              '${activity.db.avgStanceTime} ms / ${activity.db.avgStanceTimePercent} %'),
          subtitle: const Text('avg stance time / avg stance time percent'),
        ),
        ListTile(
          title: Text(activity.db.startPositionLong.semicirclesAsDegrees() +
              ' E\n' +
              activity.db.startPositionLat.semicirclesAsDegrees() +
              ' N'),
          subtitle: const Text('start position'),
        ),
        ListTile(
          title: Text(activity.db.necLong.semicirclesAsDegrees() +
              ' E\n' +
              activity.db.necLat.semicirclesAsDegrees() +
              ' N'),
          subtitle: const Text('north east corner'),
        ),
        ListTile(
          title: Text(activity.db.swcLong.semicirclesAsDegrees() +
              ' E\n' +
              activity.db.swcLat.semicirclesAsDegrees() +
              ' N'),
          subtitle: const Text('south west corner'),
        ),
        ListTile(
          title: Text((activity.db.avgSpeed * 3.6).toStringAsFixed(2) +
              ' km/h / ' +
              (activity.db.maxSpeed * 3.6).toStringAsFixed(2) +
              ' km/h'),
          subtitle: const Text('avg / max speed'),
        ),
        const Text(''),
        const Text('')
      ],
    );
  }
}
