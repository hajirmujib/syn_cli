import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class DiSample extends Sample {
  final String _fileName;
  DiSample(super.path, this._fileName, {super.overwrite});

  @override
  String get content => flutterDi;

  String get flutterDi => '''
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../data/remote/services/${_fileName.toLowerCase()}_service.dart';
import '../data/repository/${_fileName.toLowerCase()}_repository.dart';
import '../data/repository/${_fileName.toLowerCase()}_repository_impl.dart';

@module
abstract class ${_fileName.pascalCase}DiModule {
  @singleton
  ${_fileName.pascalCase}Service ${_fileName.replaceAll('_', '').toLowerCase()}Service(Dio dio) => ${_fileName.pascalCase}Service(dio);

  @Singleton(as: ${_fileName.pascalCase}Repository)
  ${_fileName.pascalCase}RepositoryImpl get ${_fileName.replaceAll('_', '').toLowerCase()}Repository;
}

''';
}
