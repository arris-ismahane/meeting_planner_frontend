import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:http_error_handler/error_handler.dart';
import 'package:meeting_planner/src/model/classes/equipement.dart';
import 'package:meeting_planner/src/model/inputs/equipement_input.dart';
import 'package:meeting_planner/src/pages/equipemet/text_search_dialog.dart';
import 'package:meeting_planner/src/services/equipement_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/utils/alert_vertical_widget.dart';
import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';
import 'package:infinite_scroll_list_view_2/infinite_scroll_list_view.dart';

class EquipemetList extends StatefulWidget {
  static final String URL = "equipement";
  const EquipemetList({super.key});

  @override
  State<EquipemetList> createState() => _EquipemetListState();
}

class _EquipemetListState extends BasicState<EquipemetList> with UtilsMixin {
  final equipementService = GetIt.instance.get<EquipementService>();
  final listKey = GlobalKey<InfiniteScrollListViewState>();
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.equipments),
          actions: [
            FilledButton(
              onPressed: () =>
                  create().then((value) => listKey.currentState?.reload()),
              child: Text(lang.addEquipement),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: InfiniteScrollListView(
            key: listKey,
            elementBuilder: (context, element, index, animation) {
              return Card(
                child: ListTile(
                  title: Text(element.name),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: () async {
                          showConfirmDialog(
                            TextButton(
                              onPressed: () async {
                                await delete(element.id);
                                Navigator.of(context).pop();
                                listKey.currentState?.reload();
                              },
                              child: Text(lang.yes.toUpperCase()),
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                      Gap(5),
                      IconButton(
                          onPressed: () => edit(element)
                              .then((value) => listKey.currentState?.reload()),
                          icon: Icon(Icons.edit))
                    ],
                  ),
                ),
              );
            },
            pageLoader: (index) =>
                equipementService.getAllEquipements(index, 20),
            noDataWidget: Center(
              child: AlertVerticalWidget(
                lang.noDataFound,
                type: AlertType.WARNING,
                iconData: Icons.warning,
                iconSize: 64,
                margin: 10,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future delete(int id) async {
    progressSubject.add(true);
    try {
      await equipementService.deleteEquipement(id);
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }

  Future create() async {
    return showDialog(
      context: context,
      builder: (context) {
        return TextSearchDialog(
          title: lang.name,
          onSave: (value) async {
            if (value != null) {
              var res = EquipementInput(name: value);
              await onSave(input: res);
            }

            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future edit(Equipement element) async {
    return showDialog(
      context: context,
      builder: (context) {
        return TextSearchDialog(
          title: lang.name,
          initValue: element.name,
          onSave: (value) async {
            if (value != null) {
              var res = EquipementInput(name: value);
              await onSave(id: element.id, input: res);
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future onSave({int? id, required EquipementInput input}) async {
    progressSubject.add(true);
    try {
      if (id == null) {
        await equipementService.createEquipement(input);
      } else {
        await equipementService.updateEquipement(id, input);
      }
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }
}
