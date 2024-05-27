import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/domain/models/error_dto.dart';

part 'example_event.dart';
part 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  var stateData = const ExampleStateData();

  ExampleBloc() : super(const ExampleInitialState()) {
    on<ExampleInitEvent>(_onInit);
  }

  void _onInit(
    ExampleEvent event,
    Emitter<ExampleState> emit,
  ) {
    emit(const ExampleInitialState());
  }
}
