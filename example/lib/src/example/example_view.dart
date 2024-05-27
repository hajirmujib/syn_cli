import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/example_bloc.dart';

class ExamplePage extends StatefulWidget {
  static const route = '/Example';

  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late ExampleBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = ExampleBloc()..add(ExampleInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ExampleBloc, ExampleState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is ExampleLoadingState) {
            showLoadingDialog();
          } else if (state is ExampleSuccessState) {
            Navigator.of(context).pop();
          } else if (state is ExampleFailedState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Text('Example Page');
        },
      ),
    );
  }

  void showLoadingDialog() {}
}
