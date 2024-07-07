import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:meeting_planner/src/model/classes/equipement.dart';
import 'package:meeting_planner/src/model/classes/room.dart';
import 'package:meeting_planner/src/model/inputs/room_input.dart';
import 'package:meeting_planner/src/pages/room/room_table.dart';
import 'package:meeting_planner/src/services/equipement_service.dart';
import 'package:meeting_planner/src/services/room_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:http_error_handler/error_handler.dart';

import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/validations.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';
import 'package:rxdart/rxdart.dart';

class RoomFrom extends StatefulWidget {
  static final String URL = "${RoomTable.URL}/add";
  final Room? room;
  const RoomFrom({super.key, this.room});

  @override
  State<RoomFrom> createState() => _RoomFromState();
}

class _RoomFromState extends BasicState<RoomFrom> with UtilsMixin {
  final roomService = GetIt.instance.get<RoomService>();
  final equipementService = GetIt.instance.get<EquipementService>();

  final keyForm = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final capacityCtrl = TextEditingController();

  final selectedEquipmentsStream = BehaviorSubject.seeded(<Equipement>[]);
  final allEquipmentsStream = BehaviorSubject.seeded(<Equipement>[]);

  @override
  void initState() {
    getEquipements();
    if (widget.room != null) {
      init(widget.room!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.addRoom),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Equipement>>(
              stream: allEquipmentsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var allEquipments = snapshot.data!;
                return Form(
                  key: keyForm,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: getDecoration(lang.name, true),
                        validator: (value) =>
                            Validations.requiredField(value, context),
                      ),
                      Gap(16),
                      TextFormField(
                        controller: capacityCtrl,
                        decoration: getDecoration(lang.capacity, true),
                        validator: (value) => Validations.intValidator(
                          value,
                          context,
                          required: true,
                          minValue: 1,
                        ),
                      ),
                      Gap(16),
                      Text(
                        lang.equipments,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Gap(5),
                      StreamBuilder<List<Equipement>>(
                        stream: selectedEquipmentsStream,
                        initialData: selectedEquipmentsStream.value,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox.shrink();
                          }
                          var selected = snapshot.data!;
                          return Column(
                            children: allEquipments
                                .map((e) => CheckboxListTile(
                                      title: Text(e.name),
                                      value: selected.contains(e),
                                      onChanged: (value) {
                                        if (value ?? false) {
                                          selected.add(e);
                                        } else {
                                          selected.removeWhere(
                                              (element) => element == e);
                                        }
                                        selectedEquipmentsStream.add(selected);
                                      },
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(25),
          child: saveCancelButtons(onSave: onSave),
        ),
      ),
    );
  }

  onSave() async {
    if ((keyForm.currentState?.validate() ?? false) &&
        selectedEquipmentsStream.valueOrNull != null) {
      progressSubject.add(true);
      RoomInput input = RoomInput(
        name: nameCtrl.text,
        initialEquipmentIds:
            selectedEquipmentsStream.value.map((e) => e.id).toList(),
        capacity: int.tryParse(capacityCtrl.text) ?? 1,
      );
      Room? res;
      try {
        if (widget.room == null) {
          res = await roomService.createRoom(input);
        } else {
          res = await roomService.updateRoom(widget.room!.id, input);
        }
        Navigator.of(context).pop(res);
        await showSnackBar2(context, lang.savedSuccessfully);
      } catch (error, stacktrace) {
        print(stacktrace);
        showServerError(context, error: error);
      } finally {
        progressSubject.add(false);
      }
    }
  }

  void init(Room room) {
    nameCtrl.text = room.name;
    capacityCtrl.text = room.capacity.toString();
    selectedEquipmentsStream.add(room.initialEquipments);
  }

  Future getEquipements() async {
    progressSubject.add(true);
    try {
      var res = await equipementService.getAllEquipements(0, 200);
      allEquipmentsStream.add(res);
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }
}
