// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:base_pkg/base_pkg.dart' as _i4;
import 'package:bloc_skeleton/core/data/local/app_preferences.dart' as _i5;
import 'package:bloc_skeleton/core/data/remote/interceptors/auth_interceptor.dart'
    as _i3;
import 'package:bloc_skeleton/core/di/local_module.dart' as _i15;
import 'package:bloc_skeleton/core/di/network_module.dart' as _i13;
import 'package:bloc_skeleton/core/di/super_module.dart' as _i14;
import 'package:bloc_skeleton/src/example/data/remote/services/example_service.dart'
    as _i6;
import 'package:bloc_skeleton/src/example/data/repository/example_repository.dart'
    as _i9;
import 'package:bloc_skeleton/src/example/data/repository/example_repository_impl.dart'
    as _i17;
import 'package:bloc_skeleton/src/example/di/example_di_module.dart' as _i16;
import 'package:bloc_skeleton/src/example/domain/usecases/get_post_usecase.dart'
    as _i10;
import 'package:bloc_skeleton/src/quiz/data/remote/services/quiz_service.dart'
    as _i8;
import 'package:bloc_skeleton/src/quiz/data/repository/quiz_repository.dart'
    as _i11;
import 'package:bloc_skeleton/src/quiz/data/repository/quiz_repository_impl.dart'
    as _i19;
import 'package:bloc_skeleton/src/quiz/di/quiz_di_module.dart' as _i18;
import 'package:bloc_skeleton/src/quiz/domain/usecase/quizdata_usecase.dart'
    as _i12;
import 'package:dio/dio.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    final superModule = _$SuperModule();
    final localModule = _$LocalModule();
    final exampleDiModule = _$ExampleDiModule(this);
    final quizDiModule = _$QuizDiModule(this);
    gh.singleton<_i3.AuthInterceptor>(() => networkModule.authInterceptor);
    await gh.singletonAsync<_i4.SharedPreferences>(
      () => superModule.prefs,
      preResolve: true,
    );
    gh.singleton<String>(
      () => superModule.baseUrl,
      instanceName: 'base_url',
    );
    gh.singleton<_i5.AppPreferences>(
        () => localModule.appPreferences(gh<_i4.SharedPreferences>()));
    gh.singleton<_i4.Dio>(() => superModule.dio(
          gh<String>(instanceName: 'base_url'),
          gh<_i3.AuthInterceptor>(),
        ));
    gh.singleton<_i6.ExampleService>(
        () => exampleDiModule.exampleService(gh<_i7.Dio>()));
    gh.singleton<_i8.QuizService>(
        () => quizDiModule.quizService(gh<_i7.Dio>()));
    gh.singleton<_i9.ExampleRepository>(
        () => exampleDiModule.exampleRepository);
    gh.factory<_i10.GetPostUseCase>(
        () => exampleDiModule.getPostUseCase(gh<_i9.ExampleRepository>()));
    gh.singleton<_i11.QuizRepository>(() => quizDiModule.quizRepository);
    gh.factory<_i12.QuizDataUseCase>(
        () => quizDiModule.quizDataUseCase(gh<_i11.QuizRepository>()));
    return this;
  }
}

class _$NetworkModule extends _i13.NetworkModule {}

class _$SuperModule extends _i14.SuperModule {}

class _$LocalModule extends _i15.LocalModule {}

class _$ExampleDiModule extends _i16.ExampleDiModule {
  _$ExampleDiModule(this._getIt);

  final _i1.GetIt _getIt;

  @override
  _i17.ExampleRepositoryImpl get exampleRepository =>
      _i17.ExampleRepositoryImpl(_getIt<_i6.ExampleService>());
}

class _$QuizDiModule extends _i18.QuizDiModule {
  _$QuizDiModule(this._getIt);

  final _i1.GetIt _getIt;

  @override
  _i19.QuizRepositoryImpl get quizRepository =>
      _i19.QuizRepositoryImpl(_getIt<_i8.QuizService>());
}
