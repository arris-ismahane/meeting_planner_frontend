import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:meeting_planner/src/model/classes/equipement.dart';
import 'package:meeting_planner/src/model/classes/meeting_requirement.dart';
import 'package:meeting_planner/src/model/enums/meeting_type.dart';
import 'package:meeting_planner/src/model/inputs/meeting_requirement_input.dart';
import 'package:meeting_planner/src/pages/meeting_requirement/meeting_requirement_table.dart';
import 'package:meeting_planner/src/services/equipement_service.dart';
import 'package:meeting_planner/src/services/meeting_requirement_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:http_error_handler/error_handler.dart';

import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/validations.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';
import 'package:rxdart/rxdart.dart';

class MeetingRequirementFrom extends StatefulWidget {
  static final String URL = "${MeetingRequirementTable.URL}/add";
  final MeetingRequirement? meetingRequirement;
  const MeetingRequirementFrom({super.key, this.meetingRequirement});

  @override
  State<MeetingRequirementFrom> createState() => _MeetingRequirementFromState();
}

class _MeetingRequirementFromState extends BasicState<MeetingRequirementFrom>
    with UtilsMixin {
  final meetingRequirementService =
      GetIt.instance.get<MeetingRequirementService>();
  final equipementService = GetIt.instance.get<EquipementService>();

  final keyForm = GlobalKey<FormState>();

  final typeStream = BehaviorSubject<MeetingType?>();
  final selectedEquipmentsStream = BehaviorSubject.seeded(<Equipement>[]);
  final allEquipmentsStream = BehaviorSubject.seeded(<Equipement>[]);

  @override
  void initState() {
    getEquipements();
    if (widget.meetingRequirement != null) {
      init(widget.meetingRequirement!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.addMeetingRequirement),
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
                      DropdownButtonFormField<MeetingType>(
                        decoration: getDecoration(lang.type, true),
                        value: typeStream.valueOrNull,
                        items: MeetingType.values
                            .map(
                              (e) => DropdownMenuItem<MeetingType>(
                                child: Text(lang.meetingTypeName(e)),
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
        selectedEquipmentsStream.valueOrNull != null &&
        typeStream.valueOrNull != null) {
      progressSubject.add(true);
      MeetingRequirementInput input = MeetingRequirementInput(
        type: typeStream.valueOrNull!,
        requiredEquipementIds:
            selectedEquipmentsStream.value.map((e) => e.id).toList(),
      );
      MeetingRequirement? res;
      try {
        if (widget.meetingRequirement == null) {
          res = await meetingRequirementService.createMeetingRequirement(input);
        } else {
          res = await meetingRequirementService.updateMeetingRequirement(
              widget.meetingRequirement!.id, input);
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

  void init(MeetingRequirement meetingRequirement) {
    typeStream.add(meetingRequirement.type);
    selectedEquipmentsStream.add(meetingRequirement.requiredEquipements);
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
