import 'package:base_pkg/base_pkg.dart';
import 'package:bloc_skeleton/core/domain/models/error_dto.dart';


typedef EitherError<T> = Either<ErrorDto, T>;

typedef FutureOrError<T> = Future<EitherError<T>>;
