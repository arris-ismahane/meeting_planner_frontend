import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:meeting_planner/managers/auth_manager.dart';
import 'package:meeting_planner/managers/http_interceptor.dart';
import 'package:meeting_planner/managers/token_db_service.dart';
import 'package:meeting_planner/src/model/admin.dart';
import 'package:meeting_planner/src/services/booking_service.dart';
import 'package:meeting_planner/src/services/equipement_service.dart';
import 'package:meeting_planner/src/services/login_service.dart';
import 'package:meeting_planner/src/services/meeting_requirement_service.dart';
import 'package:meeting_planner/src/services/room_service.dart';
import 'package:meeting_planner/src/services/shared_equipment_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

RegExp emailRegExp = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
);

RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9,\-,_,.,@]+$');

const String URL_BASE =
    String.fromEnvironment("URL_BASE", defaultValue: "http://localhost:8080/");

Future<void> initDio() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  GetIt.instance.registerSingleton(TokenDbService(prefs));

  GetIt instance = GetIt.instance;
  Dio dio = Dio(BaseOptions(baseUrl: URL_BASE));
  CookieJar jar;
  if (kIsWeb) {
    jar = CookieJar();
    CookieManager manager = CookieManager(jar);
    dio.interceptors.add(manager);
  } else {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    jar = PersistCookieJar(storage: FileStorage(appDocPath));
    dio.interceptors.add(CookieManager(jar));
  }
  instance.registerSingleton(jar);
  dio.interceptors.add(HttpInterceptor());
  dio.options.baseUrl = URL_BASE;
  instance.registerSingleton(dio);
}

void initServices() {
  Dio dio = GetIt.instance.get();

  GetIt.instance.registerSingleton(LoginService(dio));
  GetIt.instance.registerSingleton(BookingService(dio));
  GetIt.instance.registerSingleton(MeetingRequirementService(dio));
  GetIt.instance.registerSingleton(RoomService(dio));
  GetIt.instance.registerSingleton(SharedEquipmentService(dio));
  GetIt.instance.registerSingleton(EquipementService(dio));

  GetIt.instance.registerSingleton(
    AuthManager(
      parser: (json) => Admin.fromJson(json),
      serializer: (client) => client.toJson(),
    ),
  );
}
