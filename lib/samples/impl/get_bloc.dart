import 'package:recase/recase.dart';
import 'package:syn_cli/common/utils/pubspec/pubspec_utils.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class BlocSample extends Sample {
  final String _fileName;
  BlocSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => flutterBloc;

  String get flutterBloc => '''import 'package:bloc/bloc.dart';
import 'package:${PubspecUtils.projectName}/core/domain/models/error_dto.dart';
import 'package:equatable/equatable.dart';

part '${_fileName.toLowerCase()}_event.dart'; 
part '${_fileName.toLowerCase()}_state.dart'; 
  
class ${_fileName.pascalCase}Bloc extends Bloc<${_fileName.pascalCase}Event, ${_fileName.pascalCase}State> {
  
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
