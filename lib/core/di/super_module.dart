import 'package:base_pkg/base_pkg.dart';

import '../data/remote/interceptors/auth_interceptor.dart';
import '../utils/date_time_util.dart';

@module
abstract class SuperModule {
  @singleton
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @Named('base_url')
  @singleton
  String get baseUrl => 'https://jsonplaceholder.typicode.com/';

  @singleton
  Dio dio(
      @Named('base_url') String baseUrl,
      AuthInterceptor authInterceptor,
      ) {
    var option = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: DateTimeUtil.thirtySeconds,
      sendTimeout: DateTimeUtil.thirtySeconds,
      receiveTimeout: DateTimeUtil.thirtySeconds,
    );

    var dio = Dio(option);
    dio.interceptors.add(authInterceptor);

    return dio;
  }
}