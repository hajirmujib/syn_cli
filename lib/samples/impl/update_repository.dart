import 'package:syn_cli/enum/output_type_enum.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class UpdateRepositorySample extends Sample {
  final String _serviceName;
  final String _response;
  final OutputTypeEnum typeOutput;
  final String _parameter;

  UpdateRepositorySample(super.path, this._serviceName, this._response,
      this.typeOutput, this._parameter,
      {super.overwrite});

  @override
  String get content => flutterServices;

  String get flutterServices =>
      '''FutureOrError<${typeOutput == OutputTypeEnum.pagination ? "BasePaginationResponse<List<$_response>>>" : "BaseResponse<$_response>>"} $_serviceName(${typeOutput == OutputTypeEnum.pagination ? """{
    int? page = 1,
    int? size = 10,
    String? keyword,
  }""" : '\n$_parameter'});
''';
}
