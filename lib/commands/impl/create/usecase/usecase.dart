import 'dart:async';
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:http/http.dart';
import 'package:recase/recase.dart';
import 'package:syn_cli/common/menu/menu.dart';
import 'package:syn_cli/common/utils/logger/log_utils.dart';
import 'package:syn_cli/common/utils/pubspec/pubspec_utils.dart';
import 'package:syn_cli/exception_handler/exceptions/cli_exception.dart';
import 'package:syn_cli/functions/is_url/is_url.dart';
import 'package:syn_cli/functions/replace_vars/replace_vars.dart';
import 'package:syn_cli/samples/impl/get_usecase.dart';

import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../interface/command.dart';

class CreateUseCaseCommand extends Command {
  @override
  String get commandName => 'usecase';
  String finalnameRepository = '';
  String finalparameter = '';
  String finalnameDto = '';
  String finalnameUsecase = '';
  String finalnameFuncRepo = '';
  bool finalIsPagination = false;
  String pathUseCase = '';
  @override
  String? get hint => LocaleKeys.hint_create_controller.tr;

  @override
  String get codeSample => 'get create controller:name [OPTINAL PARAMETERS] \n';

  @override
  Future<void> execute({
    String nameRepository = '',
    String parameter = '',
    String nameDto = '',
    String nameUsecase = '',
    String nameFuncRepo = '',
    String importDeps = '',
    bool? isPagination,
  }) async {
    var isExistModuel = checkForPathAlreadyExists('lib/src/$onCommand');
    print('lib/src/$onCommand');
    if (!isExistModuel) {
      LogService.error('module not found, create module and run again');
      return;
    } else {
      return await createUseCase(
        withArgument: withArgument,
        onCommand: onCommand,
        nameRepository: nameRepository,
        parameter: parameter,
        nameDto: nameDto,
        nameUsecase: nameUsecase,
        nameFuncRepo: nameFuncRepo,
        isPagination: isPagination,
        importDeps: importDeps,
      );
    }
  }

  Future<void> createUseCase({
    String withArgument = '',
    String onCommand = '',
    String nameRepository = '',
    String parameter = '',
    String nameDto = '',
    String nameUsecase = '',
    String nameFuncRepo = '',
    String importDeps = '',
    bool? isPagination,
  }) async {
    finalnameUsecase = nameUsecase.isEmpty
        ? ask('what name usecase ?(* without UseCase,eg: ExampleData)',
            validator: Ask.required)
        : nameUsecase;

    finalnameRepository = nameRepository.isEmpty
        ? ask('what name repository ?(* without Repository,eg: ExampleData)',
            validator: Ask.required)
        : nameRepository;

    finalnameDto = nameDto.isEmpty
        ? ask('what name dto ?(* without Dto,eg: ExampleData)',
            validator: Ask.required)
        : nameDto;

    if (isPagination == null) {
      final menuIsPagination = Menu(
        ['true', 'false'],
        title: 'output is pagination ?',
      );

      // Store the chosen index in a variable to prevent multiple calls
      var choice = menuIsPagination.choose();
      int chosenIndex = choice.index;
      finalIsPagination = chosenIndex == 0;
    } else {
      finalIsPagination = isPagination;
    }

    finalnameFuncRepo = nameFuncRepo.isEmpty
        ? ask('what name func of repository ?(eg: getUser)',
            validator: Ask.required)
        : nameFuncRepo;

    var sample = UseCaseSample('', finalIsPagination, finalnameRepository,
        parameter, finalnameDto, finalnameUsecase, finalnameFuncRepo, '',
        overwrite: true);
    if (withArgument.isNotEmpty) {
      if (isURL(withArgument)) {
        var res = await get(Uri.parse(withArgument));
        if (res.statusCode == 200) {
          var content = res.body;
          sample.customContent =
              replaceVars(content, nameUsecase.toLowerCase());
        } else {
          throw CliException(
              LocaleKeys.error_failed_to_connect.trArgs([withArgument]));
        }
      } else {
        var file = File(withArgument);
        if (file.existsSync()) {
          var content = file.readAsStringSync();
          sample.customContent =
              replaceVars(content, nameUsecase.toLowerCase());
        } else {
          throw CliException(
              LocaleKeys.error_no_valid_file_or_url.trArgs([withArgument]));
        }
      }
    }
    String content = '$importDeps\n${sample.content}';
    pathUseCase =
        'lib/src/$onCommand/domain/usecase/${finalnameUsecase.toLowerCase()}_usecase.dart';
    writeFile(
      pathUseCase,
      content,
      overwrite: true,
    );
    final pathDi =
        File("lib/src/$onCommand/di/${onCommand.snakeCase}_di_module.dart");
    var isExistMapper = await checkForFileAlreadyExists(pathDi.path);
    if (isExistMapper) {
      await _updateDi(pathDi.path);
    }
  }

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

  Future _updateDi(String path) async {
    var content = '''

@injectable
  ${finalnameUsecase}UseCase ${finalnameUsecase.camelCase}UseCase(
          ${finalnameRepository}Repository repository) =>
      ${finalnameUsecase}UseCase(repository);
      ''';

    await handleUpdateCreate(path, content,
        isEndFile: false,
        importContent:
            "import 'package:${PubspecUtils.projectName}/${pathUseCase.replaceAll('lib/', '')}';");
  }

  @override
  int get maxParameters => 0;
}
