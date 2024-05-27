import 'dart:io';

import 'package:path/path.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/internationalization.dart';
import '../../core/locales.g.dart';
import '../../core/structure.dart';
import '../../samples/interface/sample_interface.dart';
import '../sorter_imports/sort.dart';

void createFolder(String? folderName) {
  // Specify the base directory where you want to create the folder
  Directory baseDirectory = Directory('lib');

  // Create the folder path
  String folderPath = folderName != null
      ? '${baseDirectory.path}/$folderName'
      : baseDirectory.path;

  // Create the Directory object
  Directory directory = Directory(folderPath);

  // Check if the directory already exists
  if (!directory.existsSync()) {
    // If the directory does not exist, create it
    directory.createSync(recursive: true);

    LogService.success('Folder "$folderName" created successfully.');
  } else {
    LogService.success('Folder "$folderName" already exists.');
  }
}

File handleFileCreate(String name, String command, String on, bool extraFolder,
    Sample sample, String folderName,
    [String sep = '_']) {
  folderName = folderName;
  /* if (folderName.isNotEmpty) {
    extraFolder = PubspecUtils.extraFolder ?? extraFolder;
  } */
  final fileModel = Structure.model(name, command, extraFolder,
      on: on, folderName: folderName);
  var path =
      '${fileModel.path}$sep${fileModel.commandName}${command == "di" ? "_module" : ""}.dart';
  sample.path = path;
  return sample.create();
}

Future<String> handleUpdateCreate(String path, String content,
    {bool isEndFile = false}) async {
  File file = File(path);

  String fileContent = await file.readAsString();
  String updatedContent = '';
  if (!isEndFile) {
// Step 2: Modify the file content
    // Find the position of the last '}' in the ExampleService class
    int lastClosingBracePosition = fileContent.lastIndexOf('}');
    if (lastClosingBracePosition == -1) {
      print('No closing brace found in the file.');
      return '';
    }
    // Insert the new line before the last closing brace
    updatedContent =
        '${fileContent.substring(0, lastClosingBracePosition)}\n  $content\n${fileContent.substring(lastClosingBracePosition)}';
  } else {
    updatedContent = "$updatedContent\n$content";
  }

  await file.writeAsString(updatedContent);
  return 'success';
}

/// Create or edit the contents of a file
File writeFile(String path, String content,
    {bool overwrite = false,
    bool skipFormatter = false,
    bool logger = true,
    bool skipRename = false,
    bool useRelativeImport = false}) {
  var newFile = File(Structure.replaceAsExpected(path: path));

  if (!newFile.existsSync() || overwrite) {
    if (!skipFormatter) {
      if (path.endsWith('.dart')) {
        try {
          content = sortImports(
            content,
            renameImport: !skipRename,
            filePath: path,
            useRelative: useRelativeImport,
          );
        } on Exception catch (_) {
          if (newFile.existsSync()) {
            LogService.info(
                LocaleKeys.error_invalid_dart.trArgs([newFile.path]));
          }
          rethrow;
        }
      }
    }
    if (!skipRename && newFile.path != 'pubspec.yaml') {
      var separatorFileType = PubspecUtils.separatorFileType!;
      if (separatorFileType.isNotEmpty) {
        newFile = newFile.existsSync()
            ? newFile = newFile
                .renameSync(replacePathTypeSeparator(path, separatorFileType))
            : File(replacePathTypeSeparator(path, separatorFileType));
      }
    }

    newFile.createSync(recursive: true);
    newFile.writeAsStringSync(content);
    if (logger) {
      LogService.success(
        LocaleKeys.sucess_file_created.trArgs(
          [basename(newFile.path), newFile.path],
        ),
      );
    }
  }
  return newFile;
}

/// Replace the file name separator
String replacePathTypeSeparator(String path, String separator) {
  if (separator.isNotEmpty) {
    var index = path.indexOf(RegExp(r'controller.dart|model.dart|provider.dart|'
        'binding.dart|view.dart|screen.dart|widget.dart|repository.dart'));
    if (index != -1) {
      var chars = path.split('');
      index--;
      chars.removeAt(index);
      if (separator.length > 1) {
        chars.insert(index, separator[0]);
      } else {
        chars.insert(index, separator);
      }
      return chars.join();
    }
  }

  return path;
}
