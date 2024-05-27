import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part 'example_service.g.dart';

@RestApi()
abstract class ExampleService {
  factory ExampleService(Dio dio) => _ExampleService(dio);

  //example services
  // @GET('training')
  // Future<BasePaginationResponse<List<CourseResponse>>> getCourseList({
  //   @Query('page') int? page = 1,
  //   @Query('limit') int? size = 10,
  //   @Query('search') String? keyword,
  //   @Query('type') String? type,
  //   @Query('mobile') String? mobile = '1',
  // });

  @GET('example/url')
  Future<BaseResponse<ExampleResponse>> getExample(
    @Query('example_id') String? exampleId,);


  @GET('example1/url')
  Future<BaseResponse<Example1Response>> getExample1(
);


  @GET('example2')
  Future<BaseResponse<Example2Response>> getExample2(
);


  @GET('example3')
  Future<BaseResponse<Example3Response>> getExample3(
);


  @GET('example1')
  Future<BaseResponse<Example1Response>> getExample(
);


  @GET('example1')
  Future<BaseResponse<Example1Response>> getExample(
);


  @GET('example1')
  Future<BaseResponse<Example1Response>> getExample(
);


  @GET('example1')
  Future<BaseResponse<Example1Response>> getExample(
);


  @GET('example1')
  Future<BaseResponse<Example1Response>> getExample(
);


  @GET('example')
  Future<BaseResponse<Example1Response>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<Example1Response>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('examples')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('examples')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('examples')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<FexampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('examples')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('contoh')
  Future<BaseResponse<ContohResponse>> getContoh(
);


  @GET('url')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExmaple(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('exam')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @PUT('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getEXample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);


  @GET('example')
  Future<BaseResponse<ExampleResponse>> getExample(
);

}
