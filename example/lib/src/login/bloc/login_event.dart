part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginInitEvent extends LoginEvent {
  const LoginInitEvent();

  @override
  List<Object> get props => [];
}
