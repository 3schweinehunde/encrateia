import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/utils/enums.dart';

class Event {
  DbEvent db;
  Activity activity;
  Lap lap;
  int index;

  Event.fromDb(this.db);

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

  static toIntDataPoints({
    Iterable<Event> records,
    int amount,
    @required LapIntAttr attribute,
  }) {
    int index = 0;
    List<IntPlotPoint> plotPoints = [];
    int sum = 0;

    for (var record in records) {
      switch (attribute) {
        case LapIntAttr.power:
          sum = sum + record.db.power;
          break;
        case LapIntAttr.formPower:
          sum = sum + record.db.formPower;
          break;
        case LapIntAttr.heartRate:
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
    @required LapDoubleAttr attribute,
    double weight
  }) {
    int index = 0;
    List<DoublePlotPoint> plotPoints = [];
    double sum = 0.0;

    for (var record in records) {
      switch (attribute) {
        case LapDoubleAttr.powerPerHeartRate:
          sum = sum + (record.db.power / record.db.heartRate);
          break;
        case LapDoubleAttr.speedPerHeartRate:
          sum = sum + 100 * (record.db.speed / record.db.heartRate);
          break;
        case LapDoubleAttr.groundTime:
          sum = sum + record.db.groundTime;
          break;
        case LapDoubleAttr.strydCadence:
          sum = sum + 2 * record.db.strydCadence;
          break;
        case LapDoubleAttr.verticalOscillation:
          sum = sum + record.db.verticalOscillation;
          break;
        case LapDoubleAttr.legSpringStiffness:
          sum = sum + record.db.legSpringStiffness;
          break;
        case LapDoubleAttr.powerRatio:
          sum = sum +
              ((record.db.power - record.db.formPower) / record.db.power * 100);
          break;
        case LapDoubleAttr.strideRatio:
          sum = sum +
              (10000 /
                  6 *
                  record.db.speed /
                  record.db.strydCadence /
                  record.db.verticalOscillation);
          break;
        case LapDoubleAttr.ecor:
          sum = sum + (record.db.power / record.db.speed / weight);
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
