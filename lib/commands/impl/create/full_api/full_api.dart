import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:recase/recase.dart';
import 'package:syn_cli/commands/impl/generate/model/model.dart';
import 'package:syn_cli/commands/impl/generate/model/response.dart';
import 'package:syn_cli/common/menu/menu.dart';
import 'package:syn_cli/enum/key_value_dto.dart';
import 'package:syn_cli/enum/output_type_enum.dart';
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
    print('argument : ${GetCli.arguments.toString()}');
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
    var isExistModuel = checkForPathAlreadyExists('lib/src/$name');
    if (isExistModuel) {
      if (_withResponse || _withDto) {
        //ask name response
        var result = ask(LocaleKeys.ask_responnse_name.tr, required: false);
        _nameResponse = result.pascalCase;
      }
      if (_withService) {
        //init path service and create service
        String pathService =
            'lib/src/$name/data/remote/services/${name}_service.dart';
        // //update service
        await _writeService(pathService);
      }
      if (_withRepo) {
        //init path respository and create it
        String pathRepository =
            'lib/src/$name/data/repository/${name}_repository.dart';
        var isExistRepository = await checkForFileAlreadyExists(pathRepository);
        if (isExistRepository) {
          _updateRepository(pathRepository);
          //init path repository impl and create it
          String pathRepositoryImpl =
              'lib/src/$name/data/repository/${name}_repository_impl.dart';
          var isExistRepositoryImpl =
              await checkForFileAlreadyExists(pathRepositoryImpl);
          if (isExistRepositoryImpl) {
            await _updateRepositoryImpl(pathRepositoryImpl, name);
          }
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

      // //update repository
      // _writeContent(path);
      LogService.success(
          LocaleKeys.sucess_full_api_create.trArgs([name.pascalCase]));
    } else {
      LogService.error(
          LocaleKeys.error_module_not_found.trArgs([name.pascalCase]));
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
    // var newFileModel =
    //     Structure.model(name, 'module', true, on: onCommand, folderName: name);
    // var pathSplit = Structure.safeSplitPath(newFileModel.path!);

    print('path $defaultPath');
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
    _nameService = ask(LocaleKeys.ask_name_service.tr, validator: Ask.required);
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
