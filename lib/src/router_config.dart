import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_planner/src/model/classes/equipement.dart';
import 'package:meeting_planner/src/pages/booking/booking_table.dart';
import 'package:meeting_planner/src/pages/booking/meeting_form.dart';
import 'package:meeting_planner/src/pages/dashboard/dashboard.dart';
import 'package:meeting_planner/src/pages/equipemet/equipement_list.dart';
import 'package:meeting_planner/src/pages/meeting_requirement/meeting_requirement_form.dart';
import 'package:meeting_planner/src/pages/meeting_requirement/meeting_requirement_table.dart';
import 'package:meeting_planner/src/pages/room/room_form.dart';
import 'package:meeting_planner/src/pages/room/room_table.dart';
import 'package:meeting_planner/src/pages/shared_equipements/shared_equipement_table.dart';
import 'package:meeting_planner/src/pages/shared_equipements/shared_equipements_form.dart';
import 'package:meeting_planner/src/settings/lang.dart';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:meeting_planner/src/settings/profile_page.dart';

import 'package:rxdart/rxdart.dart';

final router = FluroRouter();

final currentLocationStream = BehaviorSubject<String>();
final List<MenuButtonInfo> patientMenuButtons = [];

final menuButtonList = [
  MenuButtonInfo(
    routeName: "/",
    icon: FontAwesomeIcons.house,
    destinationRoute: (context, params) => Dashboard(),
    getTitle: (context) => getLang(context).homePage,
  ),
  MenuButtonInfo(
      routeName: EquipemetList.URL,
      icon: FontAwesomeIcons.video,
      destinationRoute: (context, params) => EquipemetList(),
      getTitle: (context) => getLang(context).equipments),
  MenuButtonInfo(
      routeName: SharedEquipmentTable.URL,
      icon: FontAwesomeIcons.headset,
      destinationRoute: (context, params) => SharedEquipmentTable(),
      getTitle: (context) => getLang(context).sharedEquipments),
  MenuButtonInfo(
      routeName: MeetingRequirementTable.URL,
      icon: FontAwesomeIcons.users,
      destinationRoute: (context, params) => MeetingRequirementTable(),
      getTitle: (context) => getLang(context).meetingRequirements),
  MenuButtonInfo(
      routeName: RoomTable.URL,
      icon: FontAwesomeIcons.doorClosed,
      destinationRoute: (context, params) => RoomTable(),
      getTitle: (context) => getLang(context).rooms),
  MenuButtonInfo(
      routeName: BookingTable.URL,
      icon: FontAwesomeIcons.calendarCheck,
      destinationRoute: (context, params) => BookingTable(),
      getTitle: (context) => getLang(context).bookings),
  MenuButtonInfo(
      routeName: ProfilePage.URL,
      icon: FontAwesomeIcons.userGear,
      destinationRoute: (context, params) => ProfilePage(),
      getTitle: (context) => getLang(context).profile),
];

void initRouter(BuildContext context) {
  router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Scaffold(
      body: Center(
        child: Text("NOT FOUND"),
      ),
    );
  });
  router.define(
    RoomFrom.URL,
    handler: Handler(
      handlerFunc: (context, parameters) {
        return RoomFrom();
      },
    ),
  );
  router.define(
    MeetingRequirementFrom.URL,
    handler: Handler(
      handlerFunc: (context, parameters) {
        return MeetingRequirementFrom();
      },
    ),
  );
  router.define(
    SharedEquipmentFrom.URL,
    handler: Handler(
      handlerFunc: (context, parameters) {
        return SharedEquipmentFrom();
      },
    ),
  );
  router.define(
    MeetingFrom.URL,
    handler: Handler(
      handlerFunc: (context, parameters) {
        return MeetingFrom();
      },
    ),
  );
  for (var element in menuButtonList) {
    router.define(
      element.routeName,
      handler: Handler(
        handlerFunc: (context, parameters) {
          return element.destinationRoute(context, parameters);
        },
      ),
    );
  }
}

class MenuButtonInfo {
  final IconData icon;
  final IconData? activeIcon;
  final String routeName;
  final Widget Function(BuildContext? context, Map<String, List<String>> params)
      destinationRoute;
  final String Function(BuildContext context) getTitle;

  MenuButtonInfo({
    required this.icon,
    required this.routeName,
    required this.destinationRoute,
    required this.getTitle,
    this.activeIcon,
  });
}
