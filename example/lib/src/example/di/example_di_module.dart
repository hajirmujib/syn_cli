import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../data/remote/services/example_service.dart';
import '../data/repository/example_repository.dart';
import '../data/repository/example_repository_impl.dart';

@module
abstract class ExampleDiModule {
  @singleton
  ExampleService exampleService(Dio dio) => ExampleService(dio);

  @Singleton(as: ExampleRepository)
  ExampleRepositoryImpl get exampleRepository;
}
