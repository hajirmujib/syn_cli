import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  static const route = '/Login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = LoginBloc()..add(LoginInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<LoginBloc, LoginState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is LoginLoadingState) {
            showLoadingDialog();
          } else if (state is LoginSuccessState) {
            Navigator.of(context).pop();
          } else if (state is LoginFailedState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Text('Login Page');
        },
      ),
    );
  }

  void showLoadingDialog() {}
}
