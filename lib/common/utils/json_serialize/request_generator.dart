import 'dart:collection';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dart_style/dart_style.dart';
import 'package:syn_cli/enum/key_value_dto.dart';

import '../pubspec/pubspec_utils.dart';
import 'helpers.dart';
import 'json_ast/json_ast.dart' show parse, Settings, Node;
import 'sintaxe.dart';

class DartCode extends WithWarning<String> {
  DartCode(super.result, super.warnings);

  String get code => result;
}

/// A Hint is a user type correction.
class Hint {
  final String path;
  final String type;

  Hint(this.path, this.type);
}

class RequestGenerator {
  final String _rootClassName;
  final bool _privateFields;
  final bool? _withCopyConstructor;
  final List<ClassDefinition> allClasses = <ClassDefinition>[];
  final Map<String, String> sameClassMapping = HashMap<String, String>();
  late List<Hint> hints;

  RequestGenerator(this._rootClassName,
      [this._privateFields = false,
      this._withCopyConstructor,
      List<Hint>? hints]) {
    if (hints != null) {
      this.hints = hints;
    } else {
      this.hints = <Hint>[];
    }
  }

  Hint? _hintForPath(String path) {
    return hints.firstWhereOrNull((h) => h.path == path);
  }

  List<KeyValueDto> classSimillarResponse = [];

  List<Warning> _generateClassDefinition(String className,
      dynamic jsonRawDynamicData, String path, Node? astNode) {
    var warnings = <Warning>[];
    if (jsonRawDynamicData is List) {
      // if first element is an array, start in the first element.
      final node = navigateNode(astNode, '0');
      _generateClassDefinition(className, jsonRawDynamicData[0], path, node);
    } else {
      final jsonRawData = jsonRawDynamicData as Map;
      final keys = jsonRawData.keys.cast<String>();
      var classDefinition = ClassDefinition(className, _rootClassName,
          _privateFields, _withCopyConstructor, true);

      for (var key in keys) {
        TypeDefinition typeDef;
        final hint = _hintForPath('$path/$key');
        final node = navigateNode(astNode, key);
        if (hint != null) {
          typeDef = TypeDefinition(hint.type, astNode: node);
        } else {
          typeDef = TypeDefinition.fromDynamic(jsonRawData[key], node);
        }
        if (typeDef.name == 'Class') {
          typeDef.name = "${camelCase(key)}Request";
        }
        if (typeDef.name == 'List' && typeDef.subtype == 'Null') {
          warnings.add(newEmptyListWarn('$path/$key'));
        }
        if (typeDef.subtype != null && typeDef.subtype == 'Class') {
          typeDef.subtype = "${camelCase(key)}Request";
        }
        if (typeDef.name == 'Class?') {
          typeDef.name = '${"${camelCase(key)}Request"}?';
        }
        if (typeDef.isAmbiguous!) {
          warnings.add(newAmbiguousListWarn('$path/$key'));
        }
        classDefinition.addField(key, typeDef);
      }

      final similarClass =
          allClasses.firstWhereOrNull((cd) => cd == classDefinition);
      if (similarClass != null) {
        classSimillarResponse.add(
            KeyValueDto(key: similarClass.name, value: classDefinition.name));
        final similarClassName = PubspecUtils.nullSafeSupport
            ? '${similarClass.name}?'
            : similarClass.name;

        final currentClassName = PubspecUtils.nullSafeSupport
            ? ' ${classDefinition.name}?'
            : classDefinition.name;

        sameClassMapping["${currentClassName}Request"] =
            "${similarClassName}Request";
      } else {
        allClasses.add(classDefinition);
      }

      final dependencies = classDefinition.dependencies;

      for (var dependency in dependencies) {
        List<Warning>? warns;
        if (dependency.typeDef.name == 'List') {
          // only generate dependency class if the array is not empty
          if ((jsonRawData[dependency.name] as List).isNotEmpty) {
            // when list has ambiguous values, take the first one,
            // otherwise merge all objects
            // into a single one
            dynamic toAnalyze;
            if (!dependency.typeDef.isAmbiguous!) {
              var mergeWithWarning = mergeObjectList(
                  jsonRawData[dependency.name] as List,
                  '$path/${dependency.name}Request');
              toAnalyze = mergeWithWarning.result;
              warnings.addAll(mergeWithWarning.warnings);
            } else {
              toAnalyze = jsonRawData[dependency.name][0];
            }
            final node = navigateNode(astNode, dependency.name);
            warns = _generateClassDefinition("${dependency.className}Request",
                toAnalyze, '$path/${dependency.name}Request', node);
          }
        } else {
          final node = navigateNode(astNode, dependency.name);
          warns = _generateClassDefinition(
              "${dependency.className}Request",
              jsonRawData[dependency.name],
              '$path/${dependency.name}Request',
              node);
        }
        if (warns != null) {
          warnings.addAll(warns);
        }
      }
    }
    return warnings;
  }

  /// generateUnsafeDart will generate all classes and append one after another
  /// in a single string. The [rawJson] param is assumed to be a properly
  /// formatted JSON string. The dart code is not validated so invalid dart code
  /// might be returned
  DartCode generateUnsafeDart(String rawJson, {String header = ''}) {
    final jsonRawData = decodeJSON(rawJson);
    final astNode = parse(rawJson, Settings());
    var warnings = _generateClassDefinition(
        "${_rootClassName}Request", jsonRawData, '', astNode);
    // after generating all classes, replace the omited similar classes.
    for (var c in allClasses) {
      final fieldsKeys = c.fields.keys;
      for (var f in fieldsKeys) {
        final typeForField = c.fields[f]!;
        var fieldName = typeForField.name;

        if (sameClassMapping.containsKey(fieldName)) {
          c.fields[f]!.name = sameClassMapping[fieldName];
        }

        // check subtype for list
        if (fieldName == 'List') {
          fieldName = PubspecUtils.nullSafeSupport
              ? '${typeForField.subtype}?'
              : typeForField.subtype;

          if (sameClassMapping.containsKey(fieldName)) {
            c.fields[f]!.subtype =
                sameClassMapping[fieldName]!.replaceAll('?', '');
          }
        }
      }
    }

    for (var element in allClasses) {
      replaceQuizAnswerResponse(element);
    }
    // Add the header to the generated code
    final code = header + allClasses.map((c) => c.toString()).join('\n');
    return DartCode(code, warnings);
  }

  // Method to replace 'simmilar class mode'
  void replaceQuizAnswerResponse(ClassDefinition classDefinition) {
    // Replace in fields
    classDefinition.fields.forEach((key, typeDef) {
      var valueClassSimillar = classSimillarResponse.firstWhere(
        (element) => element.value == typeDef.name!.replaceAll("?", ''),
        orElse: () => KeyValueDto(key: ""),
      );
      if (valueClassSimillar.key.isNotEmpty) {
        typeDef.name = typeDef.name!
            .replaceAll(typeDef.name ?? "", "${valueClassSimillar.key}?");
      }
    });
  }

  /// generateDartClasses will generate all classes and append one after another
  /// in a single string. The [rawJson] param is assumed to be a properly
  /// formatted JSON string. If the generated dart is invalid it will throw
  /// an error.
  DartCode generateDartClasses(String rawJson, {String header = ''}) {
    final unsafeDartCode = generateUnsafeDart(rawJson, header: header);
    final formatter = DartFormatter();
    return DartCode(
        formatter.format(unsafeDartCode.code), unsafeDartCode.warnings);
  }
}
