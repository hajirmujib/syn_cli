import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class ServicesSample extends Sample {
  final String _fileName;
  ServicesSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => flutterServices;

  String get flutterServices => '''

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part '${_fileName.toLowerCase()}_service.g.dart';

@RestApi()
abstract class ${_fileName.pascalCase}Service {
  factory ${_fileName.pascalCase}Service(Dio dio) => _${_fileName.pascalCase}Service(dio);

  //example services
 // @GET('training')
  // Future<BasePaginationResponse<List<CourseResponse>>> getCourseList({
  //   @Query('page') int? page = 1,
  //   @Query('limit') int? size = 10,
  //   @Query('search') String? keyword,
  //   @Query('type') String? type,
  //   @Query('mobile') String? mobile = '1',
  // });
}

''';
}
