part of 'login_bloc.dart';

class LoginStateData extends Equatable {
  final ErrorDto? error;

  const LoginStateData({
    this.error,
  });

  @override
  List<Object?> get props => [error];

  LoginStateData copyWith({
    ErrorDto? error,
  }) {
    return LoginStateData(
      error: error ?? this.error,
    );
  }
}

abstract class LoginState extends Equatable {
  final LoginStateData data;

  const LoginState(this.data);

  @override
  List<Object> get props => [data];
}

class LoginInitialState extends LoginState {
  const LoginInitialState() : super(const LoginStateData());
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState(super.data);
}

class LoginFailedState extends LoginState {
  const LoginFailedState(super.data);
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState(super.data);
}
