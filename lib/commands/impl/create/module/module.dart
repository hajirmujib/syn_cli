import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:syn_cli/samples/impl/get_bloc.dart';
import 'package:syn_cli/samples/impl/get_di.dart';
import 'package:syn_cli/samples/impl/get_event.dart';
import 'package:syn_cli/samples/impl/get_mapper.dart';
import 'package:syn_cli/samples/impl/get_repository.dart';
import 'package:syn_cli/samples/impl/get_repository_impl.dart';
import 'package:syn_cli/samples/impl/get_services.dart';
import 'package:syn_cli/samples/impl/get_state.dart';

import '../../../../common/menu/menu.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/generator.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../samples/impl/get_view.dart';
import '../../../interface/command.dart';

/// The command create a Binding and Controller page and view
class CreateModuleCommand extends Command {
  @override
  String get commandName => 'module';

  @override
  List<String> get alias => ['module', '-p', '-m'];
  @override
  Future<void> execute() async {
    var isProject = false;
    if (GetCli.arguments[0] == 'create' || GetCli.arguments[0] == '-c') {
      isProject = GetCli.arguments[1].split(':').first == 'project';
    }
    var name = this.name;
    if (name.isEmpty || isProject) {
      name = 'home';
    }
    checkForAlreadyExists(name);
  }

  @override
  String? get hint => LocaleKeys.hint_create_module.tr;

  void checkForAlreadyExists(String? name) {
    var newFileModel =
        Structure.model(name, 'module', true, on: onCommand, folderName: name);
    var pathSplit = Structure.safeSplitPath(newFileModel.path!);

    pathSplit.removeLast();
    var path = pathSplit.join('/');
    path = Structure.replaceAsExpected(path: path);
    if (Directory(path).existsSync()) {
      final menu = Menu(
        [
          LocaleKeys.options_yes.tr,
          LocaleKeys.options_no.tr,
          LocaleKeys.options_rename.tr,
        ],
        title: Translation(LocaleKeys.ask_existing_module.trArgs([name]))
            .toString(),
      );
      final result = menu.choose();
      if (result.index == 0) {
        _writeFiles(path, name!, overwrite: true);
      } else if (result.index == 2) {
        // final dialog = CLI_Dialog();
        // dialog.addQuestion(LocaleKeys.ask_new_module_name.tr, 'name');
        // name = dialog.ask()['name'] as String?;
        var name = ask(LocaleKeys.ask_new_module_name.tr);
        checkForAlreadyExists(name.trim().snakeCase);
      }
    } else {
      Directory(path).createSync(recursive: true);
      _writeFiles(path, name!, overwrite: false);
    }
  }

  void _writeFiles(String path, String name, {bool overwrite = false}) {
    var extraFolder = PubspecUtils.extraFolder ?? true;

    var blocDir = handleFileCreate(
      name,
      'bloc',
      path,
      extraFolder,
      BlocSample(
        'bloc',
        name,
        overwrite: overwrite,
      ),
      'bloc',
    );

    handleFileCreate(
      name,
      'event',
      path,
      extraFolder,
      EventSample(
        'bloc',
        name,
        overwrite: overwrite,
      ),
      'bloc',
    );
    handleFileCreate(
      name,
      'state',
      path,
      extraFolder,
      StateSample(
        'bloc',
        name,
        overwrite: overwrite,
      ),
      'bloc',
    );

    handleFileCreate(
      name,
      'view',
      path,
      extraFolder,
      GetViewSample('', name.pascalCase, basename(blocDir.path)),
      '',
    );

    handleFileCreate(
      name,
      'service',
      path,
      true,
      ServicesSample(
        'data/remote/services',
        name,
        overwrite: overwrite,
      ),
      'data/remote/services',
    );

    createFolder('src/$name/data/remote/requests');
    createFolder('src/$name/data/remote/responses');
    createFolder('src/$name/domain/mappers');
    createFolder('src/$name/domain/models');
    createFolder('src/$name/domain/usecases');
    createFolder('src/$name/domain/enums');

    handleFileCreate(
      name,
      'di',
      path,
      extraFolder,
      DiSample(
        'di',
        name,
        overwrite: overwrite,
      ),
      'di',
    );
    handleFileCreate(
      name,
      'mapper',
      path,
      extraFolder,
      MapperSample(
        'domain/mappers',
        name,
        overwrite: overwrite,
      ),
      'domain/mappers',
    );
    handleFileCreate(
      name,
      'repository',
      path,
      true,
      RepositorySample(
        'data/repository',
        name,
        overwrite: overwrite,
      ),
      'data/repository',
    );

    handleFileCreate(
      name,
      'repository_impl',
      path,
      true,
      RepositoryImplSample(
        'data/repository',
        name,
        overwrite: overwrite,
      ),
      'data/repository',
    );

    LogService.success(
        LocaleKeys.sucess_module_create.trArgs([name.pascalCase]));
  }

  @override
  String get codeSample => 'get create module:product';

  @override
  int get maxParameters => 0;
}
