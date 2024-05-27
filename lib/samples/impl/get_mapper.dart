import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class MapperSample extends Sample {
  final String _fileName;
  MapperSample(super.path, this._fileName, {super.overwrite});

  @override
  String get content => flutterDi;

  String get flutterDi => "";
}
