import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_View file creation.
class GetViewSample extends Sample {
  final String _viewName;
  final String blocDir;
  GetViewSample(String path, this._viewName, this.blocDir,
      {bool overwrite = false})
      : super(path, overwrite: overwrite);

  String get _flutterView => '''import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/$blocDir';

class ${_viewName.pascalCase}Page extends StatefulWidget {
  static const route = '/$_viewName';

  const ${_viewName.pascalCase}Page({super.key});

  @override
  State<${_viewName.pascalCase}Page> createState() => _${_viewName.pascalCase}PageState();
}

class _${_viewName.pascalCase}PageState extends State<${_viewName.pascalCase}Page> {
   late ${_viewName.pascalCase}Bloc _bloc;
  

  @override
  void initState() {
    super.initState();
   

    _bloc = ${_viewName.pascalCase}Bloc()..add(${_viewName.pascalCase}InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<${_viewName.pascalCase}Bloc, ${_viewName.pascalCase}State>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is ${_viewName.pascalCase}LoadingState) {
            showLoadingDialog();
          } else if (state is ${_viewName.pascalCase}SuccessState) {
            Navigator.of(context).pop();
          } else if (state is ${_viewName.pascalCase}FailedState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Text('${_viewName.pascalCase} Page');
        },
      ),
    );
  }

  void showLoadingDialog() {
    
  }

}
  ''';

  @override
  String get content => _flutterView;
}
