part of 'example_bloc.dart';

class ExampleStateData extends Equatable {
  final ErrorDto? error;

  const ExampleStateData({
    this.error,
  });

  @override
  List<Object?> get props => [error];

  ExampleStateData copyWith({
    ErrorDto? error,
  }) {
    return ExampleStateData(
      error: error ?? this.error,
    );
  }
}

abstract class ExampleState extends Equatable {
  final ExampleStateData data;

  const ExampleState(this.data);

  @override
  List<Object> get props => [data];
}

class ExampleInitialState extends ExampleState {
  const ExampleInitialState() : super(const ExampleStateData());
}

class ExampleLoadingState extends ExampleState {
  const ExampleLoadingState(super.data);
}

class ExampleFailedState extends ExampleState {
  const ExampleFailedState(super.data);
}

class ExampleSuccessState extends ExampleState {
  const ExampleSuccessState(super.data);
}
