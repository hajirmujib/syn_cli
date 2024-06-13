import 'package:base_pkg/base_pkg.dart';
import 'package:bloc_skeleton/core/data/local/app_preferences.dart';

@module
abstract class LocalModule {
  @singleton
  AppPreferences appPreferences(SharedPreferences prefs) =>
      AppPreferences(prefs);
}
