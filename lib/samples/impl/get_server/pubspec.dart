import '../../interface/sample_interface.dart';

/// [Sample] file from pubspec.yaml file creation.
class GetServerPubspecSample extends Sample {
  String name;
  GetServerPubspecSample(this.name) : super('pubspec.yaml', overwrite: true);

  @override
  String get content => '''name: $name
description: A new Get Server application.
version: 1.0.0

environment:
  sdk: '>=2.19.0 <4.0.0'

dependencies:

dev_dependencies:

''';
}
