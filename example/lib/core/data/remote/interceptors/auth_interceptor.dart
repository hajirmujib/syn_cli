import 'package:base_pkg/base_pkg.dart';
import 'package:bloc_skeleton/core/data/local/app_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var headers = <String, dynamic>{};

    var prefs = GetIt.instance<AppPreferences>();
    if (prefs.getToken() != null) {
      headers.addAll({
        "Authorization": "Bearer ${prefs.getToken()}"
      });
    }

    options.headers = headers;

    return super.onRequest(options, handler);
  }
}
