import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lazy_paginated_data_table/lazy_paginated_data_table.dart';
import 'package:meeting_planner/src/app.dart';
import 'package:meeting_planner/src/model/classes/meeting_requirement.dart';
import 'package:meeting_planner/src/pages/meeting_requirement/meeting_requirement_form.dart';
import 'package:meeting_planner/src/router_config.dart';
import 'package:meeting_planner/src/services/meeting_requirement_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:http_error_handler/error_handler.dart';

import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';

class MeetingRequirementTable extends StatefulWidget {
  static final String URL = "/meeting-requirement";
  const MeetingRequirementTable({super.key});

  @override
  State<MeetingRequirementTable> createState() =>
      _MeetingRequirementTableState();
}

class _MeetingRequirementTableState extends BasicState<MeetingRequirementTable>
    with UtilsMixin {
  final tableKey = GlobalKey<LazyPaginatedDataTableState>();
  final meetingRequirementService =
      GetIt.instance.get<MeetingRequirementService>();

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.meetingRequirements),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: FilledButton(
                onPressed: () {
                  router
                      .navigateTo(
                          navKey.currentContext!, MeetingRequirementFrom.URL)
                      .then((value) {
                    tableKey.currentState?.refreshPage();
                  });
                },
                child: Text(lang.addMeetingRequirement),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              LazyPaginatedDataTable<MeetingRequirement>(
                key: tableKey,
                columnSpacing: 100,
                getData: (PageInfo info) => meetingRequirementService
                    .getAllMeetingRequirements(info.pageIndex, info.pageSize),
                getTotal: () =>
                    meetingRequirementService.getMeetingRequirementsCount(),
                columns: <DataColumn>[
                  DataColumn(label: Text(lang.type)),
                  DataColumn(label: Text(lang.equipments)),
                  DataColumn(label: Text(lang.edit)),
                  DataColumn(label: Text(lang.delete)),
                ],
                dataToRow: (data, indexInCurrentPage) {
                  return DataRow(
                    cells: [
                      DataCell(Text(lang.meetingTypeName(data.type))),
                      DataCell(
                        Text(data.requiredEquipements.isNotEmpty
                            ? data.requiredEquipements
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
                              builder: (context) => MeetingRequirementFrom(
                                  meetingRequirement: data),
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
      meetingRequirementService.deleteMeetingRequirement(id);
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }
}
