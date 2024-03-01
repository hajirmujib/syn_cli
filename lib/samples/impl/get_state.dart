import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class StateSample extends Sample {
  final String _fileName;
  StateSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => flutterState;

  String get flutterState => '''

part of '${_fileName.toLowerCase()}_bloc.dart'; 

class ${_fileName.pascalCase}StateData extends Equatable {
  final ErrorDto? error;

  const ${_fileName.pascalCase}StateData({
  
    this.error,
  });

  @override
  List<Object?> get props => [error];

  ${_fileName.pascalCase}StateData copyWith({
    ErrorDto? error,
  }) {
    return ${_fileName.pascalCase}StateData(
     
      error: error ?? this.error,
    );
  }
}

abstract class ${_fileName.pascalCase}State extends Equatable {
  final ${_fileName.pascalCase}StateData data;

  const ${_fileName.pascalCase}State(this.data);

  @override
  List<Object> get props => [data];
}

class ${_fileName.pascalCase}InitialState extends ${_fileName.pascalCase}State {
  const ${_fileName.pascalCase}InitialState() : super(const ${_fileName.pascalCase}StateData());
}

class ${_fileName.pascalCase}LoadingState extends ${_fileName.pascalCase}State {
  const ${_fileName.pascalCase}LoadingState(super.data);
}

class ${_fileName.pascalCase}FailedState extends ${_fileName.pascalCase}State {
  const ${_fileName.pascalCase}FailedState(super.data);
}

class ${_fileName.pascalCase}SuccessState extends ${_fileName.pascalCase}State {
  const ${_fileName.pascalCase}SuccessState(super.data);
}

''';
}
