import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:syn_cli/samples/impl/get_bloc.dart';
import 'package:syn_cli/samples/impl/get_event.dart';
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
class CreatePageCommand extends Command {
  @override
  String get commandName => 'page';

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
  String? get hint => LocaleKeys.hint_create_page.tr;

  void checkForAlreadyExists(String? name) {
    var newFileModel =
        Structure.model(name, 'page', true, on: onCommand, folderName: name);
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
        title:
            Translation(LocaleKeys.ask_existing_page.trArgs([name])).toString(),
      );
      final result = menu.choose();
      if (result.index == 0) {
        _writeFiles(path, name!, overwrite: true);
      } else if (result.index == 2) {
        // final dialog = CLI_Dialog();
        // dialog.addQuestion(LocaleKeys.ask_new_page_name.tr, 'name');
        // name = dialog.ask()['name'] as String?;
        var name = ask(LocaleKeys.ask_new_page_name.tr);
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

    LogService.success(LocaleKeys.sucess_page_create.trArgs([name.pascalCase]));
  }

  @override
  String get codeSample => 'get create page:product';

  @override
  int get maxParameters => 0;
}
