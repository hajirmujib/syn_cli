import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

String typeMapping(dynamic jsonType) {
  if (jsonType is int) return 'int';
  if (jsonType is String) return 'String';
  if (jsonType is bool) return 'bool';
  return 'dynamic'; // default type
}

/// [Sample] file from Dto file creation.
class DtoSample extends Sample {
  final String _fileName;
  final bool isServer;
  final bool createEndpoints;
  final String modelPath;
  String? _namePascal;
  String? _nameLower;
  DtoSample(this._fileName,
      {bool overwrite = false,
      this.createEndpoints = false,
      this.modelPath = '',
      this.isServer = false,
      String path = ''})
      : super(path, overwrite: overwrite) {
    _namePascal = _fileName.pascalCase;
    _nameLower = _fileName.toLowerCase();
  }

  var dartDtoClass = GeneratorClass().generateDartDtoClass("dto", {"id": 2});

  @override
  String get content => dartDtoClass;
}

String getDefaultValue(dynamic value) {
  if (value is String) {
    return '\'\'';
  } else if (value is int) {
    return '0';
  } else if (value is bool) {
    return 'false';
  } else {
    return '\'\'';
  }
}

class GeneratorClass {
  String generateDartDtoClass(String className, Map<String, dynamic> jsonData) {
    className = '${ReCase(className).pascalCase}Dto';

    var dartCode = 'class $className {\n';

    jsonData.forEach((key, value) {
      var dartType = typeMapping(value);
      var camelCaseKey = ReCase(key).camelCase;
      dartCode += '  final $dartType $camelCaseKey;\n';
    });

    dartCode += '\n  const $className({\n';
    for (var key in jsonData.keys) {
      var camelCaseKey = ReCase(key).camelCase;
      var defaultValue = getDefaultValue(jsonData[key]);
      dartCode += '    this.$camelCaseKey = $defaultValue,\n';
    }
    dartCode += '  });\n\n';

    dartCode += '  @override\n  String toString() {\n';
    dartCode += '    return \'$className';
    bool first = true;
    jsonData.forEach((key, value) {
      var camelCaseKey = ReCase(key).camelCase;
      dartCode += '${first ? '{' : ', '}$camelCaseKey: \$$camelCaseKey';
      first = false;
    });
    dartCode += '}\';\n  }\n}';

    return dartCode;
  }
}
