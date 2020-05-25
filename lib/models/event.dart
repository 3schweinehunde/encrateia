import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
import 'package:flutter/foundation.dart';

class Event {
  DbEvent db;
  Activity activity;
  Lap lap;
  int index;

  Event.fromDb(this.db);

  String toString() => '< Event | {$db.event} | $index >';

  Event({
    @required DataMessage dataMessage,
    @required this.activity,
  }) {
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
        ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'));
    } else if (dataMessage.values.any((value) =>
        value.fieldName == 'event_type' && ['marker'].contains(value.value))) {
      db = DbEvent()
        ..activitiesId = activity.db.id
        ..event = dataMessage.get('event')?.toString()
        ..eventType = dataMessage.get('event_type')
        ..eventGroup = dataMessage.get('event_group')?.round()
        ..data = dataMessage.get('data')
        ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'));
    } else {
      // Use this debugger to include new event messages, such as heart rate alerts, ...
      // debugger();
    }
  }

  Event.fromRecord({
    @required DataMessage dataMessage,
    @required this.activity,
    @required int lapsId,
  }) {
    db = DbEvent()
      ..activitiesId = activity.db.id
      ..lapsId = lapsId
      ..event = "record"
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
      ..legSpringStiffness = dataMessage.get('Leg Spring Stiffness');
  }

  Event.fromLap({
    @required DataMessage dataMessage,
    @required this.activity,
    @required int lapsId,
  }) {
    db = DbEvent()
      ..activitiesId = activity.db.id
      ..lapsId = lapsId
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
      ..distance = dataMessage.get('total_distance');
  }

  static Future<List<Event>> recordsByLap({Lap lap}) async {
    var events = await byLap(lap: lap);
    var records = events.where((event) => event.db.event == "record");
    return records.toList();
  }

  static Future<List<Event>> recordsByActivity({Activity activity}) async {
    var events = await by(activity: activity);
    var records = events.where((event) => event.db.event == "record");
    return records.toList();
  }

  static Future<List<Event>> byLap({Lap lap}) async {
    int counter = 1;

    List<DbEvent> dbEventList = await lap.db.getDbEvents().toList();
    var eventList =
        dbEventList.map((dbEvent) => Event.fromDb(dbEvent)).toList();

    for (Event event in eventList) {
      event.lap = lap;
      event.index = counter;
      counter = counter + 1;
    }

    return eventList;
  }

  static Future<List<Event>> by({Activity activity}) async {
    int counter = 1;

    List<DbEvent> dbEventList = await activity.db.getDbEvents().toList();
    var eventList =
        dbEventList.map((dbEvent) => Event.fromDb(dbEvent)).toList();

    for (Event event in eventList) {
      event.activity = activity;
      event.index = counter;
      counter = counter + 1;
    }

    return eventList;
  }
}
