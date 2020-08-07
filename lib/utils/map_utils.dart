extension StatisticFunctions on Map<DateTime, double> {
  double meanWeightedOverTime() {
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

  double meanWeightedOverDistance() {
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

  double meanUsingDistance() {
    double sumOfValues = 0;
    double sumOfWeights = 0;

    DateTime lastTimeStamp;
    double lastDistance;

    forEach((DateTime timeStamp, double distance) {
      final int timeEvolved = lastTimeStamp != null
          ? timeStamp.difference(lastTimeStamp).inSeconds
          : 0;
      final double distanceEvolved = lastDistance != null
          ? distance - lastDistance
          : 0;
      sumOfValues += distanceEvolved;
      sumOfWeights += timeEvolved;
      lastTimeStamp = timeStamp;
      lastDistance = distance;
    });

    return sumOfValues / sumOfWeights;
  }

  double meanUsingSpeed() {
    double sumOfValues = 0;
    double sumOfWeights = 0;

    DateTime lastTimeStamp;

    forEach((DateTime timeStamp, double speed) {
      final int timeEvolved = lastTimeStamp != null
          ? timeStamp.difference(lastTimeStamp).inSeconds
          : 0;
      sumOfValues += (speed ?? 0) * timeEvolved;
      sumOfWeights += timeEvolved;
      lastTimeStamp = timeStamp;
    });

    return sumOfValues / sumOfWeights;
  }

}
