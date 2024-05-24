import 'package:dio/dio.dart' hide Headers;
import 'package:example/src/login/data/remote/responses/login_data_response.dart';
import 'package:retrofit/http.dart';

part 'login_service.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio) => _LoginService(dio);

  //example services
  // @GET('training')
  // Future<BasePaginationResponse<List<CourseResponse>>> getCourseList({
  //   @Query('page') int? page = 1,
  //   @Query('limit') int? size = 10,
  //   @Query('search') String? keyword,
  //   @Query('type') String? type,
  //   @Query('mobile') String? mobile = '1',
  // });

  @POST('auth/login')
  Future<BaseResponse<LoginDataResponse>> loginData(
    @Query('username') String? username,
    @Query('password') String? password,);


  @GET('user/detail')
  Future<BaseResponse<DetailUserResponse>> getDetailUser(
    @Query('user_id') String? userId,);

}
