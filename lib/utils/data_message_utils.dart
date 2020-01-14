import 'package:fit_parser/fit_parser.dart';

extension DataMessageUtils on DataMessage {
  get(String fieldName) {
    return values.singleWhere((value) => value.fieldName == fieldName).value;
  }

  any(String fieldName) {
    return values.any((value) => value.fieldName == fieldName);
  }
}
