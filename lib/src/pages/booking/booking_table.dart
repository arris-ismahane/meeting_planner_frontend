import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lazy_paginated_data_table/lazy_paginated_data_table.dart';
import 'package:meeting_planner/src/app.dart';
import 'package:meeting_planner/src/model/classes/booking.dart';
import 'package:meeting_planner/src/pages/booking/meeting_form.dart';
import 'package:meeting_planner/src/router_config.dart';
import 'package:meeting_planner/src/services/booking_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:http_error_handler/error_handler.dart';
import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';

class BookingTable extends StatefulWidget {
  static final String URL = "/booking";
  const BookingTable({super.key});

  @override
  State<BookingTable> createState() => _BookingTableState();
}

class _BookingTableState extends BasicState<BookingTable> with UtilsMixin {
  final tableKey = GlobalKey<LazyPaginatedDataTableState>();
  final bookingService = GetIt.instance.get<BookingService>();

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.bookings),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: FilledButton(
                onPressed: () {
                  router
                      .navigateTo(navKey.currentContext!, MeetingFrom.URL)
                      .then((value) {
                    tableKey.currentState?.refreshPage();
                  });
                },
                child: Text(lang.addBooking),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              LazyPaginatedDataTable<Booking>(
                key: tableKey,
                columnSpacing: 50,
                getData: (PageInfo info) => bookingService.getAllBookings(
                    info.pageIndex, info.pageSize),
                getTotal: () => bookingService.getBookingsCount(),
                columns: <DataColumn>[
                  DataColumn(label: Text(lang.name)),
                  DataColumn(label: Text(lang.type)),
                  DataColumn(label: Text(lang.nbParticipants)),
                  DataColumn(label: Text(lang.equipments)),
                  DataColumn(label: Text(lang.rooms)),
                  DataColumn(label: Text(lang.startTime)),
                  DataColumn(label: Text(lang.endTime)),
                  DataColumn(label: Text(lang.delete)),
                ],
                dataToRow: (data, indexInCurrentPage) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data.name)),
                      DataCell(Text(data.type.type.name)),
                      DataCell(Text(data.nbParticipants.toString())),
                      DataCell(
                        Text(data.bookedEquipements.isNotEmpty
                            ? data.bookedEquipements
                                .map((e) => e.equipment.name)
                                .join(", ")
                            : lang.na),
                      ),
                      DataCell(Text(data.room.name)),
                      DataCell(Text(lang.formatDateTime(data.startDate))),
                      DataCell(Text(lang.formatDateTime(data.endDate))),
                      DataCell(
                        TextButton(
                            child: Text(
                              lang.delete.toUpperCase(),
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              showConfirmDialog(
                                TextButton(
                                  onPressed: () {
                                    delete(data.id);
                                    Navigator.of(context).pop();
                                    tableKey.currentState?.refreshPage();
                                  },
                                  child: Text(lang.yes.toUpperCase()),
                                ),
                              );
                            }),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void delete(int id) {
    progressSubject.add(true);
    try {
      bookingService.deleteBooking(id);
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }
}
