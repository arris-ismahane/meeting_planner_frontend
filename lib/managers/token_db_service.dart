import 'package:shared_preferences/shared_preferences.dart';

class TokenDbService {
  static const String key = "token_key";

  SharedPreferences sharedPreferences;

  TokenDbService(this.sharedPreferences);

  Future<bool> save(String token) async {
    var r1 = await sharedPreferences.setString(key, token);
    return r1;
  }

  String? getToken() => sharedPreferences.getString(key);

  Future<bool> remove() async {
    return sharedPreferences.remove(key);
  }
}
