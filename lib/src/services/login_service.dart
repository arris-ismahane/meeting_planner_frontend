import 'package:dio/dio.dart';
import 'package:meeting_planner/src/model/auth_result.dart';
import 'package:meeting_planner/src/model/login_object.dart';

import 'package:retrofit/retrofit.dart';

part 'login_service.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio) = _LoginService;

  @POST("/auth/login")
  Future<AuthResult> login({
    @Body() required LoginObject loginObject,
  });
}
