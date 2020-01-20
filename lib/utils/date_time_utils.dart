import 'dart:math';

dateTimeFromStrava(double dateTime) {
  return DateTime.fromMillisecondsSinceEpoch(
      // Strava's datetime offset: 31.12.1989, 00:00
      (dateTime.round() + 631065600) * 1000);
}

extension DurationFormatters on Duration {
  String print() {
    return inHours.toString() +
        "h " +
        inMinutes.remainder(60).toString() +
        "min " +
        inSeconds.remainder(60).toString() +
        "s";
  }
}

extension DegreeFormatters on double {
  String semicirclesAsDegrees() {
    if (this != null) {
      var fractionalDegrees = this * (180 / pow(2, 31));
      var degrees = fractionalDegrees.floor();
      var minutes = ((fractionalDegrees - degrees) * 60).floor();
      var seconds = (((fractionalDegrees - degrees) * 60) - minutes) * 60;

      return '$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
    } else {
      return "no value";
    }
  }

  String toPace() {
    if (this != null) {
       var totalSeconds = 1000 / this;
       var minutes = (totalSeconds / 60).floor();
       var seconds = (totalSeconds - minutes * 60).round();
       return "${minutes}min ${seconds}s";
    } else {
      return "no value";
    }
  }
}


