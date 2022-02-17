import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/utils/date_time_utils.dart';
import 'enums.dart';

@immutable
class PQText extends StatelessWidget {
  const PQText({Key? key,
    required this.pq,
    this.value,
    this.format = DateTimeFormat.longDateTime,
  }) : super(key: key);

  final dynamic value;
  final DateTimeFormat format;
  final PQ pq;

  @override
  Widget build(BuildContext context) {
    if (!validValue) {
      return const Text('n.a.');
    }

    switch (pq) {
      case PQ.dateTime:
        return Text(DateFormat(formatString).format(value as DateTime));
      case PQ.distance:
        return Text(((value as int) / 1000).toStringAsFixed(2) + ' km');
      case PQ.distanceInMeters:
        return Text((value as double).toStringAsFixed(2) + ' m');
      case PQ.power:
        return Text((value as num).toStringAsPrecision(3) + ' W');
      case PQ.paceFromSpeed:
        final double totalSeconds = 1000 / (value as double);
        final int minutes = (totalSeconds / 60).floor();
        final String seconds =
            (totalSeconds - minutes * 60).round().toString().padLeft(2, '0');
        return Text('$minutes:$seconds /km');
      case PQ.pace:
        final double minutes = value as double;
        final int fullMinutes = minutes.floor();
        final String seconds =
            ((minutes - fullMinutes) * 60).round().toString().padLeft(2, '0');
        return Text('$fullMinutes:$seconds /km');
      case PQ.heartRate:
        return Text((value as num).toStringAsPrecision(3) + ' bpm');
      case PQ.ecor:
        return Text((value as num).toStringAsFixed(3) + ' kJ/kg/km');
      case PQ.powerPerHeartRate:
        return Text((value as num).toStringAsFixed(2) + ' W/bpm');
      case PQ.calories:
        return Text((value as num?).toString() + ' kcal');
      case PQ.elevation:
        return Text((value as num?).toString() + ' m');
      case PQ.cadence:
        return Text(((value as num) * 2).toStringAsPrecision(3) + ' spm');
      case PQ.duration:
        return Text(Duration(seconds: value as int).asString());
      case PQ.shortDuration:
        return Text(Duration(seconds: value as int).asShortString());
      case PQ.trainingEffect:
        return Text((value as num?).toString());
      case PQ.text:
        return Text(value as String);
      case PQ.temperature:
        return Text((value as num?).toString() + '°C');
      case PQ.verticalOscillation:
        return Text((value as num).toStringAsFixed(2) + ' cm');
      case PQ.cycles:
        return Text((value as num?).toString() + ' cycles');
      case PQ.integer:
        return Text((value as num?).toString());
      case PQ.fractionalCadence:
        return Text((value as num).toStringAsFixed(2));
      case PQ.percentage:
        return Text((value as num).toStringAsFixed(2) + ' %');
      case PQ.stanceTime:
      case PQ.groundTime:
        return Text((value as num).toStringAsPrecision(4) + ' ms');
      case PQ.longitude:
        return Text((value as double?)!.semicirclesToString() + ' E');
      case PQ.latitude:
        return Text((value as double?)!.semicirclesToString() + ' N');
      case PQ.speed:
        return Text(((value as num) * 3.6).toStringAsFixed(2) + ' km/h');
      case PQ.speedPerHeartRate:
        return Text((value as num).toStringAsPrecision(3) + ' m/beat');
      case PQ.weight:
        return Text((value as num).toStringAsFixed(1) + ' kg');
      case PQ.legSpringStiffness:
        return Text((value as num).toStringAsPrecision(3) + ' kN/m');
      case PQ.double:
        return Text((value as double).toStringAsPrecision(3));
    }
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
      case DateTimeFormat.compact:
        return 'dd.MM.yyyy\nH:mm:ss';
    }
  }

  bool get validValue {
    switch (pq) {
      case PQ.cadence:
      case PQ.groundTime:
      case PQ.legSpringStiffness:
      case PQ.paceFromSpeed:
      case PQ.power:
      case PQ.speed:
      case PQ.verticalOscillation:
      case PQ.ecor:
        return value != null && value != -1;
      case PQ.heartRate:
        return value != null && value != 255 && value != -1;
      case PQ.stanceTime:
        return value != null && value != 6553.50;
      case PQ.percentage:
        return value != null && value != 655.35;
      default:
        return value != null;
    }
  }
}
