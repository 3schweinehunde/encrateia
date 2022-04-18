import 'package:flutter/material.dart';
import '/models/bar_zone.dart';
import '/utils/my_color.dart';

class BarChartPainter extends CustomPainter {
  BarChartPainter({
    required this.width,
    required this.height,
    required this.value,
    required this.maximum,
    required this.minimum,
    required this.barZones,
    this.showPercentage,
  });

  final double width;
  final double height;
  final double value;
  final double maximum;
  final double minimum;
  final double strokeWidth = 0.5;
  final List<BarZone> barZones;
  bool? showPercentage = false;

  @override
  void paint(Canvas canvas, Size size) {
    const TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );

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

    if (barZones.isEmpty) {
      final double barWidth =
          (width - strokeWidth) / (maximum - minimum) * (value - minimum);
      canvas.drawRect(
          Rect.fromPoints(
            Offset(0 + strokeWidth, strokeWidth),
            Offset(barWidth, height - strokeWidth),
          ),
          Paint()
            ..color = MyColor.lightGray
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.fill);
    } else {
      for (final BarZone barZone in barZones) {
        double lowerInPixel;
        double upperInPixel;

        if (value < barZone.lower!) {
          continue;
        }
        if (value >= barZone.upper!) {
          lowerInPixel = (width - 2 * strokeWidth) /
                  (maximum - minimum) *
                  (barZone.lower! - minimum) +
              strokeWidth;
          upperInPixel = (width - 2 * strokeWidth) /
                  (maximum - minimum) *
                  (barZone.upper! - minimum) +
              strokeWidth;
        } else {
          lowerInPixel = (width - 2 * strokeWidth) /
                  (maximum - minimum) *
                  (barZone.lower! - minimum) +
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
              ..color = Color(barZone.color!)
              ..strokeWidth = strokeWidth
              ..style = PaintingStyle.fill);

        if (showPercentage == true) {
          final int percentage =
              ((barZone.upper! - barZone.lower!) / (maximum - minimum) * 100)
                  .round();
          String percentageString;
          switch (percentage) {
            case 0:
              percentageString = '';
              break;
            case 1:
              percentageString = '.';
              break;
            case 2:
              percentageString = ':';
              break;
            case 3:
              percentageString = '⋮';
              break;
            default:
              percentageString = percentage.toString();
          }
          final TextSpan span =
              TextSpan(style: textStyle, text: percentageString);
          final TextPainter textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(canvas, Offset(lowerInPixel, strokeWidth));
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
