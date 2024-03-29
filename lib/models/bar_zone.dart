import '/models/power_zone.dart';
import 'heart_rate_zone.dart';

class BarZone {
  BarZone({this.lower, this.upper, this.color});

  static List<BarZone> fromPowerZones(
    List<PowerZone> powerZones,
  ) {
    return <BarZone>[
      for (final PowerZone powerZone in powerZones)
        BarZone(
          lower: powerZone.lowerLimit!.toDouble(),
          upper: powerZone.upperLimit!.toDouble(),
          color: powerZone.color,
        )
    ];
  }

  static List<BarZone> fromHeartRateZones(
    List<HeartRateZone> heartRateZones,
  ) {
    return <BarZone>[
      for (final HeartRateZone heartRateZone in heartRateZones)
        BarZone(
          lower: heartRateZone.lowerLimit!.toDouble(),
          upper: heartRateZone.upperLimit!.toDouble(),
          color: heartRateZone.color,
        )
    ];
  }

  double? lower;
  double? upper;
  int? color;
}
