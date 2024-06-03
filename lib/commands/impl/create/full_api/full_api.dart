import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:recase/recase.dart';
import 'package:syn_cli/commands/impl/create/usecase/usecase.dart';
import 'package:syn_cli/commands/impl/generate/model/model.dart';
import 'package:syn_cli/commands/impl/generate/model/response.dart';
import 'package:syn_cli/common/menu/menu.dart';
import 'package:syn_cli/enum/key_value_dto.dart';
import 'package:syn_cli/enum/output_type_enum.dart';
import 'package:syn_cli/samples/impl/get_usecase.dart';
import 'package:syn_cli/samples/impl/update_repository.dart';
import 'package:syn_cli/samples/impl/update_repository_impl.dart';
import 'package:syn_cli/samples/impl/update_services.dart';

import '../../../../common/utils/logger/log_utils.dart';
import '../../../../core/generator.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../interface/command.dart';

/// The command create a Binding and Controller page and view
class CreateFullApiCommand extends Command {
  @override
  String get commandName => 'full_api';

  @override
  List<String> get alias => ['full_api', '-p', '-m'];
  String _methodHtppSelected = '';
  String _url = '';
  String _nameService = '';
  String _nameResponse = '';
  OutputTypeEnum _output = OutputTypeEnum.unknown;
  final List<KeyValueDto> _listParameter = [];
  String parameterFormatted = '';
  bool _withDto = true;
  bool _withService = true;
  bool _withResponse = true;
  bool _withMapper = true;
  bool _withUseCase = true;
  bool _withRepo = true;

  @override
  Future<void> execute() async {
    var isProject = false;
    if (GetCli.arguments[0] == 'create' || GetCli.arguments[0] == '-c') {
      isProject = GetCli.arguments[1].split(':').first == 'project';
    }

    var name = onCommand;

//[-d, -s, -res, -repo, -m, -u]
    // Define the map of flags and their corresponding actions
    final flagActions = {
      '-d': () => _withDto = false,
      '-s': () => _withService = false,
      '-res': () => _withResponse = false,
      '-repo': () => _withRepo = false,
      '-m': () => _withMapper = false,
      '-u': () => _withUseCase = false,
    };

    // Iterate over the arguments and execute the corresponding actions
    for (var element in GetCli.arguments) {
      flagActions[element]?.call();
    }

    if (fromArgument.isEmpty) {
      LogService.error("argument from can't empty");
    } else {
      var isExistModuel = checkForPathAlreadyExists('lib/src/$name');
      if (isExistModuel) {
        if (_withResponse || _withDto) {
          //ask name response
          var result = ask(LocaleKeys.ask_responnse_name.tr,
              required: true, validator: Ask.alphaNumeric);
          _nameResponse = result.pascalCase;
          String pathResponse =
              'lib/src/$name/data/remote/responses/${_nameResponse}_response.dart';
          var isExistResponse = await checkForFileAlreadyExists(pathResponse);
          print(pathResponse);
          if (isExistResponse) {
            LogService.error(
                'file $pathResponse already exist, try with different name');

            return;
          }
        }

        if (_withService) {
          //init path service and create service
          String pathService =
              'lib/src/$name/data/remote/services/${name}_service.dart';
          var isExistService = await checkForFileAlreadyExists(pathService);
          if (isExistService) {
            await _writeService(pathService);
          } else {
            LogService.error(
                "can't update service because file $pathService not found");
          }
        }

        if (_withRepo) {
          //init path respository and create it
          String pathRepository =
              'lib/src/$name/data/repository/${name}_repository.dart';
          var isExistRepository =
              await checkForFileAlreadyExists(pathRepository);
          if (isExistRepository) {
            _updateRepository(pathRepository);
            //init path repository impl and create it
            String pathRepositoryImpl =
                'lib/src/$name/data/repository/${name}_repository_impl.dart';
            var isExistRepositoryImpl =
                await checkForFileAlreadyExists(pathRepositoryImpl);
            if (isExistRepositoryImpl) {
              await _updateRepositoryImpl(pathRepositoryImpl, name);
            } else {
              LogService.error(
                  "can't update repositoryImpl file $pathRepositoryImpl not found");
            }
          } else {
            LogService.error(
                "can't update repository file $pathRepository not found");
          }
        }

        if (_withResponse) {
          if (_nameResponse.isNotEmpty) {
            // Create an instance of GenerateResponseCommand
            //create response file
            var generateResponseCommand = GenerateResponseCommand();
            // Call the execute method to generate the response
            await generateResponseCommand.execute(nameResponse: _nameResponse);

            //generate dto from response
            var generateDtoCommand = GenerateModelCommand();
            // Call the execute method to generate the response
            await generateDtoCommand.execute(nameResponse: _nameResponse);
          }
        }

        String pathMapper = 'lib/src/$name/domain/mappers/${name}_mapper.dart';
        var isExistMapper = await checkForFileAlreadyExists(pathMapper);

        if (_withMapper && isExistMapper) {
          _updateMapper(pathMapper, name);
        } else {
          LogService.error("can't update file $pathMapper not found");
        }

        String pathUseCase =
            'lib/src/$name/domain/usecase/${_nameResponse.replaceAll('Response', '').toLowerCase()}_usecase.dart';
        var isExistUsecase = await checkForFileAlreadyExists(pathUseCase);

        if (_withUseCase && !isExistUsecase) {
          String param = convertQueryParameters(parameterFormatted);

          var generateUseCaseCommand = CreateUseCaseCommand();
          generateUseCaseCommand.execute(
            nameRepository: onCommand.pascalCase,
            parameter: param,
            nameDto: _nameResponse.replaceAll("Response", ''),
            nameUsecase: _nameResponse.replaceAll("Response", ''),
            nameFuncRepo: _nameService,
            isPagination: _output == OutputTypeEnum.pagination ? true : false,
          );
        } else {
          String param = convertQueryParameters(parameterFormatted);

          var sample = UseCaseSample(
              '',
              _output == OutputTypeEnum.pagination ? true : false,
              onCommand.pascalCase,
              param,
              _nameResponse.replaceAll("Response", ''),
              _nameResponse.replaceAll("Response", ''),
              _nameService,
              overwrite: true);
          handleUpdateCreate(pathUseCase, sample.content, isEndFile: true);
          LogService.info(
              '$pathUseCase already exist, new content added in end file');
        }
        // //update repository
        // _writeContent(path);
        LogService.success(
            LocaleKeys.sucess_full_api_create.trArgs([name.pascalCase]));
      } else {
        LogService.error(
            LocaleKeys.error_module_not_found.trArgs([name.pascalCase]));
      }
    }
  }

  @override
  String? get hint => LocaleKeys.hint_create_module.tr;

  bool checkForPathAlreadyExists(String defaultPath) {
    if (Directory(defaultPath).existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkForFileAlreadyExists(String defaultPath) async {
    File file = File(defaultPath);
    if (!await file.exists()) {
      return false;
    } else {
      return true;
    }
  }

  Future _writeService(
    String path,
  ) async {
    //ask method http
    final menu = Menu(
      [
        'GET',
        'PUT',
        'POST',
        'DELETE',
      ],
      title: Translation(LocaleKeys.ask_method_http.trArgs([name])).toString(),
    );

    final methodHttp = menu.choose();
    _methodHtppSelected = methodHttp.result;

    //ask url
    _url = ask(LocaleKeys.ask_name_url.tr, validator: Ask.required);
    //ask name service

    _nameService = convertToCamelCase(
        ask(LocaleKeys.ask_name_service.tr, validator: Ask.alphaNumeric));

    //ask type output

    final menuPagination = Menu(
      [
        'Yes!',
        'No!',
      ],
      title: 'Type output is pagination?',
    );
    _output = menuPagination.choose().index == 0
        ? OutputTypeEnum.pagination
        : OutputTypeEnum.baseOutput;
    if (_output == OutputTypeEnum.baseOutput) {
      //ask parameter
      String? totalParameter = ask(
          'Total Parameter? (*give 0 if empty parameter)',
          validator: Ask.integer);

      for (var i = 0; i < int.parse(totalParameter); i++) {
        final menuTypeData = Menu(
          ['int', 'String', 'double', 'bool', 'cancel!'],
          title: 'Type Data ?',
        );

        // Store the chosen index in a variable to prevent multiple calls
        var choice = menuTypeData.choose();
        int chosenIndex = choice.index;

        // Check if the user selected 'cancel!'
        if (chosenIndex == menuTypeData.choices.length - 1) {
          break;
        } else {
          // Get the selected type data
          String typeDataSelected = menuTypeData.choices[chosenIndex];

          // Ask for the field name
          String? nameField = ask(
              'What is name field in line ${i + 1} (*example: user_data)',
              validator: Ask.required);

          // Add the type data and field name to the list of parameters
          _listParameter
              .add(KeyValueDto(key: typeDataSelected, value: nameField));
        }
      }

      parameterFormatted = formatListToString(_listParameter);
    }

    //create services func
    String content = UpdateServicesSample(
            '',
            _methodHtppSelected,
            _url,
            _nameService,
            "${_nameResponse}Response",
            _output,
            parameterFormatted)
        .content;

    handleUpdateCreate(path, content);
  }

  Future _updateRepository(String path) async {
    String output = convertQueryParameters(parameterFormatted);
    //create services func
    String content = UpdateRepositorySample(
            '', _nameService, "${_nameResponse}Response", _output, output)
        .content;
    handleUpdateCreate(path, content);
  }

  Future _updateRepositoryImpl(String path, String name) async {
    String parameter = convertQueryParameters(parameterFormatted);
    String paramaterService = convertParametersService(parameter);

    //create services func
    String content = UpdateRepositoryImplSample(
            '',
            _nameService,
            "${_nameResponse}Response",
            _output,
            parameter,
            name,
            paramaterService)
        .content;

    handleUpdateCreate(path, content);
  }

  Future _updateMapper(String path, String name) async {
    final file = File(
        "lib/src/$name/data/remote/responses/${_nameResponse.snakeCase}_response.dart");
    final fileContent = await file.readAsString();
    String formattedClasses = formatClassDefinitions(fileContent);

    var content = generateDartMapperClass(formattedClasses, _nameResponse);

    handleUpdateCreate(path, content, isEndFile: true);
  }

  String convertQueryParameters(String input) {
    // Regular expression to match the pattern @Query('...') type? variable,
    final RegExp regex = RegExp(r"@Query\('.*'\)\s*(\w+\??)\s+(\w+),");

    // Find all matches in the input string
    Iterable<RegExpMatch> matches = regex.allMatches(input);

    // Convert matches to the desired format
    List<String> parameters = matches.map((match) {
      String type = match.group(1)!;
      String variable = match.group(2)!;
      // Remove the nullable character '?' if present
      String nonNullableType =
          type.endsWith('?') ? type.substring(0, type.length - 1) : type;
      return "$nonNullableType $variable";
    }).toList();

    // Join the parameters with commas and new lines
    return parameters.join(',\n    ');
  }

  String formatListToString(List<KeyValueDto> list) {
    return list.map((item) {
      return '''
    @Query('${item.value}') ${item.key}? ${_toCamelCase(item.value)},''';
    }).join('\n');
  }

  String convertParametersService(String input) {
    // Regular expression to match the parameter names
    final RegExp regex = RegExp(r"\w+\s+(\w+),?");

    // Find all matches in the input string
    Iterable<RegExpMatch> matches = regex.allMatches(input);

    // Extract the parameter names
    List<String> parameters = matches.map((match) => match.group(1)!).toList();

    // Join the parameters with commas
    return parameters.join(',');
  }

//this convert response to dto
  String generateDartMapperClass(String classSource, String responseName) {
    // print(classSource);
    final fieldRegex =
        RegExp(r'final\s+((?:List<[\w<>?]+>|\w+Response?\??|\w+)\??)\s+(\w+);');

    var dartCode = '';

    var responseClassName = '${ReCase(responseName).pascalCase}Response';
    var dtoClassName = '${ReCase(responseName).pascalCase}Dto';
    var extensionName = '${ReCase(responseName).pascalCase}Ext';

    dartCode = 'extension $extensionName on $responseClassName? {\n';
    dartCode += '  $dtoClassName toDto() {\n';
    dartCode += '    return $dtoClassName(\n';

    final classRegex = RegExp(r'class\s+(\w+)\s+\{([^}]+)\}');
    var classes = <String, String>{};
    for (var match in classRegex.allMatches(classSource)) {
      classes[match.group(1)!] = match.group(2)!;
    }

    var mainClassContent = classes[responseClassName];
    if (mainClassContent == null) {
      throw Exception('Main response class not found in source.');
    }

    var processedFields = <String>{};

    for (var match in fieldRegex.allMatches(mainClassContent)) {
      var fieldType = match.group(1)!;
      var originalFieldType = fieldType; // Simpan fieldType asli

      var fieldName = match.group(2)!;
      var camelCaseKey = ReCase(fieldName).camelCase;
      var defaultValue = getDefaultValue(fieldType);

      if (originalFieldType.startsWith('List<')) {
        var elementType = fieldType.substring(
            5,
            fieldType.length -
                2); // Extract the element type from List<elementType>
        var dtoElementType = elementType.replaceAll('Response', 'Dto');
        dartCode +=
            '''      $camelCaseKey: this?.$camelCaseKey?.map((e) => $dtoElementType(
${generateNestedMapperCode(elementType, classSource, 'e')}
      )).toList() ?? $defaultValue,\n''';
        processedFields.add(fieldName);
      } else if (originalFieldType.endsWith('Response?')) {
        var dtoType = originalFieldType.replaceAll('Response?', 'Dto');
        dartCode += '''      $camelCaseKey: $dtoType(
${generateNestedMapperCode(fieldType, classSource, 'this?.$camelCaseKey?')}
      ) ?? $defaultValue,\n''';
        processedFields.add(fieldName);
      } else if (originalFieldType.endsWith('Response')) {
        var dtoType = originalFieldType.replaceAll('Response', 'Dto');
        dartCode += '''      $camelCaseKey: $dtoType(
${generateNestedMapperCode(fieldType, classSource, 'this?.$camelCaseKey?')}
      ) ?? $defaultValue,\n''';
        processedFields.add(fieldName);
      } else {
        if (!processedFields.contains(fieldName)) {
          dartCode +=
              '      $camelCaseKey: this?.$camelCaseKey ?? $defaultValue,\n';
        }
      }
    }

    dartCode += '    );\n  }\n}';

    return dartCode;
  }

  String generateNestedMapperCode(
      String elementType, String classSource, String mapperField) {
    final nestedClassRegex =
        RegExp(r'class\s+' + elementType + r'\s+\{([^}]+)\}', multiLine: true);
    var nestedCode = '';

    if (nestedClassRegex.hasMatch(classSource)) {
      final classBody = nestedClassRegex.firstMatch(classSource)!.group(1)!;
      final nestedFieldRegex = RegExp(
          r'final\s+((?:List<[\w<>?]+>|\w+Response?\??|\w+)\??)\s+(\w+);');

      for (var match in nestedFieldRegex.allMatches(classBody)) {
        var fieldType = match.group(1)!;
        var fieldName = match.group(2)!;
        var camelCaseKey = ReCase(fieldName).camelCase;
        var defaultValue = getDefaultValue(fieldType);

        if (fieldType.startsWith('List<')) {
          var nestedElementType = fieldType.substring(5, fieldType.length - 2);
          var nestedDtoElementType =
              nestedElementType.replaceAll('Response', 'Dto');
          nestedCode +=
              '''      $camelCaseKey: $mapperField.$camelCaseKey?.map((e) => $nestedDtoElementType(
${generateNestedMapperCode(nestedElementType, classSource, 'e')}
        )).toList() ?? $defaultValue,\n''';
        } else if (fieldType.endsWith('Response?')) {
          var nestedDtoType = fieldType.replaceAll('Response?', 'Dto');
          nestedCode += '''      $camelCaseKey: $nestedDtoType(
${generateNestedMapperCode(fieldType, classSource, '$mapperField.$camelCaseKey?')}
        ) ?? $defaultValue,\n''';
        } else if (fieldType.endsWith('Response')) {
          var nestedDtoType = fieldType.replaceAll('Response', 'Dto');
          nestedCode += '''      $camelCaseKey: $nestedDtoType(
${generateNestedMapperCode(fieldType, classSource, '$mapperField.$camelCaseKey?')}
        ) ?? $defaultValue,\n''';
        } else {
          nestedCode +=
              '      $camelCaseKey: $mapperField.$camelCaseKey ?? $defaultValue,\n';
        }
      }
    }

    return nestedCode;
  }

// Helper function to get default value for a field type
  String getDefaultValue(String fieldType) {
    if (fieldType.startsWith('List<')) {
      return 'const []';
    } else if (fieldType.endsWith('?')) {
      return 'null';
    } else if (fieldType == 'int') {
      return '0';
    } else if (fieldType == 'double') {
      return '0.0';
    } else if (fieldType == 'bool') {
      return 'false';
    } else if (fieldType == 'String') {
      return "''";
    } else {
      return 'null';
    }
  }

  String getListElementType(List<dynamic> list) {
    if (list.isEmpty) {
      return 'dynamic';
    } else {
      return list.first.runtimeType.toString();
    }
  }

  bool isCustomClass(dynamic value) {
    return value != null && value.runtimeType.toString().endsWith('Response');
  }

  Map<String, dynamic> convertClassToMap(String classDefinition) {
    final className = extractClassName(classDefinition);
    final fields = extractFields(classDefinition);
    // print('classDefinition : $classDefinition || $className||$fields');
    return {
      className: fields,
    };
  }

  String extractClassName(String classDefinition) {
    final classNameRegex = RegExp(r'class\s+(\w+)\s+\{');
    return classNameRegex.firstMatch(classDefinition)?.group(1) ?? '';
  }

  Map<String, dynamic> extractFields(String classDefinition) {
    final fields = <String, dynamic>{};
    final fieldRegex = RegExp(r'final\s+(\w+\??)\s+(\w+);');

    for (var match in fieldRegex.allMatches(classDefinition)) {
      final type = match.group(1) ?? 'dynamic';
      final name = match.group(2) ?? '';

      if (type.endsWith('Dto') || type.endsWith('Response')) {
        fields[name] = <String, dynamic>{}; // Placeholder for custom class
      } else if (type.startsWith('List<')) {
        final elementType = type.substring(5, type.length - 1);
        if (elementType.endsWith('Dto') || elementType.endsWith('Response')) {
          fields[name] = [
            <String, dynamic>{}
          ]; // Placeholder for list of custom class
        } else {
          fields[name] = []; // Placeholder for list of basic type
        }
      } else {
        fields[name] = getDefaultValueForType(type);
      }
    }

    return fields;
  }

  dynamic getDefaultValueForType(String type) {
    switch (type) {
      case 'String':
      case 'String?':
        return '';
      case 'int':
      case 'int?':
        return 0;
      case 'double':
      case 'double?':
        return 0.0;
      case 'bool':
      case 'bool?':
        return false;
      default:
        return null;
    }
  }

  List<String> extractClassDefinitions(String fileContent) {
    
    final classRegex = RegExp(r'class\s+\w+\s*\{[^}]+\}', multiLine: true);
    return classRegex
        .allMatches(fileContent)
        .map((match) => match.group(0)!)
        .toList();
  }

  String formatClassDefinition(String classDefinition) {
    final fieldRegex = RegExp(r'final\s+([\w<>\?]+)\s+(\w+);');
    final classNameRegex = RegExp(r'class\s+(\w+)');

    var classNameMatch = classNameRegex.firstMatch(classDefinition);
    if (classNameMatch == null) {
      return '';
    }
    var className = classNameMatch.group(1)!;

    var formattedClass = 'class $className {\n';

    for (var match in fieldRegex.allMatches(classDefinition)) {
      var fieldType = match.group(1)!;
      var fieldName = match.group(2)!;
      formattedClass += '  final $fieldType $fieldName;\n';
    }

    formattedClass += '}\n';
    return formattedClass;
  }

  String formatClassDefinitions(String fileContent) {
    
    var classDefinitions = extractClassDefinitions(fileContent);
   
    return classDefinitions.map(formatClassDefinition).join('\n');
  }

//end of convert response to dto
  String convertToCamelCase(String input) {
    // Menghapus spasi di awal dan di akhir string
    String trimmedInput = input.trim();

    // Menghapus karakter yang tidak diinginkan menggunakan regex
    String cleanedInput = trimmedInput.replaceAll(RegExp(r'[^\w\s]'), '');

    // Mengubah string menjadi camel case
    String camelCaseString = ReCase(cleanedInput).camelCase;

    return camelCaseString;
  }

  String _toCamelCase(String text) {
    List<String> parts = text.split('_');
    return parts.first +
        parts
            .skip(1)
            .map((part) => part[0].toUpperCase() + part.substring(1))
            .join('');
  }

  @override
  String get codeSample => 'get create module:product';

  @override
  int get maxParameters => 0;
}
