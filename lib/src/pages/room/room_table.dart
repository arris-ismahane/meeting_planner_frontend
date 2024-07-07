import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lazy_paginated_data_table/lazy_paginated_data_table.dart';
import 'package:meeting_planner/src/app.dart';
import 'package:meeting_planner/src/model/classes/room.dart';
import 'package:meeting_planner/src/pages/room/room_form.dart';
import 'package:meeting_planner/src/router_config.dart';
import 'package:meeting_planner/src/services/room_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:http_error_handler/error_handler.dart';

import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';

class RoomTable extends StatefulWidget {
  static final String URL = "/room";
  const RoomTable({super.key});

  @override
  State<RoomTable> createState() => _RoomTableState();
}

class _RoomTableState extends BasicState<RoomTable> with UtilsMixin {
  final tableKey = GlobalKey<LazyPaginatedDataTableState>();
  final roomService = GetIt.instance.get<RoomService>();

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.rooms),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: FilledButton(
                onPressed: () {
                  router
                      .navigateTo(navKey.currentContext!, RoomFrom.URL)
                      .then((value) {
                    tableKey.currentState?.refreshPage();
                  });
                },
                child: Text(lang.addRoom),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              LazyPaginatedDataTable<Room>(
                key: tableKey,
                columnSpacing: 100,
                getData: (PageInfo info) =>
                    roomService.getAllRooms(info.pageIndex, info.pageSize),
                getTotal: () => roomService.getRoomsCount(),
                columns: <DataColumn>[
                  DataColumn(label: Text(lang.name)),
                  DataColumn(label: Text(lang.capacity)),
                  DataColumn(label: Text(lang.initialEquipments)),
                  DataColumn(label: Text(lang.edit)),
                  DataColumn(label: Text(lang.delete)),
                ],
                dataToRow: (data, indexInCurrentPage) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data.name)),
                      DataCell(Text(data.capacity.toString())),
                      DataCell(
                        Text(data.initialEquipments.isNotEmpty
                            ? data.initialEquipments
                                .map((e) => e.name)
                                .join(", ")
                            : lang.na),
                      ),
                      DataCell(
                        TextButton(
                          child: Text(lang.edit.toUpperCase()),
                          onPressed: () => Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => RoomFrom(room: data),
                            ),
                          )
                              .then(
                            (value) {
                              tableKey.currentState?.refreshPage();
                            },
                          ),
                        ),
                      ),
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
      roomService.deleteRoom(id);
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }
}
