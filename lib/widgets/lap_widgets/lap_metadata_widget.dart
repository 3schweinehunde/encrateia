import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapMetadataWidget extends StatelessWidget {
  final Lap lap;

  LapMetadataWidget({this.lap});

  @override
  Widget build(context) {
    return ListTileTheme(
      iconColor: MyColor.lap,
      child: GridView.count(
        padding: EdgeInsets.all(5),
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
        childAspectRatio: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        children: [
          ListTile(
            leading: MyIcon.repeats,
            title: Text('Lap ${lap.index}'),
          ),
          ListTile(
            leading: MyIcon.timeStamp,
            title: Text(
                DateFormat("dd MMM yyyy, h:mm:ss").format(lap.db.timeStamp)),
            subtitle: Text('timestamp'),
          ),
          ListTile(
            leading: MyIcon.event,
            title: Text(lap.db.event),
            subtitle: Text("event"),
          ),
          ListTile(
            leading: MyIcon.sport,
            title: Text(lap.db.sport + ' / ' + lap.db.subSport),
            subtitle: Text('sport / sub sport'),
          ),
          ListTile(
            leading: MyIcon.event,
            title:
                Text(lap.db.eventType + " / " + lap.db.eventGroup.toString()),
            subtitle: Text('event type / group'),
          ),
          ListTile(
            leading: MyIcon.verticalOscillation,
            title: Text(lap.db.avgVerticalOscillation.toStringAsFixed(2)),
            subtitle: Text('avg vertical oscillation'),
          ),
          ListTile(
            leading: MyIcon.time,
            title: Text(Duration(seconds: lap.db.totalElapsedTime).asString()),
            subtitle: Text('total elapsed time'),
          ),
          ListTile(
            leading: MyIcon.time,
            title: Text(Duration(seconds: lap.db.totalTimerTime).asString()),
            subtitle: Text('total timer time'),
          ),
          ListTile(
            leading: MyIcon.stanceTime,
            title: Text(
                '${lap.db.avgStanceTime} ms / ${lap.db.avgStanceTimePercent} %'),
            subtitle: Text('avg stance time / avg stance time percent'),
          ),
          ListTile(
            leading: MyIcon.event,
            title: Text(lap.db.lapTrigger),
            subtitle: Text('lap trigger'),
          ),
          ListTile(
            leading: MyIcon.temperature,
            title:
                Text('${lap.db.avgTemperature}° / ${lap.db.maxTemperature}°'),
            subtitle: Text('avg / max temperature'),
          ),
          ListTile(
            leading: MyIcon.cadence,
            title: Text(lap.db.avgFractionalCadence.toStringAsFixed(2) +
                " / " +
                lap.db.maxFractionalCadence.toStringAsFixed(2)),
            subtitle: Text('avg / max fractional cadence'),
          ),
          ListTile(
            leading: MyIcon.repeats,
            title: Text(lap.db.totalFractionalCycles.toStringAsFixed(2)),
            subtitle: Text('total fractional cycles'),
          ),
          ListTile(
            leading: MyIcon.position,
            title: Text(lap.db.startPositionLong.semicirclesAsDegrees() +
                " E\n" +
                lap.db.startPositionLat.semicirclesAsDegrees() +
                " N"),
            subtitle: Text('start position'),
          ),
          ListTile(
            leading: MyIcon.position,
            title: Text(lap.db.endPositionLong.semicirclesAsDegrees() +
                " E\n" +
                lap.db.endPositionLat.semicirclesAsDegrees() +
                " N"),
            subtitle: Text('end position'),
          ),
          ListTile(
            leading: MyIcon.intensity,
            title: Text(lap.db.intensity.toString()),
            subtitle: Text('intensity'),
          ),
          ListTile(
            leading: MyIcon.speed,
            title: Text((lap.db.avgSpeed * 3.6).toStringAsFixed(2) +
                " km/h / " +
                (lap.db.maxSpeed * 3.6).toStringAsFixed(2) +
                " km/h"),
            subtitle: Text('avg / max speed'),
          ),
        ],
      ),
    );
  }
}
