import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:meeting_planner/src/model/classes/equipement.dart';
import 'package:meeting_planner/src/model/classes/shared_equipment.dart';
import 'package:meeting_planner/src/model/inputs/shared_equipment_input.dart';
import 'package:meeting_planner/src/pages/shared_equipements/shared_equipement_table.dart';
import 'package:meeting_planner/src/services/equipement_service.dart';
import 'package:meeting_planner/src/services/shared_equipment_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:http_error_handler/error_handler.dart';

import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/validations.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';
import 'package:rxdart/rxdart.dart';

class SharedEquipmentFrom extends StatefulWidget {
  static final String URL = "${SharedEquipmentTable.URL}/add";
  final SharedEquipment? sharedEquipment;
  const SharedEquipmentFrom({super.key, this.sharedEquipment});

  @override
  State<SharedEquipmentFrom> createState() => _SharedEquipmentFromState();
}

class _SharedEquipmentFromState extends BasicState<SharedEquipmentFrom>
    with UtilsMixin {
  final sharedEquipmentService = GetIt.instance.get<SharedEquipmentService>();
  final equipementService = GetIt.instance.get<EquipementService>();

  final keyForm = GlobalKey<FormState>();

  final totalCtrl = TextEditingController();
  final typeStream = BehaviorSubject<Equipement?>();
  final allEquipmentsStream = BehaviorSubject.seeded(<Equipement>[]);

  @override
  void initState() {
    getEquipements();
    if (widget.sharedEquipment != null) {
      init(widget.sharedEquipment!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.addSharedEquipment),
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
                      DropdownButtonFormField<Equipement>(
                        decoration: getDecoration(lang.equipment, true),
                        value: typeStream.valueOrNull,
                        items: allEquipments
                            .map(
                              (e) => DropdownMenuItem<Equipement>(
                                child: Text(e.name),
                                value: e,
                              ),
                            )
                            .toList(),
                        onChanged: (e) {
                          typeStream.add(e);
                        },
                        validator: (value) => Validations.requiredField(
                            value == null ? null : "$value", context),
                      ),
                      Gap(16),
                      TextFormField(
                        controller: totalCtrl,
                        decoration: getDecoration(lang.totalQuantity, true),
                        validator: (value) => Validations.intValidator(
                          value,
                          context,
                          required: true,
                          minValue: 1,
                        ),
                      ),
                      Gap(16),
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
        typeStream.valueOrNull != null) {
      progressSubject.add(true);
      SharedEquipmentInput input = SharedEquipmentInput(
        equipmentId: typeStream.valueOrNull!.id,
        total: int.tryParse(totalCtrl.text) ?? 1,
      );
      SharedEquipment? res;
      try {
        if (widget.sharedEquipment == null) {
          res = await sharedEquipmentService.createSharedEquipment(input);
        } else {
          res = await sharedEquipmentService.updateSharedEquipment(
              widget.sharedEquipment!.id, input);
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

  void init(SharedEquipment sharedEquipment) {
    typeStream.add(sharedEquipment.equipment);
    totalCtrl.text = sharedEquipment.total.toString();
  }

  Future getEquipements() async {
    progressSubject.add(true);
    try {
      var res = await equipementService.getAllEquipements(0, 200);
      print("size ${res.length}");
      allEquipmentsStream.add(res);
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }
}
