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

  double get sem2deg => this * 180 / pow(2, 31);
  double get deg2sem => this / 180 * pow(2, 31);

  int get fullDegrees => sem2deg.floor();
  int get fullMinutes => (sem2deg % 1 * 60).floor();
  double get seconds => sem2deg * 3600 % 60;

  double setDegrees(int newDegrees) =>
      (sem2deg - fullDegrees + newDegrees).deg2sem;

  double setMinutes(int newMinutes) =>
      (sem2deg + (newMinutes - fullMinutes) / 60).deg2sem;

  double setSeconds(double newSeconds) =>
      (sem2deg + (newSeconds - seconds) / 3600).deg2sem;
}

extension MovingTimeFormatters on int {
  int get fullHours => this ~/ 3600;
  int get fullMinutes => (this - this % 60) ~/ 60 % 60;
  int get fullSeconds => this % 60;

  int setHours(int newHours) => this + (newHours - fullHours) * 3600;
  int setMinutes(int newMinutes) => this + (newMinutes - fullMinutes) * 60;
  int setSeconds(int newSeconds) => this + (newSeconds - fullSeconds);
}
