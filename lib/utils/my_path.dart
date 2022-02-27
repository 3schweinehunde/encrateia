import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/path_painter.dart';

class MyPath extends StatelessWidget {
  MyPath({Key? key,
    int? width,
    int? height,
    required Activity? activity,
    required RecordList<Event> records,
  })  : _width = width?.toDouble() ?? 300.0,
        _height = height?.toDouble() ?? 300.0,
        _activity = activity,
        _records = records, super(key: key);

  final double _width;
  final double _height;
  final Activity? _activity;
  final RecordList<Event> _records;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: CustomPaint(
        painter: PathPainter(
            width: _width,
            height: _height,
            activity: _activity,
            records: _records),
      ),
    );
  }
}
