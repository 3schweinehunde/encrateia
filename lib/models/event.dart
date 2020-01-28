import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'activity.dart';
import 'dart:developer';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/plot_point.dart';

class Event {
  DbEvent db;
  Activity activity;
  int index;

  Event.fromDb(this.db);

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

  static Future<List<Event>> recordsByLap({Lap lap}) async {
    int firstRecordId = await lap.firstEventId();
    DbEvent lastRecord = await lap.db.getDbEvent();
    int lastRecordId = lastRecord.id;

    var events = await by(activity: lap.activity);
    var records = events.where((event) =>
        event.db.id < lastRecordId &&
        event.db.id > firstRecordId &&
        event.db.event == "record");

    return records.toList();
  }

  static Future<List<Event>> recordsByActivity({Activity activity}) async {
    var events = await by(activity: activity);
    var records = events.where((event) => event.db.event == "record");
    return records.toList();
  }

  static Future<List<Event>> by({Activity activity}) async {
    int counter = 1;

    List<DbEvent> dbEventList = await activity.db.getDbEvents().toList();
    var eventList = dbEventList.map((dbLap) => Event.fromDb(dbLap)).toList();

    for (Event event in eventList) {
      event.activity = activity;
      event.index = counter;
      counter = counter + 1;
    }

    return eventList;
  }

  static toIntDataPoints({
    Iterable<Event> records,
    int amount,
    @required String attribute,
  }) {
    int index = 0;
    List<IntPlotPoint> plotPoints = [];
    int sum = 0;

    for (var record in records) {
      switch (attribute) {
        case "power":
          sum = sum + record.db.power;
          break;
        case "heartRate":
          sum = sum + record.db.heartRate;
      }

      if (index++ % amount == amount - 1) {
        plotPoints.add(IntPlotPoint(
          domain: record.db.distance.round(),
          measure: (sum / amount).round(),
        ));
        sum = 0;
      }
    }

    return plotPoints;
  }

  static toDoubleDataPoints({
    Iterable<Event> records,
    int amount,
    @required String attribute,
  }) {
    int index = 0;
    List<DoublePlotPoint> plotPoints = [];
    double sum = 0.0;

    for (var record in records) {
      switch (attribute) {
        case "groundTime":
          sum = sum + record.db.groundTime;
          break;
        case "strydCadence":
          sum = sum + record.db.strydCadence;
          break;
        case "verticalOscillation":
          sum = sum + record.db.verticalOscillation;
          break;
        case "formPower":
          sum = sum + record.db.formPower;
          break;
        case "legSpringStiffness":
          sum = sum + record.db.legSpringStiffness;
      }

      if (index++ % amount == amount - 1) {
        plotPoints.add(DoublePlotPoint(
          domain: record.db.distance.round(),
          measure: sum / amount,
        ));
        sum = 0;
      }
    }

    return plotPoints;
  }
}
