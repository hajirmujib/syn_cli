part of 'profile_bloc.dart';

class ProfileStateData extends Equatable {
  final ErrorDto? error;

  const ProfileStateData({
    this.error,
  });

  @override
  List<Object?> get props => [error];

  ProfileStateData copyWith({
    ErrorDto? error,
  }) {
    return ProfileStateData(
      error: error ?? this.error,
    );
  }
}

abstract class ProfileState extends Equatable {
  final ProfileStateData data;

  const ProfileState(this.data);

  @override
  List<Object> get props => [data];
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState() : super(const ProfileStateData());
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState(super.data);
}

class ProfileFailedState extends ProfileState {
  const ProfileFailedState(super.data);
}

class ProfileSuccessState extends ProfileState {
  const ProfileSuccessState(super.data);
}
