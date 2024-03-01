import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  static const route = '/Profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = ProfileBloc()..add(ProfileInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is ProfileLoadingState) {
            showLoadingDialog();
          } else if (state is ProfileSuccessState) {
            Navigator.of(context).pop();
          } else if (state is ProfileFailedState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Text('Profile Page');
        },
      ),
    );
  }

  void showLoadingDialog() {}
}
