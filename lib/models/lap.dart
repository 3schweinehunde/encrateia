import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'activity.dart';

class Lap {
  DbLap db;
  Activity activity;
  int index;

  Lap({DataMessage dataMessage, this.activity, int eventId}) {
    db = DbLap()
      ..activitiesId = activity.db.id
      ..eventsId = eventId
      ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
      ..startTime = dateTimeFromStrava(dataMessage.get('start_time'))
      ..startPositionLat = dataMessage.get('start_position_lat')
      ..startPositionLong = dataMessage.get('start_position_long')
      ..endPositionLong = dataMessage.get('end_position_lat')
      ..startPositionLat = dataMessage.get('end_position_long')
      ..avgHeartRate = dataMessage.get('avg_heart_rate')?.round()
      ..maxHeartRate = dataMessage.get('max_heart_rate')?.round()
      ..avgRunningCadence = dataMessage.get('avg_running_cadence')
      ..event = dataMessage.get('event')
      ..eventType = dataMessage.get('event_type')
      ..eventGroup = dataMessage.get('event_group')?.round()
      ..sport = dataMessage.get('sport')
      ..subSport = dataMessage.get('sub_sport')
      ..avgVerticalOscillation = dataMessage.get('avg_vertical_oscillation')
      ..totalElapsedTime = dataMessage.get('total_elapsed_time')?.round()
      ..totalTimerTime = dataMessage.get('total_timer_time')?.round()
      ..totalDistance = dataMessage.get('total_distance')?.round()
      ..totalStrides = dataMessage.get('total_strides')?.round()
      ..totalCalories = dataMessage.get('total_calories')?.round()
      ..avgSpeed = dataMessage.get('avg_speed')
      ..maxSpeed = dataMessage.get('max_speed')
      ..totalAscent = dataMessage.get('total_ascent')?.round()
      ..totalDescent = dataMessage.get('total_descent')?.round()
      ..avgStanceTimePercent = dataMessage.get('avg_stance_time_percent')
      ..avgStanceTime = dataMessage.get('avg_stance_time')
      ..maxRunningCadence = dataMessage.get('max_running_cadence')?.round()
      ..intensity = dataMessage.get('intensity')?.round()
      ..lapTrigger = dataMessage.get('lap_trigger')
      ..avgTemperature = dataMessage.get('avg_temperature')?.round()
      ..maxTemperature = dataMessage.get('max_temperature')?.round()
      ..avgFractionalCadence = dataMessage.get('avg_fractional_cadence')
      ..maxFractionalCadence = dataMessage.get('max_fractional_cadence')
      ..totalFractionalCycles = dataMessage.get('total_fractional_cycles')
      ..save();
  }
  Lap.fromDb(this.db);

  static Future<List<Lap>> by({Activity activity}) async {
    int counter = 1;

    List<DbLap> dbLapList = await activity.db.getDbLaps().toList();
    var lapList = dbLapList.map((dbLap) => Lap.fromDb(dbLap)).toList();

    await Future.forEach(lapList, (lap) async {
      var dbActivity = await lap.db.getDbActivity();
      lap.activity = Activity.fromDb(dbActivity);
      lap.index = counter;
      counter = counter +1;
    });

    return lapList;
  }
}
