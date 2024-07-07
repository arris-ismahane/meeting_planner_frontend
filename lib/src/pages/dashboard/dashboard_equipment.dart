import 'package:flutter/material.dart';
import 'package:flutter_responsive_tools/device_screen_type.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:meeting_planner/src/model/classes/booking.dart';
import 'package:meeting_planner/src/model/classes/room.dart';
import 'package:meeting_planner/src/model/classes/shared_equipment.dart';
import 'package:meeting_planner/src/pages/dashboard/dashboard.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:rxdart/rxdart.dart';

class DashboardEquipmentWidget extends StatefulWidget {
  final List<SharedEquipment> sharedEquipments;
  final List<Booking> bookings;
  final DateTime selectedDate;

  const DashboardEquipmentWidget({
    super.key,
    required this.sharedEquipments,
    required this.bookings,
    required this.selectedDate,
  });

  @override
  State<DashboardEquipmentWidget> createState() =>
      DashboardEquipmentWidgetState();
}

class DashboardEquipmentWidgetState extends BasicState<DashboardEquipmentWidget>
    with UtilsMixin {
  final borderColor = Colors.black26;
  final rowHeight = 50.0;
  final titleHeight = 57.0;
  final colWidth = 200.0;
  final roomsColWidth = 250.0;
  final headerColor = Color.fromARGB(255, 219, 237, 240);
  final bgColor = Color.fromARGB(255, 249, 254, 255);
  final limitReachedColor = Color.fromARGB(255, 202, 180, 180);
  final currentPositionColor = Color.fromARGB(255, 180, 199, 202);
  final subjectStream = BehaviorSubject.seeded(DshaboeadEquipemntSubject(
    sharedEquipments: [],
    bookings: [],
    selectedDate: DateTime.now(),
  ));
  @override
  void initState() {
    subjectStream.add(DshaboeadEquipemntSubject(
      sharedEquipments: widget.sharedEquipments,
      bookings: widget.bookings,
      selectedDate: widget.selectedDate,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DshaboeadEquipemntSubject>(
        stream: subjectStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var subject = snapshot.data!;
          return HorizontalDataTable(
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
                colWidth * getHourRanges(subject.selectedDate).length,
            leftSideItemBuilder: (context, index) =>
                _generateLeftColumn(subject.sharedEquipments, index),
            rightSideItemBuilder: (context, index) =>
                _generateRightColumn(subject, index),
            isFixedHeader: true,
            headerWidgets: getHeaders(getHourRanges(subject.selectedDate)
                .map((e) => e.lable)
                .toList()),
            itemCount: subject.sharedEquipments.length,
          );
        });
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

  Widget _generateLeftColumn(List<SharedEquipment> equipments, int index) {
    SharedEquipment sharedEquipment = equipments[index];
    return cell(
      Text(sharedEquipment.equipment.name),
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

  Widget getTitle(
      DshaboeadEquipemntSubject subject, int colIndex, int rowIndex) {
    var bookedEquip = findEquipment(
      subject,
      getHourRanges(subject.selectedDate)[colIndex],
      subject.sharedEquipments[rowIndex],
    );

    return Center(
      child: Text(
        "${bookedEquip.totalBooked} / ${bookedEquip.sharedEquipment.total}",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _generateRightColumn(DshaboeadEquipemntSubject subject, int rowIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int colIndex = 0;
            colIndex < getHourRanges(subject.selectedDate).length;
            colIndex++)
          cell(
            getTitle(subject, colIndex, rowIndex),
            rowHeight: rowHeight,
            onTap: () {
              var bookedEquip = findEquipment(
                  subject,
                  getHourRanges(subject.selectedDate)[colIndex],
                  subject.sharedEquipments[rowIndex]);

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
                    child: SizedBox(
                      height: 400,
                      width: 600,
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  bookedEquip.sharedEquipment.equipment.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "${lang.totalQuantity} : ${bookedEquip.totalBooked} / ${bookedEquip.sharedEquipment.total}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (bookedEquip.rooms.isNotEmpty)
                              ListTile(
                                title: Text(
                                  "${lang.rooms} :",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (bookedEquip.rooms.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...bookedEquip.rooms.map((e) =>
                                        Text(" - " + e.name.toUpperCase()))
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            bottomBorderWidth:
                rowIndex == subject.sharedEquipments.length ? 2.0 : 1.0,
            rightBorderWidth: 2.0,
            leftBorder: colIndex == 0,
            leftBorderWidth: 2.0,
            bgColor: getCellBg(
                findEquipment(
                    subject,
                    getHourRanges(subject.selectedDate)[colIndex],
                    subject.sharedEquipments[rowIndex]),
                subject.selectedDate,
                getHourRanges(subject.selectedDate)[colIndex]),
          ),
      ],
    );
  }

  Color? getCellBg(
      BookedSharedEquipement cell, DateTime selectedDate, DateRange hour) {
    var startSelectedDate =
        selectedDate.add(Duration(hours: DateTime.now().hour));
    var endSelectedDate = startSelectedDate.add(Duration(hours: 1));
    var isNow = (startSelectedDate.millisecondsSinceEpoch >= hour.startTime) &&
        (endSelectedDate.millisecondsSinceEpoch <= hour.endTime);
    Color? color;
    if (isNow) {
      color = currentPositionColor;
    } else
      color = bgColor;
    if (cell.totalBooked == cell.sharedEquipment.total) {
      color = limitReachedColor;
    }
    return color;
  }

  BookedSharedEquipement findEquipment(DshaboeadEquipemntSubject subject,
      DateRange hourRange, SharedEquipment sharedEquipment) {
    var bookings = subject.bookings
        .where((booking) =>
            (booking.startDate >= hourRange.startTime) &&
            (booking.endDate <= hourRange.endTime))
        .toList();
    int count = 0;
    List<Room> rooms = [];
    for (var booking in bookings) {
      if (booking.bookedEquipements
          .map((e) => e.equipment.id)
          .contains(sharedEquipment.equipment.id)) {
        count++;
        rooms.add(booking.room);
      }
    }

    return BookedSharedEquipement(
        sharedEquipment: sharedEquipment, totalBooked: count, rooms: rooms);
  }

  double getWidthByColumn(int colIndex) {
    return colWidth;
  }

  Color? getbgColor(int rowIndex, int colIndex, DeviceScreenType type) {
    return null;
  }

  List<DateRange> getHourRanges(DateTime selectedDate) {
    List<DateRange> hourRanges = [];
    var startDate = selectedDate;

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

  refresh(DshaboeadEquipemntSubject subject) {
    this.subjectStream.add(subject);
  }
}

class DshaboeadEquipemntSubject {
  final List<SharedEquipment> sharedEquipments;
  final List<Booking> bookings;
  final DateTime selectedDate;

  DshaboeadEquipemntSubject({
    required this.sharedEquipments,
    required this.bookings,
    required this.selectedDate,
  });
}

class BookedSharedEquipement {
  final SharedEquipment sharedEquipment;
  final int totalBooked;
  final List<Room> rooms;

  BookedSharedEquipement({
    required this.sharedEquipment,
    required this.totalBooked,
    required this.rooms,
  });
}
