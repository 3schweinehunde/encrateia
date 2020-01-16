dateTimeFromStrava(double dateTime) {
  return DateTime.fromMillisecondsSinceEpoch(
      // Strava's datetime offset: 31.12.1989, 00:00
      (dateTime.round() + 631065600) * 1000);
}

extension DurationFormatters on Duration {
  String print() {
    return "$inHours h ${inMinutes.remainder(60)} min ${inSeconds.remainder(60)} s";
  }
}
