part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileInitEvent extends ProfileEvent {
  const ProfileInitEvent();

  @override
  List<Object> get props => [];
}
