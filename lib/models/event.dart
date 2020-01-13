import 'package:encrateia/model/model.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:encrateia/utils/date_time_utils.dart';

class Event {
  DbEvent db;

  Event(DataMessage dataMessage) {
    db = DbEvent()
      ..event = dataMessage.values
          .firstWhere((value) => value.fieldName == 'event')
          .value
      ..eventType = dataMessage.values
          .firstWhere((value) => value.fieldName == 'event_type')
          .value
      ..eventGroup = dataMessage.values
          .firstWhere((value) => value.fieldName == 'event_group')
          .value.round()
      ..timerTrigger = dataMessage.values
          .firstWhere((value) => value.fieldName == 'timer_trigger')
          .value
      ..timeStamp = dateTimeFromStrava(dataMessage.values
          .firstWhere((value) => value.fieldName == 'timestamp')
          .value)
      ..save();
  }
}
