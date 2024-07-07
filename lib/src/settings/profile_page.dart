import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:meeting_planner/main.dart';
import 'package:meeting_planner/managers/injector.dart';
import 'package:meeting_planner/managers/token_db_service.dart';
import 'package:meeting_planner/src/model/admin.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/settings/lang.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';

class ProfilePage extends StatefulWidget {
  static const URL = "/Profile";

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BasicState<ProfilePage> with WidgetUtils {
  final authMan = Injector.provideAuthManager();

  final service = GetIt.instance.get<TokenDbService>();

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => StreamBuilder<Admin?>(
          stream: authMan.userSubject,
          initialData: authMan.userSubject.valueOrNull,
          builder: (context, snapshot) {
            var user = snapshot.data;
            if (user == null) {
              return const SizedBox.shrink();
            }
            return Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${user.lastName.toUpperCase()} ${user.firstName}",
                                style: const TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              user.roles
                                  .map((e) => e.name)
                                  .where((element) => element.isNotEmpty)
                                  .join(", "),
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          const SizedBox(height: 20),
                          wrap(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.globe),
                                    const SizedBox(width: 10),
                                    Text(lang.changeLanguage),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  textDirection: TextDirection.ltr,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children:
                                      settingsController.supportedLocales.map(
                                    (e) {
                                      if (settingsController.locale == e) {
                                        return FilledButton(
                                            onPressed: () {
                                              settingsController
                                                  .updateLocale(e);
                                            },
                                            child: Text(lang
                                                .getLangName(e.languageCode)));
                                      }
                                      return OutlinedButton(
                                          onPressed: () {
                                            settingsController.updateLocale(e);
                                          },
                                          child: Text(lang
                                              .getLangName(e.languageCode)));
                                    },
                                  ).toList(),
                                )
                              ],
                            ),
                          )),
                          const SizedBox(height: 20),
                          wrap(TextButton(
                            onPressed: _logout,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.logout),
                                  const SizedBox(width: 10),
                                  Text(lang.logout),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(lang.pleaseConfirm),
        content: Text(lang.confirmLogout),
        actions: <Widget>[
          TextButton(
            child: Text(lang.no.toUpperCase()),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(lang.yes.toUpperCase()),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    ).asStream().where((event) => event ?? false).asyncMap((event) {
      return authMan.remove();
    }).asyncMap((event) {
      return service.remove();
    }).listen((event) {
      Navigator.of(context).pop(true);
    });
  }
}
