import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class EventSample extends Sample {
  final String _fileName;
  EventSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => flutterEvent;

  String get flutterEvent => '''

part of '${_fileName.toLowerCase()}_bloc.dart'; 
  
abstract class ${_fileName.pascalCase}Event extends Equatable {
  const ${_fileName.pascalCase}Event();
}

class ${_fileName.pascalCase}InitEvent extends ${_fileName.pascalCase}Event {
  const ${_fileName.pascalCase}InitEvent();

  @override
  List<Object> get props => [];
}

''';
}
