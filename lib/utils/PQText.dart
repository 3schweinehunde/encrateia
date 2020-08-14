import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'enums.dart';

@immutable
class PQText extends StatelessWidget {
  const PQText({
    @required this.pq,
    this.value,
    this.unit,
    this.format,
    this.naList,
  });

  final dynamic value;
  final String unit;
  final DateTimeFormat format;
  final PQ pq;
  final List<num> naList;

  @override
  Widget build(BuildContext context) {
    if (!validValue)
      return const Text('n.a.');

    switch (pq) {
      case PQ.dateTime:
        return Text(DateFormat(formatString).format(value as DateTime));
      case PQ.distance:
        return Text(((value as int) / 1000).toStringAsFixed(2) + ' km');
      case PQ.power:
        return Text((value as double).toStringAsFixed(1) + ' W');
      case PQ.pace:
        final double totalSeconds = 1000 / (value as double);
        final int minutes = (totalSeconds / 60).floor();
        final String seconds =
            (totalSeconds - minutes * 60).round().toString().padLeft(2, '0');
        return Text('$minutes:$seconds /km');
      case PQ.heartRate:
        return Text('$value bpm');
      case PQ.ecor:
        return Text((value as double).toStringAsFixed(3) + ' kJ / kg / km');
      case PQ.powerPerHeartRate:
        return Text((value as double).toStringAsFixed(2) + ' W/bpm');
      case PQ.calories:
        return Text((value as int).toString() + ' kcal');
      case PQ.elevation:
        return Text((value as int).toString() + ' m');
      case PQ.cadence:
        return Text(((value as double) * 2).round().toString() + ' spm');
      case PQ.duration:
        return Text(Duration(seconds: value as int).asString());
      case PQ.trainingEffect:
        return Text((value as int).toString());
    }
    return const Text('This is an error!'); // just to silence the dart analyzer
  }

  String get paddedUnit {
    if (unit != null)
      return ' ' + unit;
    else
      return '';
  }

  String get formatString {
    switch (format) {
      case DateTimeFormat.longDate:
        return 'd MMM yy';
      case DateTimeFormat.shortDate:
        return 'd.M.';
      case DateTimeFormat.shortTime:
        return 'H:mm';
      case DateTimeFormat.shortDateTime:
        return 'E d.M H:mm';
      case DateTimeFormat.longDateTime:
        return 'E d MMM yy, H:mm:ss';
    }
    return 'E d MMM yy, H:mm:ss';
  }

  bool get validValue {
    switch (pq) {
      case PQ.trainingEffect:
      case PQ.cadence:
      case PQ.calories:
      case PQ.dateTime:
      case PQ.distance:
      case PQ.duration:
      case PQ.ecor:
      case PQ.elevation:
      case PQ.powerPerHeartRate:
        return value != null;
      case PQ.power:
      case PQ.pace:
        return value != null && value != -1;
      case PQ.heartRate:
        return value != null && value != 255;
    }
    return false;  // just to silence the dart analyzer
  }
}
