import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/path_painter.dart';
import 'package:flutter/material.dart';

class MyPath extends StatelessWidget {
  MyPath({
    int width,
    int height,
    @required Activity activity,
    @required RecordList<Event> records,
  })  : _width = width?.toDouble() ?? 300.0,
        _height = height?.toDouble() ?? 300.0,
        _activity = activity,
        _records = records;

  final double _width;
  final double _height;
  final Activity _activity;
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
          records: _records
        ),
      ),
    );
  }
}
