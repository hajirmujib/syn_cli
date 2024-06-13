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
      connectTimeout: const Duration(seconds: DateTimeUtil.fifteenSeconds),
      sendTimeout: const Duration(seconds: DateTimeUtil.fifteenSeconds),
      receiveTimeout: const Duration(seconds: DateTimeUtil.fifteenSeconds),
    );

    var dio = Dio(option);
    dio.interceptors.add(authInterceptor);

    return dio;
  }
}
