import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/utils/data_message_utils.dart';
import 'activity.dart';

class Lap {
  DbLap db;
  Activity activity;

  Lap({DataMessage dataMessage, this.activity, int eventId})
  {
    db = DbLap()

      ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
      ..startTime = dateTimeFromStrava(dataMessage.get('start_time'))
      ..startPositionLat = dataMessage.get('start_position_lat')
      ..startPositionLong = dataMessage.get('start_position_long')
      ..endPositionLong = dataMessage.get('end_position_lat')
      ..startPositionLat = dataMessage.get('end_position_long')
      ..save();
    return;
  }
}

// total_elapsed_time, total_timer_time, total_distance, total_strides,
// unknown, unknown, unknown, unknown, message_index, total_calories, avg_speed, max_speed, total_ascent, total_descent, wkt_step_index, avg_vertical_oscillation,
// avg_stance_time_percent, avg_stance_time, event, event_type, avg_heart_rate, max_heart_rate, avg_running_cadence, max_running_cadence, intensity, lap_trigger, sport,
// event_group, sub_sport, avg_temperature, max_temperature, unknown, avg_fractional_cadence, max_fractional_cadence, total_fractional_cycles

//SqfEntityField('avgHeartRate', DbType.integer),
//SqfEntityField('maxHeartRate', DbType.integer),
//SqfEntityField('avgRunningCadence', DbType.real),
//SqfEntityField('event', DbType.text),
//SqfEntityField('eventType', DbType.text),
//SqfEntityField('eventGroup', DbType.integer),
//SqfEntityField('sport', DbType.text),
//SqfEntityField('subSport', DbType.text),
//SqfEntityField('avgVerticalOscillation', DbType.real),
//SqfEntityField('totalElapsedTime', DbType.integer),
//SqfEntityField('totalTimerTime', DbType.integer),
//SqfEntityField('totalDistance', DbType.integer),
//SqfEntityField('totalStrides', DbType.integer),
//SqfEntityField('totalCalories', DbType.integer),
//SqfEntityField('avgSpeed', DbType.real),
//SqfEntityField('maxSpeed', DbType.real),
//SqfEntityField('totalAscent', DbType.integer),
//SqfEntityField('totalDescent', DbType.integer),
//SqfEntityField('avgStanceTimePercent', DbType.real),
//SqfEntityField('avgStanceTime', DbType.real),
//SqfEntityField('maxRunningCadence', DbType.integer),
//SqfEntityField('intensity', DbType.integer),
//SqfEntityField('lapTrigger', DbType.text),
//SqfEntityField('avgTemperature', DbType.integer),
//SqfEntityField('maxTemperature', DbType.integer),
//SqfEntityField('avgFractionalCadence', DbType.real),
//SqfEntityField('maxFractionalCadence', DbType.real),
//SqfEntityField('totalFractionalCycles', DbType.real),
