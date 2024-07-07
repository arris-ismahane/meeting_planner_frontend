import 'package:get_it/get_it.dart';
import 'package:meeting_planner/managers/auth_manager.dart';

abstract class Injector {
  static AuthManager provideAuthManager() {
    return GetIt.instance.get<AuthManager>();
  }
}
