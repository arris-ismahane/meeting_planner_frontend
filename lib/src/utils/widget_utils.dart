import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_responsive_tools/responsive_builder.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_tools/device_screen_type.dart';
import 'package:get_it/get_it.dart';
import 'package:meeting_planner/managers/injector.dart';
import 'package:meeting_planner/managers/token_db_service.dart';
import 'package:meeting_planner/src/settings/lang.dart';
import 'package:meeting_planner/src/pages/home/login_page.dart';
import 'package:meeting_planner/src/utils/alert_vertical_widget.dart';
import 'package:meeting_planner/src/utils/route_guard_widget.dart';

class WidgetUtils {
  static Widget wrapRoute(
      Widget Function(BuildContext context, DeviceScreenType type) route,
      {guard = true,
      useTemplate = true}) {
    final _authManager = Injector.provideAuthManager();
    if (guard) {
      return RouteGuardWidget(
        authStream: _authManager.subject,
        loggedOutBuilder: (context) => const LoginPage(),
        childBuilder: (context) {
          var user = _authManager.currentAdmin;
          if (user != null) {
            return ResponsiveBuilder((context, info) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: route(context, info.type),
                ));
          } else {
            return const LoginPage();
          }
        },
      );
    }
    return ResponsiveBuilder((context, info) => route(context, info.type));
  }
}

AppBar defaultAppBar(BuildContext context, {List<Widget>? actions}) {
  return AppBar(
    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logo-no-bg.png",
          height: 45,
          scale: 1.0,
        )
      ],
    ),
    actions: actions,
  );
}

Widget wrap(Widget child, {double radius = 16}) => Container(
    decoration: BoxDecoration(
        color: const Color(0xFFf2f2f2),
        borderRadius: BorderRadius.all(Radius.circular(radius))),
    child: child);

Widget logoutButton(BuildContext context) {
  var lang = getLang(context);
  return wrap(TextButton(
    onPressed: () async {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(lang.confirm),
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
      ).asStream().where((event) => event).asyncMap((event) async {
        // final service = GetIt.instance.get<TokenService>();
        var dbService = GetIt.instance.get<TokenDbService>();
        //try {
        // var token = await FirebaseMessaging.instance.getToken();
        // if (token != null) {
        //   await service.removeToken(token);
        // }
        // } catch (error, stacktrace) {
        //   print(stacktrace);
        //   showServerError2(context, error: error);
        // }

        dbService.remove();
        final userManager = Injector.provideAuthManager();
        return userManager.remove();
      }).listen((event) {
        //print("logged out");
      });
    },
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          const Icon(Icons.logout),
          const Gap(10),
          Text(lang.logout),
        ],
      ),
    ),
  ));
}

Future showDialogEndDateGreater(BuildContext context, {String? text}) {
  var lang = getLang(context);
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SizedBox(
        height: 250,
        width: 400,
        child: AlertVerticalWidget(
          "message",
          type: AlertType.WARNING,
          iconData: Icons.warning,
          iconSize: 64,
          margin: 10,
          color: Colors.red,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(lang.ok),
        ),
      ],
    ),
  );
}

Future<DateTime?> selectDate(
  BuildContext context, {
  bool disableWeekend = true,
  required DateTime? initialValue,
  DateTime? lastDate,
  DateTime? firstDate,
  List<int> weekend = const <int>[6, 7],
}) {
  return showDatePicker(
    context: context,
    initialDate: initialValue,
    firstDate: firstDate ?? DateTime.now().add(Duration(days: -365 * 150)),
    lastDate: lastDate ?? DateTime.now().add(Duration(days: 365 * 150)),
    selectableDayPredicate: (DateTime date) {
      weekend.contains(disableWeekend);
      return disableWeekend ? !weekend.contains(date.weekday) : true;
    },
  ).asStream().map(
    (event) {
      return event == null
          ? null
          : DateTime(event.year, event.month, event.day);
    },
  ).first;
}

Future<TimeOfDay?> selectTime(
  BuildContext context, {
  TimeOfDay? initialValue,
  double minHour = 0,
  double maxHour = 23,
}) async {
  TimeOfDay? picked;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SizedBox(
        width: 400,
        height: 300,
        child: showPicker(
          context: context,
          value: Time(
              hour: initialValue?.hour ?? TimeOfDay.now().hour, minute: 00),
          is24HrFormat: true,
          disableMinute: true,
          displayHeader: false,
          isInlinePicker: true,
          elevation: 0,
          borderRadius: 25,
          contentPadding: EdgeInsets.all(0),
          dialogInsetPadding: EdgeInsets.all(0),
          width: 200,
          height: 250,
          minHour: minHour,
          maxHour: maxHour,
          onChange: (p0) {
            picked = TimeOfDay(hour: p0.hour, minute: 00);
            Navigator.of(context).pop();
          },
        ),
      ),
    ),
  );

  return Future.value(picked);
}

Future<int?> selectYear(
  BuildContext context, {
  int? initialValue,
  String? title,
}) {
  int? picked = initialValue ?? DateTime.now().year;
  return showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? getLang(context).select),
        content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              lastDate: DateTime(DateTime.now().year + 25),
              firstDate: DateTime((DateTime.now().year) - 100),
              selectedDate: DateTime(picked),
              dragStartBehavior: DragStartBehavior.start,
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime.year);
              },
            )),
      );
    },
  );
}

StepperType getStepperType(DeviceScreenType type) {
  switch (type) {
    case DeviceScreenType.mobile:
      return StepperType.vertical;
    case DeviceScreenType.tablet:
      return StepperType.vertical;
    case DeviceScreenType.desktop:
      return StepperType.horizontal;
  }
}
