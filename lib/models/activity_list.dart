import 'package:encrateia/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:collection/collection.dart';

class ActivityList<E> extends DelegatingList<E> {
  final List<Activity> _activities;

  ActivityList(activityList)
      : _activities = activityList,
        super(activityList);

  enrichGlidingAverage({
    @required int fullDecay,
    @required ActivityAttr activityAttr,
  }) {
    _activities.asMap().forEach((index, activity) {
      double sumOfAvg = activity.get(activityAttr: activityAttr) * fullDecay;
      double sumOfWeightings = fullDecay * 1.0;
      for (var olderIndex = index + 1;
          olderIndex < _activities.length;
          olderIndex++) {
        double daysAgo = activity.db.timeCreated
                .difference(_activities[olderIndex].db.timeCreated)
                .inHours /
            24;
        if (daysAgo > fullDecay) break;
        sumOfAvg += (fullDecay - daysAgo) *
            _activities[olderIndex].get(activityAttr: activityAttr);
        sumOfWeightings += (fullDecay - daysAgo);
      }

      activity.glidingMeasureAttribute = sumOfAvg / sumOfWeightings;
    });
  }
}
