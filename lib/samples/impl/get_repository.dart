import 'package:recase/recase.dart';
import 'package:syn_cli/common/utils/pubspec/pubspec_utils.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class RepositorySample extends Sample {
  final String _fileName;
  RepositorySample(super.path, this._fileName, {super.overwrite});
  String import =
      '''import 'package:${PubspecUtils.projectName}/core/data/remote/responses/base_response.dart';
         import 'package:${PubspecUtils.projectName}/core/data/remote/responses/base_pagination_response.dart';
         import 'package:${PubspecUtils.projectName}/core/utils/typedef_util.dart';
      ''';
  @override
  String get content => flutterRepository;

  String get flutterRepository => '''
$import
abstract class ${_fileName.pascalCase}Repository {
  
}


''';
}
