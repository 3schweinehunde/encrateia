import 'package:encrateia/model/model.dart';

class Db {
  Db();

  factory Db.create() {
    _dB ??= Db();
    return _dB;
  }

  static Db _dB;
  static bool _isConnected = false;

  Future<bool> connect() async {
    if (_isConnected == false)
      _isConnected = await DbEncrateia().initializeDB();
    return _isConnected;
  }
}
