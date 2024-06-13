import 'package:base_pkg/base_pkg.dart';
import 'package:base_pkg/base_pkg_duplicate.dart';
import 'package:bloc_skeleton/src/example/data/remote/responses/post_response.dart';

part 'example_service.g.dart';

@RestApi()
abstract class ExampleService {
  factory ExampleService(Dio dio) => _ExampleService(dio);

  @GET('/posts')
  Future<List<PostResponse>> getPosts();
}
