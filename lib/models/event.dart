import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/utils/data_message_utils.dart';
import 'activity.dart';
import 'dart:developer';

class Event {
  DbEvent db;
  Activity activity;

  Event({DataMessage dataMessage, this.activity}) {
    if (dataMessage.any('max_heart_rate')) {
      activity.db
        ..maxHeartRate = dataMessage.get('max_heart_rate').round()
        ..save();
      return;
    }

    if (dataMessage.values.any(
        (value) => value.fieldName == 'event_type' && value.value == 'start')) {
      db = DbEvent()
        ..event = dataMessage.get('event')
        ..eventType = dataMessage.get('event_type')
        ..eventGroup = dataMessage.get('event_group').round()
        ..timerTrigger = dataMessage.get('timer_trigger')
        ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
        ..save();
      return;
    }

    debugger();
  }
}
