import 'package:base_pkg/base_pkg.dart';
import 'package:bloc_skeleton/core/utils/pref_extension.dart';

class AppPreferences {

  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<bool> setToken(String? token) {
    return _sharedPreferences.setStringOrClear(_keyToken, token);
  }

  String? getToken() {
    return _sharedPreferences.getString(_keyToken);
  }

  /// Preferences Keys
  static const String _keyToken = 'token';
}
