import 'package:encrateia/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/enums.dart';

class ActivityList {
  List<Activity> activities = [];

  ActivityList({this.activities});

  enrichGlidingAverage({
    @required int fullDecay,
    @required ActivityAttr quantity,
  }) {
    activities.asMap().forEach((index, activity) {
      double sumOfAvg = activity.get(quantity: quantity) * fullDecay;
      double sumOfWeightings = fullDecay * 1.0;
      for (var olderIndex = index + 1;
          olderIndex < activities.length;
          olderIndex++) {
        double daysAgo = activity.db.timeCreated
                .difference(activities[olderIndex].db.timeCreated)
                .inHours /
            24;
        if (daysAgo > fullDecay) break;
        sumOfAvg += (fullDecay - daysAgo) *
            activities[olderIndex].get(quantity: quantity);
        sumOfWeightings += (fullDecay - daysAgo);
      }

      activity.setGliding(
        quantity: quantity,
        value: sumOfAvg / sumOfWeightings,
      );
    });
  }
}
