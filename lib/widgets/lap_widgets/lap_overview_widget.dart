import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/lap.dart';

class LapOverviewWidget extends StatelessWidget {
  const LapOverviewWidget({this.lap});

  final Lap lap;

  List<Widget> get tiles {
    return <Widget>[
      ListTile(
        title:
            Text(lap.avgSpeed.toPace() + ' / ' + lap.maxSpeed.toPace()),
        subtitle: const Text('avg / max pace'),
      ),
      ListTile(
        title: Text('${lap.avgHeartRate} / ${lap.maxHeartRate} bpm'),
        subtitle: const Text('avg / max heart rate'),
      ),
      ListTile(
        title: Text('${lap.avgPower.toStringAsFixed(1)} W'),
        subtitle: const Text('avg power'),
      ),
      ListTile(
        title: Text(
            '${(lap.avgPower / lap.avgHeartRate).toStringAsFixed(2)} W/bpm'),
        subtitle: const Text('power / heart rate'),
      ),
      ListTile(
        title:
            Text(DateFormat('dd MMM yyyy, h:mm:ss').format(lap.startTime)),
        subtitle: const Text('start time'),
      ),
      ListTile(
        title: Text('${(lap.totalDistance / 1000).toStringAsFixed(2)} km'),
        subtitle: const Text('distance'),
      ),
      ListTile(
        title: Text('${lap.totalCalories} kcal'),
        subtitle: const Text('total calories'),
      ),
      ListTile(
        title: Text('${lap.totalAscent} - ${lap.totalDescent}'
            ' = ${lap.totalAscent - lap.totalDescent} m'),
        subtitle: const Text('total ascent - descent = total climb'),
      ),
      ListTile(
        title: Text('${(lap.avgRunningCadence ?? 0 * 2).round()} / '
            '${lap.maxRunningCadence ?? 0 * 2} spm'),
        subtitle: const Text('avg / max steps per minute'),
      ),
      ListTile(
        title: Text(lap.totalStrides.toString()),
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
}
