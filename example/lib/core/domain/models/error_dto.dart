import 'package:example/core/domain/models/error_type.dart';

class ErrorDto {
  String message;
  String errorCode;
  ErrorType errorType;

  ErrorDto({
    this.message = "Unknown error",
    this.errorCode = '-',
    this.errorType = ErrorType.unknown,
  });

  @override
  String toString() {
    return 'ErrorDto{message: $message, errorCode: $errorCode, errorType: $errorType}';
  }
}
