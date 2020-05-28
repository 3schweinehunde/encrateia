import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
// ignore: implementation_imports
import 'package:fit_parser/src/value.dart';
import 'package:flutter/foundation.dart';

class Event {
  Event({
    @required DataMessage dataMessage,
    @required this.activity,
  }) {
    if (dataMessage.any('max_heart_rate') != null) {
      activity.db
        ..maxHeartRate = (dataMessage.get('max_heart_rate') as double)?.round()
        ..save();
    } else if (dataMessage.values.any((Value value) =>
        value.fieldName == 'event_type' &&
        <String> ['start', 'stop_all'].contains(value.value))) {
      db = DbEvent()
        ..activitiesId = activity.db.id
        ..event = dataMessage.get('event') as String
        ..eventType = dataMessage.get('event_type') as String
        ..eventGroup = (dataMessage.get('event_group') as double)?.round()
        ..timerTrigger = dataMessage.get('timer_trigger') as String
        ..timeStamp =
            dateTimeFromStrava(dataMessage.get('timestamp') as double);
    } else if (dataMessage.values.any((Value value) =>
        value.fieldName == 'event_type' && <String> ['marker'].contains(value.value))) {
      db = DbEvent()
        ..activitiesId = activity.db.id
        ..event = dataMessage.get('event')?.toString()
        ..eventType = dataMessage.get('event_type') as String
        ..eventGroup = (dataMessage.get('event_group') as double)?.round()
        ..data = dataMessage.get('data') as double
        ..timeStamp =
            dateTimeFromStrava(dataMessage.get('timestamp') as double);
    } else {
      // Use this debugger to include new event messages, such as heart rate alerts, ...
      // debugger();
    }
  }

  Event.fromDb(this.db);

  Event.fromRecord({
    @required DataMessage dataMessage,
    @required this.activity,
    @required int lapsId,
  }) {
    db = DbEvent()
      ..activitiesId = activity.db.id
      ..lapsId = lapsId
      ..event = 'record'
      ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp') as double)
      ..positionLat = dataMessage.get('position_lat') as double
      ..positionLong = dataMessage.get('position_long') as double
      ..distance = dataMessage.get('distance') as double
      ..altitude = dataMessage.get('altitude') as double
      ..speed = dataMessage.get('speed') as double
      ..heartRate = (dataMessage.get('heart_rate') as double)?.round()
      ..cadence = dataMessage.get('cadence') as double
      ..fractionalCadence = dataMessage.get('fractional_cadence') as double
      ..power = (dataMessage.get('Power') as double)?.round()
      ..strydCadence = dataMessage.get('Cadence') as double
      ..groundTime = dataMessage.get('Ground Time') as double
      ..verticalOscillation = dataMessage.get('Vertical Oscillation') as double
      ..formPower = (dataMessage.get('Form Power') as double)?.round()
      ..legSpringStiffness = dataMessage.get('Leg Spring Stiffness') as double;
  }

  Event.fromLap({
    @required DataMessage dataMessage,
    @required this.activity,
    @required int lapsId,
  }) {
    db = DbEvent()
      ..activitiesId = activity.db.id
      ..lapsId = lapsId
      ..positionLat = dataMessage.get('end_position_lat') as double
      ..positionLong = dataMessage.get('end_position_long') as double
      ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp') as double)
      ..event = dataMessage.get('event')?.toString()
      ..eventType = dataMessage.get('event_type') as String
      ..eventGroup = (dataMessage.get('event_group') as double)?.round()
      ..speed = dataMessage.get('avg_speed') as double
      ..verticalOscillation =
          dataMessage.get('avg_vertical_oscillation') as double
      ..fractionalCadence = dataMessage.get('avg_fractional_cadence') as double
      ..heartRate = (dataMessage.get('avg_heart_rate') as double)?.round()
      ..cadence = dataMessage.get('avg_running_cadence') as double
      ..timerTrigger = dataMessage.get('lap_trigger') as String
      ..distance = dataMessage.get('total_distance') as double;
  }

  DbEvent db;
  Activity activity;
  Lap lap;
  int index;

  @override
  String toString() => '< Event | ${db.event} | $index >';

  static Future<List<Event>> recordsByLap({Lap lap}) async {
    final List<Event> events = await byLap(lap: lap);
    final Iterable<Event> records =
        events.where((Event event) => event.db.event == 'record');
    return records.toList();
  }

  static Future<List<Event>> recordsByActivity({Activity activity}) async {
    final List<Event> events = await by(activity: activity);
    final Iterable<Event> records =
        events.where((Event event) => event.db.event == 'record');
    return records.toList();
  }

  static Future<List<Event>> byLap({Lap lap}) async {
    int counter = 1;

    final List<DbEvent> dbEventList = await lap.db.getDbEvents().toList();
    final List<Event> eventList =
        dbEventList.map((DbEvent dbEvent) => Event.fromDb(dbEvent)).toList();

    for (final Event event in eventList) {
      event.lap = lap;
      event.index = counter;
      counter = counter + 1;
    }
    return eventList;
  }

  static Future<List<Event>> by({Activity activity}) async {
    int counter = 1;

    final List<DbEvent> dbEventList = await activity.db.getDbEvents().toList();
    final List<Event> eventList =
        dbEventList.map((DbEvent dbEvent) => Event.fromDb(dbEvent)).toList();

    for (final Event event in eventList) {
      event.activity = activity;
      event.index = counter;
      counter = counter + 1;
    }
    return eventList;
  }
}
