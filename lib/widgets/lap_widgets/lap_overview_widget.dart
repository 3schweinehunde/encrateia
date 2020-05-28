import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/lap.dart';

class LapOverviewWidget extends StatelessWidget {
  const LapOverviewWidget({this.lap});

  final Lap lap;

  @override
  Widget build(BuildContext context) {
    return  StaggeredGridView.count(
      staggeredTiles: List<StaggeredTile>.filled(10, const StaggeredTile.fit(1)),
      mainAxisSpacing: 4,
      crossAxisCount:
      MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: <Widget>[
          ListTile(
            title: Text(lap.db.avgSpeed.toPace() + ' / ' + lap.db.maxSpeed.toPace()),
            subtitle: const Text('avg / max pace'),
          ),
          ListTile(
            title:
            Text('${lap.db.avgHeartRate} / ${lap.db.maxHeartRate} bpm'),
            subtitle: const Text('avg / max heart rate'),
          ),
          ListTile(
            title:
            Text('${lap.db.avgPower.toStringAsFixed(1)} W'),
            subtitle: const Text('avg power'),
          ),
          ListTile(
            title:
            Text('${(lap.db.avgPower / lap.db.avgHeartRate).toStringAsFixed(2)} W/bpm'),
            subtitle: const Text('power / heart rate'),
          ),
          ListTile(
            title: Text(
                DateFormat('dd MMM yyyy, h:mm:ss').format(lap.db.startTime)),
            subtitle: const Text('start time'),
          ),
          ListTile(
            title:
                Text('${(lap.db.totalDistance / 1000).toStringAsFixed(2)} km'),
            subtitle: const Text('distance'),
          ),
          ListTile(
            title: Text('${lap.db.totalCalories} kcal'),
            subtitle: const Text('total calories'),
          ),
          ListTile(
            title: Text('${lap.db.totalAscent} - ${lap.db.totalDescent}'
                ' = ${lap.db.totalAscent - lap.db.totalDescent} m'),
            subtitle: const Text('total ascent - descent = total climb'),
          ),
          ListTile(
            title: Text('${(lap.db.avgRunningCadence ?? 0 * 2).round()} / '
                '${lap.db.maxRunningCadence ?? 0 * 2} spm'),
            subtitle: const Text('avg / max steps per minute'),
          ),
          ListTile(
            title: Text(lap.db.totalStrides.toString()),
            subtitle: const Text('total strides'),
          ),
        ],
    );
  }
}
