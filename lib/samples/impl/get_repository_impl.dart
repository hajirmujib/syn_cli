import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class RepositoryImplSample extends Sample {
  final String _fileName;
  RepositoryImplSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => flutterRepository;

  String get flutterRepository => '''
import '../remote/services/${_fileName.toLowerCase()}_service.dart';
import '${_fileName.toLowerCase()}_repository.dart';

class ${_fileName.pascalCase}RepositoryImpl extends ${_fileName.pascalCase}Repository {
  final ${_fileName.pascalCase}Service _${_fileName.toLowerCase()}Service;
  ${_fileName.pascalCase}RepositoryImpl(this._${_fileName.toLowerCase()}Service, );
  
}

''';
}
