import 'package:bloc_skeleton/core/data/remote/interceptors/auth_interceptor.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @singleton
  AuthInterceptor get authInterceptor => AuthInterceptor();
}
