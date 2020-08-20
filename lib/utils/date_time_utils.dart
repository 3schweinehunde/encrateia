import 'dart:math';

DateTime dateTimeFromStrava(double dateTime) {
  return DateTime.fromMillisecondsSinceEpoch(
      // Strava's datetime offset: 31.12.1989, 00:00
      (dateTime.round() + 631065600) * 1000);
}

extension DurationFormatters on Duration {
  String asString() {
    return inHours.toString() +
        'h ' +
        inMinutes.remainder(60).toString() +
        'min ' +
        inSeconds.remainder(60).toString() +
        's';
  }
}

extension DegreeFormatters on double {
  String semicirclesAsDegrees() {
    final double fractionalDegrees = this * (180 / pow(2, 31));
    final int degrees = fractionalDegrees.floor();
    final int minutes = ((fractionalDegrees - degrees) * 60).floor();
    final double seconds =
        (((fractionalDegrees - degrees) * 60) - minutes) * 60;

    return '$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
  }

  String toPace() {
    if (this != null) {
      final double totalSeconds = 1000 / this;
      final int minutes = (totalSeconds / 60).floor();
      final String seconds =
          (totalSeconds - minutes * 60).round().toString().padLeft(2, '0');
      return '$minutes:$seconds';
    } else {
      return '- - - ';
    }
  }

  double toPaceDouble() {
    if (this != null)
      return 1000 / this;
    return 0;
  }
}
