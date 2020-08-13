import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'enums.dart';

@immutable
class PQ extends StatelessWidget {
  const PQ({
    this.value,
    this.unit,
    this.text,
    this.dateTime,
    this.format,
    this.distance,
  });

  final num value;
  final String unit;
  final String text;
  final DateTime dateTime;
  final DateTimeFormat format;
  final int distance;

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return (unit != null) ? Text(text + ' ' + unit) : Text(text);
    } else if (value != null) {
      return (unit != null)
          ? Text(value.toString() + ' ' + unit)
          : Text(value.toString());
    } else if (dateTime != null) {
      switch (format) {
        case DateTimeFormat.longDate:
          return Text(DateFormat('d MMM yy').format(dateTime));
        case DateTimeFormat.shortDate:
          return Text(DateFormat('d.M.').format(dateTime));
        case DateTimeFormat.shortTime:
          return Text(DateFormat('H:mm').format(dateTime));
        case DateTimeFormat.shortDateTime:
          return Text(DateFormat('d.MM H:mm').format(dateTime));
        case DateTimeFormat.longDateTime:
        default:
          return Text(DateFormat('E d MMM yy, H:mm:ss').format(dateTime));
      }
    } else if (distance != null) {
      return Text((distance / 1000).toStringAsFixed(2) + ' km');
    } else
      return const Text('n.a.');
  }
}
