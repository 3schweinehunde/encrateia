import 'package:encrateia/model/model.dart';

class Db {
  static Db _dB;
  static bool _isConnected = false;

  factory Db() {
    if (_dB == null) _dB = Db();
    return _dB;
  }

  connect() async {
    if (_isConnected == false)
      _isConnected = await DbEncrateia().initializeDB();
    return _isConnected;
  }
}
