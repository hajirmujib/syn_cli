import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class BlocSample extends Sample {
  final String _fileName;
  final bool _isServer;
  BlocSample(String path, this._fileName, this._isServer,
      {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => flutterController;

  String get flutterController => '''import 'package:bloc/bloc.dart';

class ${_fileName.pascalCase}Controller extends Bloc<${_fileName.pascalCase}Event, ${_fileName.pascalCase}State> {
  //TODO: Implement ${_fileName.pascalCase}Controller
  
  var stateData = const ${_fileName.pascalCase}StateData();

  ${_fileName.pascalCase}Bloc()
      : super(const ${_fileName.pascalCase}InitialState()) {
    on<${_fileName.pascalCase}InitEvent>(_onInit);
   
  }
  
   void _onInit(
    ${_fileName.pascalCase}Event event,
    Emitter<${_fileName.pascalCase}State> emit,
  ) {
   

    emit(const ${_fileName.pascalCase}InitialState());
  }


}
''';
}
