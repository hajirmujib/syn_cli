import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:syn_cli/extensions.dart';

import '../../../../common/utils/json_serialize/response_generator.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../exception_handler/exceptions/cli_exception.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../models/file_model.dart';
import '../../../interface/command.dart';

class GenerateResponseCommand extends Command {
  @override
  String get commandName => 'response';
  @override
  Future<void> execute({String nameResponse = ''}) async {
    var name = p.basenameWithoutExtension(withArgument).pascalCase;
    if (nameResponse.isEmpty) {
      if (withArgument.isEmpty) {
        var result = ask(LocaleKeys.ask_responnse_name.tr);
        name = result.pascalCase;
      }
    } else {
      name = nameResponse.pascalCase;
    }

    FileModel newFileModel;

    final responseGenerator = ResponseGenerator(
        name, containsArg('--private'), containsArg('--withCopy'));

    newFileModel =
        Structure.model("${name}Response", 'response', false, on: onCommand);

    var modelPath = '${newFileModel.path}.dart';
    print(newFileModel.path);
    var pathSplit = Structure.safeSplitPath(modelPath);

    pathSplit.removeWhere((element) => element == '.' || element == 'lib');
    var splitPathGenerated = pathSplit.last.replaceAll('.dart', '.g.dart');
// final responseGenerator = ResponseGenerator('MyRootClass');
    final headerString =
        "import 'package:json_annotation/json_annotation.dart';\npart '$splitPathGenerated';\n\n@JsonSerializable()\n";
    final dartCode = responseGenerator.generateDartClasses(await _jsonRawData,
        header: headerString);

    writeFile('lib/src/${pathSplit[1]}/data/remote/responses/${pathSplit.last}',
        dartCode.result,
        overwrite: true);

    for (var warning in dartCode.warnings) {
      LogService.info('warning: ${warning.path} ${warning.warning} ');
    }
  }

  @override
  String? get hint => LocaleKeys.hint_generate_model.tr;

  @override
  bool validate() {
    if ((withArgument.isEmpty || p.extension(withArgument) != '.json') &&
        fromArgument.isEmpty) {
      var codeSample =
          'get generate response on home with assets/models/user.json';
      throw CliException(LocaleKeys.error_invalid_json.trArgs([withArgument]),
          codeSample: codeSample);
    }
    return true;
  }

  Future<String> get _jsonRawData async {
    if (withArgument.isNotEmpty) {
      return await File(withArgument).readAsString();
    } else {
      try {
        var result = await get(Uri.parse(fromArgument));
        return result.body;
      } on Exception catch (_) {
        throw CliException(
            LocaleKeys.error_failed_to_connect.trArgs([fromArgument]));
      }
    }
  }

  final String? codeSample1 = LogService.code(
      'get generate response on home with assets/responses/user.json');
  final String? codeSample2 = LogService.code(
      'get generate response on home from "https://api.github.com/users/CpdnCristiano"');

  @override
  String get codeSample => '''
  $codeSample1
  or
  $codeSample2
''';

  @override
  int get maxParameters => 0;
}
