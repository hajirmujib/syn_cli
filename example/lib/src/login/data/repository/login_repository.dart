import 'package:example/src/login/data/remote/responses/login_data_response.dart';

abstract class LoginRepository {
  FutureOrError<BaseResponse<LoginDataResponse>> loginData(
String username,
    String password);


  FutureOrError<BaseResponse<DetailUserResponse>> getDetailUser(
String userId);

}
