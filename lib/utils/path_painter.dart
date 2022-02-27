import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/my_color.dart';

class PathPainter extends CustomPainter {
  PathPainter({
    required this.width,
    required this.height,
    required this.records,
    required this.activity,
  });

  final double width;
  final double height;
  final RecordList<Event> records;
  final double strokeWidth = 2;
  final Activity? activity;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromPoints(
        Offset(0 + strokeWidth / 2, strokeWidth / 2),
        Offset(width - strokeWidth / 2, height - strokeWidth / 2),
      ),
      Paint()
        ..color = MyColor.lightGray
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    final double scaleX = width / (activity!.necLong! - activity!.swcLong!);
    final double scaleY = height / (activity!.necLat! - activity!.swcLat!);
    final double scale = min(scaleX, scaleY);
    canvas.drawPoints(
      PointMode.points,
      records
          .map(
            (Event record) => Offset(
              width / 2 +
                  scale *
                      (record.positionLong! -
                          activity!.swcLong! / 2 -
                          activity!.necLong! / 2),
              height / 2 +
                  scale *
                      (activity!.necLat! / 2 +
                          activity!.swcLat! / 2 -
                          record.positionLat!),
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
