import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_responsive_tools/device_screen_type.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:http_error_handler/error_handler.dart';
import 'package:meeting_planner/src/app.dart';
import 'package:meeting_planner/src/model/classes/booking.dart';
import 'package:meeting_planner/src/model/classes/room.dart';
import 'package:meeting_planner/src/model/classes/shared_equipment.dart';
import 'package:meeting_planner/src/pages/booking/meeting_form.dart';
import 'package:meeting_planner/src/pages/dashboard/booking_preview.dart';
import 'package:meeting_planner/src/pages/dashboard/dashboard_equipment.dart';
import 'package:meeting_planner/src/router_config.dart';
import 'package:meeting_planner/src/services/booking_service.dart';
import 'package:meeting_planner/src/services/room_service.dart';
import 'package:meeting_planner/src/services/shared_equipment_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/utils/alert_vertical_widget.dart';
import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';

import 'package:rxdart/rxdart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends BasicState<Dashboard> with UtilsMixin {
  final borderColor = Colors.black26;
  final rowHeight = 50.0;
  final titleHeight = 57.0;
  final colWidth = 200.0;
  final roomsColWidth = 250.0;
  final headerColor = Color.fromARGB(255, 219, 237, 240);
  final bgColor = Color.fromARGB(255, 249, 254, 255);
  final currentPositionColor = Color.fromARGB(255, 180, 199, 202);
  final selectedDateStream = BehaviorSubject.seeded(DateTime.now());
  final bookingService = GetIt.instance.get<BookingService>();
  final roomService = GetIt.instance.get<RoomService>();
  final epuipmentService = GetIt.instance.get<SharedEquipmentService>();
  final equipmentKey = GlobalKey<DashboardEquipmentWidgetState>();
  final startDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  final dashboardStream = BehaviorSubject.seeded(
    DashbordData(
      rooms: [],
      bookings: [],
      sharedEquipments: [],
    ),
  );
  late final List<Tab> myTabs = [
    Tab(
      child: SizedBox(
        width: 150,
        child: Tooltip(
            message: lang.bookings,
            child: Text(lang.bookings, overflow: TextOverflow.ellipsis)),
      ),
    ),
    Tab(
      child: SizedBox(
        width: 150,
        child: Tooltip(
            message: lang.equipments,
            child: Text(lang.equipments, overflow: TextOverflow.ellipsis)),
      ),
    ),
  ];
  final today = DateTime.now();

  late final Timer timer;

  @override
  void initState() {
    selectedDateStream.add(startDate);
    selectedDateStream.listen(
      (value) {
        getData(value);
      },
    );

    getData(startDate);
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      var value = dashboardStream.valueOrNull;
      if (value != null) {
        dashboardStream.add(value);
      }
    });

    dashboardStream.listen((value) {
      equipmentKey.currentState?.refresh(
        DshaboeadEquipemntSubject(
          sharedEquipments: value.sharedEquipments,
          bookings: value.bookings,
          selectedDate: DateTime.fromMillisecondsSinceEpoch(
              selectedDateStream.value.millisecondsSinceEpoch),
        ),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => DefaultTabController(
        length: myTabs.length,
        child: StreamBuilder<DateTime>(
            stream: selectedDateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              var selectedDate = snapshot.data!;
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    lang.appName.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () async {
                        getData(selectedDate);
                      },
                      child: Text(
                        lang.refresh,
                      ),
                    ),
                    Gap(10),
                    OutlinedButton(
                      onPressed: () async {
                        var selected = await selectDate(context,
                            disableWeekend: false, initialValue: selectedDate);
                        if (selected != null) {
                          selectedDateStream.add(
                            DateTime(
                              selected.year,
                              selected.month,
                              selected.day,
                            ),
                          );
                        }
                      },
                      child: Text(
                        lang.formatDateDate(selectedDateStream.value),
                      ),
                    ),
                    Gap(10),
                    FilledButton(
                        onPressed: () {
                          router
                              .navigateTo(
                                  navKey.currentContext!, MeetingFrom.URL)
                              .then((value) {
                            getData(selectedDate);
                          });
                        },
                        child: Text(lang.addBooking)),
                    Gap(15),
                  ],
                  bottom: TabBar(tabs: myTabs),
                ),
                body: StreamBuilder(
                  stream: dashboardStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return AlertVerticalWidget("ERROR LOADING DATA");
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var data = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: TabBarView(
                        children: [
                          HorizontalDataTable(
                            horizontalScrollbarStyle: ScrollbarStyle(
                              isAlwaysShown: true,
                              thumbColor: Colors.black45,
                              radius: Radius.circular(360),
                              thickness: 15,
                            ),
                            verticalScrollbarStyle: ScrollbarStyle(
                              isAlwaysShown: true,
                              thumbColor: Colors.black45,
                              radius: Radius.circular(360),
                              thickness: 15,
                            ),
                            leftHandSideColumnWidth: roomsColWidth + 5,
                            rightHandSideColumnWidth:
                                colWidth * getHourRanges().length,
                            leftSideItemBuilder: (context, index) =>
                                _generateLeftColumn(data.rooms, index),
                            rightSideItemBuilder: (context, index) =>
                                _generateRightColumn(data, index),
                            isFixedHeader: true,
                            headerWidgets: getHeaders(
                                getHourRanges().map((e) => e.lable).toList()),
                            itemCount: data.rooms.length,
                          ),
                          DashboardEquipmentWidget(
                            key: equipmentKey,
                            sharedEquipments: data.sharedEquipments,
                            bookings: data.bookings,
                            selectedDate: selectedDate,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }

  List<Widget> getHeaders(List<String> headers) {
    return [
      _getTitleItemWidget(
        lang.rooms,
        roomsColWidth,
        leftBorder: true,
        leftBorderWidth: 2.0,
        topBorder: true,
        topBorderWidth: 2.0,
        bottomtBorder: true,
        bottomtBorderWidth: 2.0,
        righBorder: true,
        righBorderWidth: 2.0,
        backgroudColor: headerColor,
      ),
      for (int i = 0; i < headers.length; i++)
        _getTitleItemWidget(headers[i], colWidth,
            topBorder: true,
            topBorderWidth: 2.0,
            bottomtBorder: true,
            bottomtBorderWidth: 2.0,
            righBorder: true,
            righBorderWidth: 2.0,
            leftBorder: i == 0,
            leftBorderWidth: 2.0,
            backgroudColor: headerColor)
    ];
  }

  Widget _generateLeftColumn(List<Room> rooms, int index) {
    Room room = rooms[index];
    return cell(
      Text(room.name),
      bgColor: headerColor,
      colWidth: roomsColWidth,
      leftBorder: true,
      leftBorderWidth: 2.0,
      bottomBorderWidth: 2.0,
      topBorderWidth: 2.0,
      rightBorderWidth: 2.0,
      margin: EdgeInsets.only(right: 5),
    );
  }

  Widget _getTitleItemWidget(
    String label,
    double width, {
    bool leftBorder = false,
    bool righBorder = false,
    bool topBorder = false,
    bool bottomtBorder = false,
    double leftBorderWidth = 1.0,
    double righBorderWidth = 1.0,
    double topBorderWidth = 1.0,
    double bottomtBorderWidth = 1.0,
    Color? borderColor,
    Color? backgroudColor,
  }) {
    return Container(
      width: width,
      height: titleHeight,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      decoration: BoxDecoration(
        color: backgroudColor,
        border: Border(
          right: righBorder
              ? BorderSide(
                  color: borderColor ?? this.borderColor,
                  width: righBorderWidth,
                )
              : BorderSide.none,
          left: leftBorder
              ? BorderSide(
                  color: borderColor ?? this.borderColor,
                  width: leftBorderWidth,
                )
              : BorderSide.none,
          top: topBorder
              ? BorderSide(
                  color: borderColor ?? this.borderColor,
                  width: topBorderWidth,
                )
              : BorderSide.none,
          bottom: bottomtBorder
              ? BorderSide(
                  color: borderColor ?? this.borderColor,
                  width: bottomtBorderWidth,
                )
              : BorderSide.none,
        ),
      ),
    );
  }

  Widget cell(
    Widget child, {
    bool topBorder = false,
    bool leftBorder = false,
    double? rowHeight,
    double? colWidth,
    double leftBorderWidth = 1.0,
    double rightBorderWidth = 1.0,
    double topBorderWidth = 1.0,
    double bottomBorderWidth = 1.0,
    EdgeInsetsGeometry? margin,
    void Function()? onTap,
    Color? bgColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        width: colWidth ?? this.colWidth,
        height: rowHeight ?? this.rowHeight,
        alignment: Alignment.center,
        child: child,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            bottom: BorderSide(color: borderColor, width: bottomBorderWidth),
            right: BorderSide(
              color: borderColor,
              width: rightBorderWidth,
            ),
            left: leftBorder
                ? BorderSide(
                    color: borderColor,
                    width: leftBorderWidth,
                  )
                : BorderSide.none,
            top: topBorder
                ? BorderSide(
                    color: borderColor,
                    width: topBorderWidth,
                  )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget getTitle(DashbordData data, int colIndex, int rowIndex) {
    var booking =
        findBooking(data, getHourRanges()[colIndex], data.rooms[rowIndex]);
    if (booking == null) {
      return Text(" - ");
    }
    return Center(
      child: Text(
        booking.name.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _generateRightColumn(DashbordData data, int rowIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int colIndex = 0; colIndex < getHourRanges().length; colIndex++)
          cell(
            getTitle(data, colIndex, rowIndex),
            rowHeight: rowHeight,
            onTap: findBooking(data, getHourRanges()[colIndex],
                        data.rooms[rowIndex]) ==
                    null
                ? null
                : () {
                    var booking = findBooking(
                        data, getHourRanges()[colIndex], data.rooms[rowIndex]);
                    if (booking != null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actions: [
                            FilledButton(
                              onPressed: Navigator.of(context).pop,
                              child: Text(lang.ok.toUpperCase()),
                            ),
                          ],
                          content: SingleChildScrollView(
                            child: BookingPreview(booking: booking),
                          ),
                        ),
                      );
                    }
                  },
            bottomBorderWidth: rowIndex == data.rooms.length ? 2.0 : 1.0,
            rightBorderWidth: 2.0,
            leftBorder: colIndex == 0,
            leftBorderWidth: 2.0,
            bgColor: getCellBg(getHourRanges()[colIndex]),
          ),
      ],
    );
  }

  Color? getCellBg(DateRange hour) {
    var selectedDate = selectedDateStream.valueOrNull ?? startDate;
    selectedDate = selectedDate.add(Duration(hours: DateTime.now().hour));
    var endSelectedDate = selectedDate.add(Duration(hours: 1));
    var isNow = (selectedDate.millisecondsSinceEpoch >= hour.startTime) &&
        (endSelectedDate.millisecondsSinceEpoch <= hour.endTime);
    if (isNow) {
      return currentPositionColor;
    }
    return bgColor;
  }

  Booking? findBooking(DashbordData data, DateRange hourRange, Room room) {
    var res = data.bookings
        .where((booking) => booking.room.id == room.id)
        .where((booking) =>
            (booking.startDate >= hourRange.startTime) &&
            (booking.endDate <= hourRange.endTime))
        .toList();
    return res.isNotEmpty ? res.first : null;
  }

  double getWidthByColumn(int colIndex) {
    return colWidth;
  }

  Color? getbgColor(int rowIndex, int colIndex, DeviceScreenType type) {
    return null;
  }

  List<DateRange> getHourRanges() {
    List<DateRange> hourRanges = [];
    var now = DateTime.now();
    var startDate = selectedDateStream.valueOrNull ??
        DateTime(now.year, now.month, now.day);

    for (int hour = startHour; hour < endHour; hour++) {
      var startTime =
          DateTime(startDate.year, startDate.month, startDate.day, hour, 0);
      var range = DateRange(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: startTime.add(Duration(hours: 1)).millisecondsSinceEpoch,
        lable: "${hour}h - ${hour + 1}h",
      );
      hourRanges.add(range);
    }

    return hourRanges;
  }

  Future getData(DateTime startDate) async {
    var endDate = startDate.add(Duration(days: 1));
    progressSubject.add(true);
    try {
      var rooms = await roomService.getAllRooms(0, 200);
      var bookings = await bookingService.getBookingsByRange(
          startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch);
      var equipments = await epuipmentService.getAllSharedEquipments(0, 200);
      dashboardStream.add(DashbordData(
          rooms: rooms, bookings: bookings, sharedEquipments: equipments));
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }
}

class CellText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String? tooltipText;
  final double maxWidth;
  const CellText(this.text,
      {super.key, this.style, this.tooltipText, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipText ?? text,
      child: Container(
        width: maxWidth,
        child: Text(
          text,
          style: style,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class DashbordData {
  final List<Room> rooms;
  final List<Booking> bookings;
  final List<SharedEquipment> sharedEquipments;
  DashbordData({
    required this.rooms,
    required this.bookings,
    required this.sharedEquipments,
  });
}

class DateRange {
  final int startTime;
  final int endTime;
  final String lable;

  DateRange({
    required this.startTime,
    required this.endTime,
    required this.lable,
  });
}
