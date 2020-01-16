import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'activity.dart';
import 'dart:developer';

class Event {
  DbEvent db;
  Activity activity;

  Event({DataMessage dataMessage, this.activity}) {
    if (dataMessage.any('max_heart_rate')) {
      activity.db
        ..maxHeartRate = dataMessage.get('max_heart_rate')?.round()
        ..save();
    } else if (dataMessage.values.any((value) =>
        value.fieldName == 'event_type' &&
        ['start', 'stop_all'].contains(value.value))) {
      db = DbEvent()
        ..activitiesId = activity.db.id
        ..event = dataMessage.get('event')
        ..eventType = dataMessage.get('event_type')
        ..eventGroup = dataMessage.get('event_group')?.round()
        ..timerTrigger = dataMessage.get('timer_trigger')
        ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
        ..save();
    } else if (dataMessage.values.any((value) =>
        value.fieldName == 'event_type' && ['marker'].contains(value.value))) {
      db = DbEvent()
        ..activitiesId = activity.db.id
        ..event = dataMessage.get('event')?.toString()
        ..eventType = dataMessage.get('event_type')
        ..eventGroup = dataMessage.get('event_group')?.round()
        ..data = dataMessage.get('data')
        ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
        ..save();
    } else {
      debugger();
    }
  }

  Event.fromRecord({DataMessage dataMessage, this.activity}) {
    db = DbEvent()
      ..activitiesId = activity.db.id
      ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
      ..positionLat = dataMessage.get('position_lat')
      ..positionLong = dataMessage.get('position_long')
      ..distance = dataMessage.get('distance')
      ..altitude = dataMessage.get('altitude')
      ..speed = dataMessage.get('speed')
      ..heartRate = dataMessage.get('heart_rate')?.round()
      ..cadence = dataMessage.get('cadence')
      ..fractionalCadence = dataMessage.get('fractional_cadence')
      ..power = dataMessage.get('Power')?.round()
      ..strydCadence = dataMessage.get('Cadence')
      ..groundTime = dataMessage.get('Ground Time')
      ..verticalOscillation = dataMessage.get('Vertical Oscillation')
      ..formPower = dataMessage.get('Form Power')?.round()
      ..legSpringStiffness = dataMessage.get('Leg Spring Stiffness')
      ..save();
  }

  Event.fromLap({DataMessage dataMessage, this.activity}) {
    db = DbEvent()
      ..activitiesId = activity.db.id
      ..positionLat = dataMessage.get('end_position_lat')
      ..positionLong = dataMessage.get('end_position_long')
      ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
      ..event = dataMessage.get('event')?.toString()
      ..eventType = dataMessage.get('event_type')
      ..eventGroup = dataMessage.get('event_group')?.round()
      ..speed = dataMessage.get('avg_speed')
      ..verticalOscillation = dataMessage.get('avg_vertical_oscillation')
      ..fractionalCadence = dataMessage.get('avg_fractional_cadence')
      ..heartRate = dataMessage.get('avg_heart_rate')?.round()
      ..cadence = dataMessage.get('avg_running_cadence')
      ..timerTrigger = dataMessage.get('lap_trigger')
      ..distance = dataMessage.get('total_distance')
      ..save();
  }
}
