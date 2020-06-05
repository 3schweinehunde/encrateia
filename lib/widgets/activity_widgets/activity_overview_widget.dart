import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/activity.dart';

class ActivityOverviewWidget extends StatefulWidget {
  const ActivityOverviewWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityOverviewWidgetState createState() => _ActivityOverviewWidgetState();
}

class _ActivityOverviewWidgetState extends State<ActivityOverviewWidget> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<Widget> get tiles {
    return <ListTile>[
      ListTile(
        title: Text(
            '${(widget.activity.db.distance / 1000).toStringAsFixed(2)} km'),
        subtitle: const Text('distance'),
      ),
      ListTile(
        title: Text(
            Duration(seconds: widget.activity.db.movingTime ?? 0).asString()),
        subtitle: const Text('moving time'),
      ),
      ListTile(
        title: Text(widget.activity.db.avgSpeed.toPace() +
            ' / ' +
            widget.activity.db.maxSpeed.toPace()),
        subtitle: const Text('avg / max pace'),
      ),
      ListTile(
        title: Text((widget.activity.weight != null)
            ? (widget.activity.getAttribute(ActivityAttr.ecor) as double)
                    .toStringAsFixed(3) +
                ' kJ / kg / km'
            : 'not available'),
        subtitle: const Text('ecor'),
      ),
      ListTile(
        title: Text('${widget.activity.db.avgHeartRate} / '
            '${widget.activity.db.maxHeartRate} bpm'),
        subtitle: const Text('avg / max heart rate'),
      ),
      ListTile(
        title: Text('${widget.activity.db.avgPower.toStringAsFixed(1)} W'),
        subtitle: const Text('avg power'),
      ),
      ListTile(
        title: (widget.activity.db.avgPower != -1)
            ? Text(
                (widget.activity.db.avgPower / widget.activity.db.avgHeartRate)
                        .toStringAsFixed(2) +
                    ' W/bpm')
            : const Text('No power data available'),
        subtitle: const Text('power / heart rate'),
      ),
      ListTile(
        title: Text('${widget.activity.db.totalCalories} kcal'),
        subtitle: const Text('total calories'),
      ),
      ListTile(
        title: Text(DateFormat('dd MMM yyyy, h:mm:ss')
            .format(widget.activity.db.timeCreated)),
        subtitle: const Text('time created'),
      ),
      ListTile(
        title: Text('${widget.activity.db.totalAscent ?? 0} - '
                '${widget.activity.db.totalDescent ?? 0}'
                ' = ' +
            ((widget.activity.db.totalAscent ?? 0) -
                    (widget.activity.db.totalDescent ?? 0))
                .toString() +
            ' m'),
        subtitle: const Text('total ascent - descent = total climb'),
      ),
      ListTile(
        title:
            Text('${(widget.activity.db.avgRunningCadence ?? 0 * 2).round()} / '
                '${widget.activity.db.maxRunningCadence ?? 0 * 2} spm'),
        subtitle: const Text('avg / max steps per minute'),
      ),
      ListTile(
        title: Text(widget.activity.db.totalTrainingEffect.toString()),
        subtitle: const Text('total training effect'),
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
      athletesId: widget.athlete.db.id,
      date: widget.activity.db.timeCreated,
    );
    setState(() {
      widget.activity.weight = weight?.db?.value;
    });
  }
}
