import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:meeting_planner/managers/injector.dart';
import 'package:meeting_planner/managers/token_db_service.dart';

class HttpInterceptor extends Interceptor {
  final TokenDbService _service = GetIt.instance.get();

  @override
  Future onRequest(RequestOptions options, handler) async {
    var token = _service.getToken();
    if (token != null) {
      options.headers.putIfAbsent("Authorization", () => "Bearer $token");
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, handler) async {
    if (response.statusCode == 403) {
      _logout();
    }

    handler.next(response);
  }

  @override
  void onError(DioError err, handler) async {
    if (err.response?.statusCode == 403) {
      _logout();
    }
    handler.next(err);
  }

  void _logout() {
    try {
      _service.remove();
      final _authMan = Injector.provideAuthManager();
      _authMan.remove();
    } catch (error) {
      //print("error $error");
    }
  }
}
