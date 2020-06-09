import 'package:encrateia/model/model.dart' show DbEvent;
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
// ignore: implementation_imports
import 'package:fit_parser/src/value.dart';
import 'package:flutter/foundation.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class Event {
  Event({
    @required DataMessage dataMessage,
    @required this.activity,
  }) {
    if (dataMessage.any('max_heart_rate') != null) {
      activity
        ..maxHeartRate = (dataMessage.get('max_heart_rate') as double)?.round()
        ..save();
    } else if (dataMessage.values.any((Value value) =>
        value.fieldName == 'event_type' &&
        <String>['start', 'stop_all'].contains(value.value))) {
      _db = DbEvent()
        ..activitiesId = activity.id
        ..event = dataMessage.get('event') as String
        ..eventType = dataMessage.get('event_type') as String
        ..eventGroup = (dataMessage.get('event_group') as double)?.round()
        ..timerTrigger = dataMessage.get('timer_trigger') as String
        ..timeStamp =
            dateTimeFromStrava(dataMessage.get('timestamp') as double);
    } else if (dataMessage.values.any((Value value) =>
        value.fieldName == 'event_type' &&
        <String>['marker'].contains(value.value))) {
      _db = DbEvent()
        ..activitiesId = activity.id
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

  Event._fromDb(this._db);

  Event.fromRecord({
    @required DataMessage dataMessage,
    @required this.activity,
    @required int lapsId,
  }) {
    _db = DbEvent()
      ..activitiesId = activity.id
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
    _db = DbEvent()
      ..activitiesId = activity.id
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

  DbEvent _db;
  Activity activity;
  Lap lap;
  int index;

  int get id => _db?.id;
  DateTime get timeStamp => _db.timeStamp;
  String get event => _db.event;
  double get distance => _db.distance;
  double get groundTime => _db.groundTime;
  double get legSpringStiffness => _db.legSpringStiffness;
  double get positionLat => _db.positionLat;
  double get positionLong => _db.positionLong;
  double get speed => _db.speed;
  double get strydCadence => _db.strydCadence;
  double get verticalOscillation => _db.verticalOscillation;
  int get formPower => _db.formPower;
  int get heartRate => _db.heartRate;
  int get power => _db.power;

  set event(String value) => _db.event = value;

  @override
  String toString() => '< Event | $event | $index >';

  static Future<List<Event>> recordsByLap(Lap lap) async {
    final List<Event> events = await byLap(lap);
    final Iterable<Event> records =
        events.where((Event event) => event.event == 'record');
    return records.toList();
  }

  static Future<List<Event>> byLap(Lap lap) async {
    int counter = 1;
    final List<Event> events = await lap.events;

    for (final Event event in events) {
      event.lap = lap;
      event.index = counter;
      counter = counter + 1;
    }
    return events;
  }

  static Future<BoolCommitResult> upsertAll(List<Event> events) async {
    final List<DbEvent> dbEvents = events
        .where((Event event) => event._db != null)
        .map((Event event) => event._db)
        .toList();
    return await DbEvent().upsertAll(dbEvents);
  }

  static Event exDb(DbEvent dbEvent) => Event._fromDb(dbEvent);
}
