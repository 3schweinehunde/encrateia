import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/lap.dart';

class LapMetadataWidget extends StatelessWidget {
  const LapMetadataWidget({this.lap});

  final Lap lap;

  List<Widget> get tiles {
    return <Widget>[
      ListTile(
        title:
            Text(DateFormat('dd MMM yyyy, h:mm:ss').format(lap.timeStamp)),
        subtitle: const Text('timestamp'),
      ),
      ListTile(
        title: Text(lap.event),
        subtitle: const Text('event'),
      ),
      ListTile(
        title: Text(lap.sport + ' / ' + lap.subSport),
        subtitle: const Text('sport / sub sport'),
      ),
      ListTile(
        title: Text(lap.eventType + ' / ' + lap.eventGroup.toString()),
        subtitle: const Text('event type / group'),
      ),
      ListTile(
        title: Text(lap.avgVerticalOscillation.toStringAsFixed(2)),
        subtitle: const Text('avg vertical oscillation'),
      ),
      ListTile(
        title: Text(Duration(seconds: lap.totalElapsedTime).asString()),
        subtitle: const Text('total elapsed time'),
      ),
      ListTile(
        title: Text(Duration(seconds: lap.totalTimerTime).asString()),
        subtitle: const Text('total timer time'),
      ),
      ListTile(
        title: Text(
            '${lap.avgStanceTime} ms / ${lap.avgStanceTimePercent} %'),
        subtitle: const Text('avg stance time / avg stance time percent'),
      ),
      ListTile(
        title: Text(lap.lapTrigger),
        subtitle: const Text('lap trigger'),
      ),
      ListTile(
        title: Text('${lap.avgTemperature}° / ${lap.maxTemperature}°'),
        subtitle: const Text('avg / max temperature'),
      ),
      ListTile(
        title: Text(lap.avgFractionalCadence.toStringAsFixed(2) +
            ' / ' +
            lap.maxFractionalCadence.toStringAsFixed(2)),
        subtitle: const Text('avg / max fractional cadence'),
      ),
      ListTile(
        title: Text(lap.totalFractionalCycles.toStringAsFixed(2)),
        subtitle: const Text('total fractional cycles'),
      ),
      ListTile(
        title: Text(lap.startPositionLong.semicirclesAsDegrees() +
            ' E\n' +
            lap.startPositionLat.semicirclesAsDegrees() +
            ' N'),
        subtitle: const Text('start position'),
      ),
      ListTile(
        title: Text(lap.endPositionLong.semicirclesAsDegrees() +
            ' E\n' +
            lap.endPositionLat.semicirclesAsDegrees() +
            ' N'),
        subtitle: const Text('end position'),
      ),
      ListTile(
        title: Text(lap.intensity.toString()),
        subtitle: const Text('intensity'),
      ),
      ListTile(
        title: Text((lap.avgSpeed * 3.6).toStringAsFixed(2) +
            ' km/h / ' +
            (lap.maxSpeed * 3.6).toStringAsFixed(2) +
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
