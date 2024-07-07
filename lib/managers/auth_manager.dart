import 'dart:async';
import 'dart:convert';

import 'package:meeting_planner/managers/auth_status.dart';
import 'package:meeting_planner/src/model/admin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  final String key = 'auth_manager_user_key';
  final BehaviorSubject<AuthStatus> subject =
      BehaviorSubject.seeded(AuthStatus.undefined);

  final BehaviorSubject<Admin?> userSubject = BehaviorSubject();

  final Admin Function(Map<String, dynamic>) parser;
  final Map<String, dynamic> Function(Admin user) serializer;
  late StreamSubscription _subscription;
  final rolesStream = BehaviorSubject.seeded(<String>{});

  AuthManager({
    required this.parser,
    required this.serializer,
  }) {
    _init();
  }

  void _init() async {
    _subscribe();
    add(AuthStatus.progress);
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    if (value != null) {
      try {
        var user = parser(json.decode(value));
        userSubject.add(user);
        add(AuthStatus.logged_in);
        rolesStream.add(user.roles.map((e) => e.name).toSet());
      } catch (error) {
        /**
         * Could not parse data
         */
        remove();
        add(AuthStatus.logged_out);
      }
    }

    /**
     * If it is still in progress mode and could not read anything!
     */

    if (subject.value == AuthStatus.progress) {
      add(AuthStatus.logged_out);
    }
  }

  void _subscribe() {
    _subscription = userSubject.listen((value) {
      if (value == null) {
        add(AuthStatus.logged_out);
      } else {
        add(AuthStatus.logged_in);
      }
    });
  }

  add(AuthStatus status, [bool force = false]) {
    if (force) {
      subject.add(status);
    } else if (subject.valueOrNull != status) {
      subject.add(status);
    }
  }

  bool hasRole(String role) => rolesStream.value.contains(role);

  bool get isLoggedIn {
    return subject.value == AuthStatus.logged_in;
  }

  Future<void> save(Admin? user) async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, json.encode(serializer(user)));
      userSubject.add(user);
      rolesStream.add(user.roles.map((e) => e.name).toSet());
    }
  }

  Future remove() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    userSubject.add(null);
  }

  Admin? get currentAdmin => userSubject.valueOrNull;

  void close() {
    _subscription.cancel();
    subject.close();
    userSubject.close();
  }
}
