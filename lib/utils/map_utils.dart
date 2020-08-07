extension StatisticFunctions on Map<DateTime, double> {
  double meanByTime() {
    double sumOfValues = 0;
    double sumOfWeights = 0;

    DateTime lastTimeStamp;

    forEach((DateTime timeStamp, double speed) {
      final int timeEvolved = lastTimeStamp != null
          ? timeStamp.difference(lastTimeStamp).inSeconds
          : 0;
      sumOfValues += timeEvolved * speed;
      sumOfWeights += timeEvolved;
      lastTimeStamp = timeStamp;
    });

    return sumOfValues / sumOfWeights;
  }

  double meanByDistance() {
    double sumOfValues = 0;
    double sumOfWeights = 0;

    DateTime lastTimeStamp;

    forEach((DateTime timeStamp, double speed) {
      final double distanceEvolved = (lastTimeStamp != null
              ? timeStamp.difference(lastTimeStamp).inSeconds
              : 0) *
          speed;
      sumOfValues += distanceEvolved * speed;
      sumOfWeights += distanceEvolved;
      lastTimeStamp = timeStamp;
    });

    return sumOfValues / sumOfWeights;
  }
}
