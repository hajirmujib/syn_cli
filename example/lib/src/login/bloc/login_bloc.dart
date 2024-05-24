import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/domain/models/error_dto.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  var stateData = const LoginStateData();

  LoginBloc() : super(const LoginInitialState()) {
    on<LoginInitEvent>(_onInit);
  }

  void _onInit(
    LoginEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(const LoginInitialState());
  }
}
