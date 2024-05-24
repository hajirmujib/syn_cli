import 'package:example/src/login/data/remote/responses/login_data_response.dart';

import '../remote/services/login_service.dart';
import 'login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginService _loginService;
  LoginRepositoryImpl(
    this._loginService,
  );

  @override
  FutureOrError<BaseResponse<LoginDataResponse>> loginData(
      String username, String password) {
    return callOrError(() => _loginService.loginData(username, password));
  }

  @override
  FutureOrError<BaseResponse<DetailUserResponse>> getDetailUser(
String userId){
    return callOrError(() => _loginService.getDetailUser(
      userId));
  }

}
