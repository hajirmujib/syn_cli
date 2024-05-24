import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../data/remote/services/login_service.dart';
import '../data/repository/login_repository.dart';
import '../data/repository/login_repository_impl.dart';

@module
abstract class LoginDiModule {
  @singleton
  LoginService loginService(Dio dio) => LoginService(dio);

  @Singleton(as: LoginRepository)
  LoginRepositoryImpl get loginRepository;
}
