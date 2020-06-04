import 'dart:math';
import 'dart:ui';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  PathPainter({
    @required this.width,
    @required this.height,
    @required this.records,
    @required this.activity,
  });

  final double width;
  final double height;
  final RecordList<Event> records;
  final double strokeWidth = 1;
  final Activity activity;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = width / (activity.db.necLong - activity.db.swcLong);
    final double scaleY = height / (activity.db.necLat - activity.db.swcLat);
    final double scale = min(scaleX, scaleY);
    canvas.drawPoints(
      PointMode.points,
      records
          .map(
            (Event record) => Offset(
              scale * (record.db.positionLong - activity.db.swcLong),
              scale * (activity.db.swcLat - record.db.positionLat),
            ),
          )
          .toList(),
      Paint()
        ..color = MyColor.grass
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
