import 'dart:math' as math;
import 'package:encrateia/models/bar_zone.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:flutter/material.dart';
import 'bar_chart_painter.dart';

class MyBarChart extends StatelessWidget {
  MyBarChart({
    int width,
    int height,
    @required num value,
    num maximum,
    num minimum,
    List<PowerZone> powerZones,
    List<HeartRateZone> heartRateZones,
    bool showPercentage,
  })  : _width = width?.toDouble() ?? 200.0,
        _height = height?.toDouble() ?? 30.0,
        _value = value.toDouble(),
        _maximum = maxFromZones(
          powerZones: powerZones,
          heartRateZones: heartRateZones,
          maximum: maximum,
        ),
        _minimum = minFromZones(
          powerZones: powerZones,
          heartRateZones: heartRateZones,
          minimum: minimum,
        ),
        _barZones = toBarZones(
          powerZones: powerZones,
          heartRateZones: heartRateZones,

        ),
        _showPercentage = showPercentage;

  MyBarChart.visualizeDistributions(
      {int width, int height, List<BarZone> distributions})
      : _width = width?.toDouble() ?? 200.0,
        _height = height?.toDouble() ?? 30.0,
        _minimum = 0,
        _maximum = distributions.last.upper.toDouble(),
        _value = distributions.last.upper.toDouble(),
        _barZones = distributions,
        _showPercentage = true;

  final double _width;
  final double _height;
  final double _value;
  final double _maximum;
  final double _minimum;
  final List<BarZone> _barZones;
  final bool _showPercentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: CustomPaint(
        painter: BarChartPainter(
          width: _width,
          height: _height,
          value: _value,
          maximum: _maximum,
          minimum: _minimum,
          barZones: _barZones,
          showPercentage: _showPercentage,
        ),
      ),
    );
  }

  static List<BarZone> toBarZones({
    List<PowerZone> powerZones,
    List<HeartRateZone> heartRateZones,
  }) {
    if (powerZones != null)
      return BarZone.fromPowerZones(powerZones);
    else if (heartRateZones != null)
      return BarZone.fromHeartRateZones(heartRateZones);
    else
      return <BarZone>[];
  }

  static double maxFromZones(
      {List<PowerZone> powerZones,
      List<HeartRateZone> heartRateZones,
      num maximum}) {
    if (maximum != null)
      return maximum.toDouble();
    else if (powerZones != null)
      return powerZones
          .map((PowerZone powerZone) => powerZone.upperLimit.toDouble())
          .reduce(math.max);
    else if (heartRateZones != null)
      return heartRateZones
          .map((HeartRateZone heartRateZone) =>
              heartRateZone.upperLimit.toDouble())
          .reduce(math.max);
    else
      return 100.0;
  }

  static double minFromZones(
      {List<PowerZone> powerZones,
      List<HeartRateZone> heartRateZones,
      num minimum}) {
    if (minimum != null)
      return minimum.toDouble();
    else if (powerZones != null)
      return powerZones
          .map((PowerZone powerZone) => powerZone.lowerLimit.toDouble())
          .reduce(math.min);
    else if (heartRateZones != null)
      return heartRateZones
          .map((HeartRateZone heartRateZone) =>
              heartRateZone.lowerLimit.toDouble())
          .reduce(math.min);
    else
      return 0.0;
  }
}
