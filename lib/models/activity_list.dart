import 'package:encrateia/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:collection/collection.dart';

class ActivityList<E> extends DelegatingList<E> {
  ActivityList(List<E> activities)
      : _activities = activities as List<Activity>,
        super(activities);

  final List<Activity> _activities;

  void enrichGlidingAverage({
    @required int fullDecay,
    @required ActivityAttr activityAttr,
  }) {
    _activities.asMap().forEach((int index, Activity activity) {
      double sumOfAvg =
          (activity.getAttribute(activityAttr) as double) * fullDecay;
      double sumOfWeightings = fullDecay * 1.0;
      for (int olderIndex = index + 1;
          olderIndex < _activities.length;
          olderIndex++) {
        final double daysAgo = activity.db.timeCreated
                .difference(_activities[olderIndex].db.timeCreated)
                .inHours /
            24;
        if (daysAgo > fullDecay)
          break;
        sumOfAvg += (fullDecay - daysAgo) *
            (_activities[olderIndex].getAttribute(activityAttr) as num);
        sumOfWeightings += fullDecay - daysAgo;
      }

      activity.glidingMeasureAttribute = sumOfAvg / sumOfWeightings;
    });
  }
}
