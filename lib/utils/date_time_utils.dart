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

  String asShortString() {
    return inMinutes.remainder(60).toString() +
        'min ' +
        inSeconds.remainder(60).toString() +
        's';
  }
}

extension DegreeFormatters on double {
  String semicirclesToString() {
    final double fractionalDegrees = this * (180 / pow(2, 31));
    final int degrees = fractionalDegrees.floor();
    final int minutes = ((fractionalDegrees - degrees) * 60).floor();
    final double seconds =
        (((fractionalDegrees - degrees) * 60) - minutes) * 60;

    return '$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
  }

  int semicirclesDegreePortion() {
    final double fractionalDegrees = this * (180 / pow(2, 31));
    return fractionalDegrees.floor();
  }

  int semicirclesMinutesPortion() {
    final double fractionalDegrees = this * (180 / pow(2, 31));
    final int degrees = fractionalDegrees.floor();
    return ((fractionalDegrees - degrees) * 60).floor();
  }

  double semicirclesSecondsPortion() {
    final double fractionalDegrees = this * (180 / pow(2, 31));
    final int degrees = fractionalDegrees.floor();
    final int minutes = ((fractionalDegrees - degrees) * 60).floor();
    return (((fractionalDegrees - degrees) * 60) - minutes) * 60;
  }

  double setDegrees(int newDegrees) {
    final double fractionalDegrees = this * (180 / pow(2, 31));
    final double newFractionalDegrees =
        fractionalDegrees - fractionalDegrees.floor() + newDegrees;
    return newFractionalDegrees / (180 / pow(2, 31));
  }

  double setMinutes(int newMinutes) {
    final double fractionalDegrees = this * (180 / pow(2, 31));
    final int degrees = fractionalDegrees.floor();
    final int minutes = ((fractionalDegrees - degrees) * 60).floor();
    final double newFractionalDegrees =
        fractionalDegrees + (newMinutes - minutes) / 60;
    return newFractionalDegrees / (180 / pow(2, 31));
  }

  double setSeconds(double newSeconds) {
    final double fractionalDegrees = this * (180 / pow(2, 31));
    final int degrees = fractionalDegrees.floor();
    final int minutes = ((fractionalDegrees - degrees) * 60).floor();
    final double seconds =
        (((fractionalDegrees - degrees) * 60) - minutes) * 60;
    final double newFractionalDegrees =
        fractionalDegrees + (newSeconds - seconds) / 3600;
    return newFractionalDegrees / (180 / pow(2, 31));
  }
}
