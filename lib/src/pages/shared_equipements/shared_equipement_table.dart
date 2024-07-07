import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lazy_paginated_data_table/lazy_paginated_data_table.dart';
import 'package:meeting_planner/src/app.dart';
import 'package:meeting_planner/src/model/classes/shared_equipment.dart';
import 'package:meeting_planner/src/pages/shared_equipements/shared_equipements_form.dart';
import 'package:meeting_planner/src/router_config.dart';
import 'package:meeting_planner/src/services/shared_equipment_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:http_error_handler/error_handler.dart';

import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';

class SharedEquipmentTable extends StatefulWidget {
  static final String URL = "/sharedEquipment";
  const SharedEquipmentTable({super.key});

  @override
  State<SharedEquipmentTable> createState() => _SharedEquipmentTableState();
}

class _SharedEquipmentTableState extends BasicState<SharedEquipmentTable>
    with UtilsMixin {
  final tableKey = GlobalKey<LazyPaginatedDataTableState>();
  final sharedEquipmentService = GetIt.instance.get<SharedEquipmentService>();

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.sharedEquipments),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: FilledButton(
                onPressed: () {
                  router
                      .navigateTo(
                          navKey.currentContext!, SharedEquipmentFrom.URL)
                      .then((value) {
                    tableKey.currentState?.refreshPage();
                  });
                },
                child: Text(lang.addSharedEquipment),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              LazyPaginatedDataTable<SharedEquipment>(
                key: tableKey,
                columnSpacing: 100,
                getData: (PageInfo info) => sharedEquipmentService
                    .getAllSharedEquipments(info.pageIndex, info.pageSize),
                getTotal: () =>
                    sharedEquipmentService.getSharedEquipmentsCount(),
                columns: <DataColumn>[
                  DataColumn(label: Text(lang.equipment)),
                  DataColumn(label: Text(lang.totalQuantity)),
                  DataColumn(label: Text(lang.edit)),
                  DataColumn(label: Text(lang.delete)),
                ],
                dataToRow: (data, indexInCurrentPage) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data.equipment.name)),
                      DataCell(Text(data.total.toString())),
                      DataCell(
                        TextButton(
                          child: Text(lang.edit.toUpperCase()),
                          onPressed: () => Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  SharedEquipmentFrom(sharedEquipment: data),
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
      sharedEquipmentService.deleteSharedEquipment(id);
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }
}
