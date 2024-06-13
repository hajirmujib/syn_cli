import 'package:base_pkg/base_pkg.dart';
import 'package:bloc_skeleton/di.config.dart';

@InjectableInit()
Future configureDependencies() => GetIt.instance.init();
