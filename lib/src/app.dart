import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:meeting_planner/managers/injector.dart';
import 'package:meeting_planner/managers/token_db_service.dart';
import 'package:meeting_planner/src/model/admin.dart';
import 'package:meeting_planner/src/router_config.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/settings/settings_controller.dart';
import 'package:meeting_planner/src/settings/side_menu_button.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';

class MyApp extends StatefulWidget {
  final SettingsController settingsController;

  MyApp({
    super.key,
    required this.settingsController,
  });

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends BasicState<MyApp> with RouteAware {
  final authMan = Injector.provideAuthManager();
  final tokenDbService = GetIt.instance.get<TokenDbService>();
  ScrollBehavior scrollBehavior = MaterialScrollBehavior().copyWith(
    dragDevices: {
      PointerDeviceKind.mouse,
      PointerDeviceKind.touch,
      PointerDeviceKind.stylus,
      PointerDeviceKind.unknown
    },
    scrollbars: true,
    overscroll: true,
  );

  static const localizationsDelegates2 = const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  @override
  void initState() {
    setLang(widget.settingsController.locale);
    super.initState();
  }

  bool inited = false;
  Future _init(BuildContext context) async {
    if (inited) {
      return;
    }
    inited = true;
    initRouter(context);
  }

  void setLang(Locale locale) {
    widget.settingsController.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.settingsController,
      builder: (BuildContext context, Widget? child) => MaterialApp(
        navigatorObservers: [MyNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        scrollBehavior: scrollBehavior,
        locale: widget.settingsController.locale,
        localizationsDelegates: localizationsDelegates2,
        supportedLocales: widget.settingsController.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 33, 201, 243)),
          useMaterial3: true,
          textTheme: TextTheme(),
        ),
        navigatorKey: navKey,
        onGenerateRoute: router.generator,
        builder: (context, child) {
          _init(context);
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) {
                  return Row(
                    children: [
                      StreamBuilder<Admin?>(
                        stream: authMan.userSubject,
                        initialData: authMan.currentAdmin,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return SizedBox.shrink();
                          }
                          var user = snapshot.data!;
                          return Container(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            width: 300,
                            child: StreamBuilder(
                              stream: currentLocationStream,
                              initialData: currentLocationStream.valueOrNull,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox.shrink();
                                }
                                var url = snapshot.data!;
                                return mainMenu(url, context, user);
                              },
                            ),
                          );
                        },
                      ),
                      Expanded(child: child ?? SizedBox.shrink()),
                    ],
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget mainMenu(String url, BuildContext context, Admin user) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gap(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${user.lastName} ${user.firstName}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                  Gap(10),
                  Tooltip(
                    message: user.roles
                        .map((e) => e.name)
                        .where((element) => element.isNotEmpty)
                        .join(", "),
                    child: SizedBox(
                      width: 200,
                      child: Center(
                        child: Text(
                          user.roles
                              .map((e) => e.name)
                              .where((element) => element.isNotEmpty)
                              .join(", "),
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ),
                  Gap(20),
                  ...menuButtonList.map(
                    (e) {
                      return SizedBox(
                        height: 60,
                        width: 270,
                        child: SideMenuButton(
                          showTooltip: false,
                          title: e.getTitle(context),
                          iconData: e.icon,
                          activeIcon: e.activeIcon,
                          isActive: url == e.routeName,
                          onTap: () {
                            var url = e.routeName;
                            if (!url.startsWith("/")) {
                              url = "/${url}";
                            }
                            router.navigateTo(navKey.currentContext!, url);
                          },
                        ),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final navKey = GlobalKey<NavigatorState>();

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    currentLocationStream.add(route.settings.name ?? '/');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    currentLocationStream.add(previousRoute?.settings.name ?? '/');
  }
}
