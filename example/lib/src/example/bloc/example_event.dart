part of 'example_bloc.dart';

abstract class ExampleEvent extends Equatable {
  const ExampleEvent();
}

class ExampleInitEvent extends ExampleEvent {
  const ExampleInitEvent();

  @override
  List<Object> get props => [];
}
