import 'package:recase/recase.dart';
import 'package:syn_cli/common/utils/pubspec/pubspec_utils.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class RepositoryImplSample extends Sample {
  final String _fileName;
  RepositoryImplSample(super.path, this._fileName, {super.overwrite});
  String import =
      '''import 'package:${PubspecUtils.projectName}/core/data/remote/responses/base_response.dart';
         import 'package:${PubspecUtils.projectName}/core/data/remote/responses/base_pagination_response.dart';
         import 'package:${PubspecUtils.projectName}/core/utils/future_util.dart';
         import 'package:${PubspecUtils.projectName}/core/utils/typedef_util.dart';
      ''';
  @override
  String get content => flutterRepository;

  String get flutterRepository => '''
import '../remote/services/${_fileName.toLowerCase()}_service.dart';
import '${_fileName.toLowerCase()}_repository.dart';
$import

class ${_fileName.pascalCase}RepositoryImpl extends ${_fileName.pascalCase}Repository {
  final ${_fileName.pascalCase}Service _${_fileName.replaceAll('_', '').toLowerCase()}Service;
  ${_fileName.pascalCase}RepositoryImpl(this._${_fileName.replaceAll('_', '').toLowerCase()}Service, );
  
}

''';
}
