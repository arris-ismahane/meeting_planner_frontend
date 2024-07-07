import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meeting_planner/managers/auth_status.dart';
import 'package:meeting_planner/managers/injector.dart';
import 'package:meeting_planner/managers/token_db_service.dart';
import 'package:meeting_planner/src/model/admin.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:http_error_handler/error_handler.dart';

import 'package:meeting_planner/src/model/login_object.dart';
import 'package:meeting_planner/src/services/login_service.dart';
import 'package:meeting_planner/src/utils/password_input.dart';
import 'package:meeting_planner/src/utils/progress_wrapper.dart';
import 'package:meeting_planner/src/utils/ui_utils.dart';
import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/validations.dart';
import 'package:rxdart/rxdart.dart';

class LoginPage extends StatefulWidget {
  static const login = "/login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BasicState<LoginPage> with UtilsMixin {
  final key = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final errorStream = BehaviorSubject.seeded("");
  final service = GetIt.instance.get<LoginService>();

  final _authMan = Injector.provideAuthManager();
  final _tokenDbService = GetIt.instance.get<TokenDbService>();
  @override
  void initState() {
    errorStream
        .where((event) => event.isNotEmpty && key.currentState != null)
        .map((event) => key.currentState!)
        .listen((state) => state.validate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            width: 450,
            child: Card(
              child: Form(
                key: key,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            lang.appName.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 35),
                        UiUtils.requiredPostFix(lang.username, true),
                        Gap(10),
                        TextFormField(
                          controller: usernameCtrl,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          validator: (text) {
                            if (errorStream.value.isNotEmpty) {
                              return "";
                            }
                            return Validations.requiredField(text, context);
                          },
                          decoration: getDecoration("", false),
                        ),
                        Gap(20),
                        UiUtils.requiredPostFix(lang.password, true, 100),
                        Gap(10),
                        PasswordInput(
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (p0) {
                            _login(context);
                          },
                          controller: passwordCtrl,
                          validator: (text) {
                            if (errorStream.value.isNotEmpty) {
                              return "";
                            }
                            return Validations.requiredField(text, context);
                          },
                        ),
                        Gap(50),
                        Row(
                          children: [
                            Expanded(
                              child: ProgressWrapper(
                                progressStream: progressSubject,
                                child: FilledButton(
                                  onPressed: () {
                                    _login(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(lang.login),
                                  ),
                                ),
                                progressChild: FilledButton(
                                  onPressed: null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(lang.login),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(10),
                        StreamBuilder<String>(
                          stream: errorStream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox.shrink();
                            }
                            var text = snapshot.data!;

                            if (text.isEmpty) {
                              return SizedBox.shrink();
                            }
                            return Center(child: UiUtils.errorText(text));
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    var state = key.currentState;
    if (state != null) {
      if (state.validate()) {
        LoginObject object = LoginObject(
            username: usernameCtrl.text, password: passwordCtrl.text);
        try {
          var result = await service.login(loginObject: object);
          await handleLogin(result.token, result.admin);
        } catch (error, stacktrace) {
          showServerError(context, error: error);
          print(stacktrace);
        }
      }
    }
  }

  Future<void> handleLogin(String token, Admin user) async {
    await _tokenDbService.save(token);
    await _authMan.save(user);
    _authMan.add(AuthStatus.logged_in);
    _authMan.rolesStream.add(user.roles.map((e) => e.name).toSet());
  }

  @override
  List<ChangeNotifier> get notifiers => [usernameCtrl, passwordCtrl];

  @override
  List<Subject> get subjects => [];
}
