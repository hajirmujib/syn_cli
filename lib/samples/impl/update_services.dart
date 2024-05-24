import 'package:syn_cli/enum/output_type_enum.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class UpdateServicesSample extends Sample {
  final String _method;
  final String _url;
  final String _serviceName;
  final String _response;
  final OutputTypeEnum typeOutput;
  final String _parameter;

  UpdateServicesSample(super.path, this._method, this._url, this._serviceName,
      this._response, this.typeOutput, this._parameter,
      {super.overwrite});

  @override
  String get content => flutterServices;

  String get flutterServices => '''@${_method.toUpperCase()}('$_url')
  Future<${typeOutput == OutputTypeEnum.pagination ? "BasePaginationResponse<List<$_response>>>" : "BaseResponse<$_response>>"} $_serviceName(${typeOutput == OutputTypeEnum.pagination ? """{
    @Query('page') int? page = 1,
    @Query('limit') int? size = 10,
    @Query('search') String? keyword,
  }""" : '\n$_parameter'});
''';
}
