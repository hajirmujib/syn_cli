import 'package:base_pkg/base_pkg.dart';
import 'package:bloc_skeleton/core/data/remote/interceptors/auth_interceptor.dart';


@module
abstract class NetworkModule {
  @singleton
  AuthInterceptor get authInterceptor => AuthInterceptor();
}
