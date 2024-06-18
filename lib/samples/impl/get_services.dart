import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class ServicesSample extends Sample {
  final String _fileName;
  ServicesSample(super.path, this._fileName, {super.overwrite});

  @override
  String get content => flutterServices;

  String get flutterServices => '''
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part '${_fileName.toLowerCase()}_service.g.dart';

@RestApi()
abstract class ${_fileName.pascalCase}Service {
  factory ${_fileName.pascalCase}Service(Dio dio) => _${_fileName.pascalCase}Service(dio);

}

''';
}
