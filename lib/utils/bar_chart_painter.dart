import 'package:encrateia/models/bar_zone.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';

class BarChartPainter extends CustomPainter {
  BarChartPainter({
    @required this.width,
    @required this.height,
    @required this.value,
    @required this.maximum,
    @required this.minimum,
    @required this.barZones,
  });

  final double width;
  final double height;
  final double value;
  final double maximum;
  final double minimum;
  final double strokeWidth = 2;
  final List<BarZone> barZones;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromPoints(
        Offset(0 + strokeWidth / 2, strokeWidth / 2),
        Offset(width - strokeWidth / 2, height - strokeWidth / 2),
      ),
      Paint()
        ..color = MyColor.darkGray
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (barZones.isEmpty) {
      final double barWidth =
          (width - strokeWidth) / (maximum - minimum) * (value - minimum);
      canvas.drawRect(
          Rect.fromPoints(
            Offset(0 + strokeWidth, strokeWidth),
            Offset(barWidth, height - strokeWidth),
          ),
          Paint()
            ..color = MyColor.grapeFruit
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.fill);
    } else {
      for (final BarZone barZone in barZones) {
        double lowerInPixel;
        double upperInPixel;

        if (value < barZone.lower) continue;
        if (value >= barZone.upper) {
          lowerInPixel = (width - 2 * strokeWidth) /
                  (maximum - minimum) *
                  (barZone.lower - minimum) +
              strokeWidth;
          upperInPixel = (width - 2 * strokeWidth) /
                  (maximum - minimum) *
                  (barZone.upper - minimum) +
              strokeWidth;
        } else {
          lowerInPixel = (width - 2 * strokeWidth) /
                  (maximum - minimum) *
                  (barZone.lower - minimum) +
              strokeWidth;
          upperInPixel = (width - 2 * strokeWidth) /
                  (maximum - minimum) *
                  (value - minimum) +
              strokeWidth;
        }

        canvas.drawRect(
            Rect.fromPoints(
              Offset(lowerInPixel, strokeWidth),
              Offset(upperInPixel, height - strokeWidth),
            ),
            Paint()
              ..color = Color(barZone.color)
              ..strokeWidth = strokeWidth
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
