import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'activity.dart';
import 'dart:developer';

class Event {
  DbEvent db;
  Activity activity;

  Event({DataMessage dataMessage, this.activity}) {
    if (dataMessage.values
        .any((value) => value.fieldName == 'max_heart_rate')) {
      activity.db
        ..maxHeartRate = dataMessage.values
            .singleWhere((value) => value.fieldName == 'max_heart_rate')
            .value
            .round()
        ..save();
      return;
    }

    if (dataMessage.values.any(
        (value) => value.fieldName == 'event_type' && value.value == 'start')) {
      db = DbEvent()
        ..event = dataMessage.values
            .singleWhere((value) => value.fieldName == 'event')
            .value
        ..eventType = dataMessage.values
            .singleWhere((value) => value.fieldName == 'event_type')
            .value
        ..eventGroup = dataMessage.values
            .singleWhere((value) => value.fieldName == 'event_group')
            .value
            .round()
        ..timerTrigger = dataMessage.values
            .singleWhere((value) => value.fieldName == 'timer_trigger')
            .value
        ..timeStamp = dateTimeFromStrava(dataMessage.values
            .singleWhere((value) => value.fieldName == 'timestamp')
            .value)
        ..save();
      return;
    }

    debugger();
  }
}
