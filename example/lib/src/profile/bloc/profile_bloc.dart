import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/domain/models/error_dto.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  var stateData = const ProfileStateData();

  ProfileBloc() : super(const ProfileInitialState()) {
    on<ProfileInitEvent>(_onInit);
  }

  void _onInit(
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(const ProfileInitialState());
  }
}
