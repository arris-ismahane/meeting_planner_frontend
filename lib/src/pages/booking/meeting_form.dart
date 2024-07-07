import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:meeting_planner/src/model/classes/booking.dart';
import 'package:meeting_planner/src/model/classes/meeting_requirement.dart';
import 'package:meeting_planner/src/model/inputs/meeting_input.dart';
import 'package:meeting_planner/src/services/booking_service.dart';
import 'package:meeting_planner/src/services/meeting_requirement_service.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:http_error_handler/error_handler.dart';

import 'package:meeting_planner/src/utils/utils_mixin.dart';
import 'package:meeting_planner/src/utils/validations.dart';
import 'package:meeting_planner/src/utils/widget_utils.dart';
import 'package:rxdart/rxdart.dart';

class MeetingFrom extends StatefulWidget {
  static final String URL = "meeting/add";
  const MeetingFrom({
    super.key,
  });

  @override
  State<MeetingFrom> createState() => _MeetingFromState();
}

class _MeetingFromState extends BasicState<MeetingFrom> with UtilsMixin {
  final keyForm = GlobalKey<FormState>();
  final bookingService = GetIt.instance.get<BookingService>();
  final meetingRequirementService =
      GetIt.instance.get<MeetingRequirementService>();
  final nameCtrl = TextEditingController();
  final nbParticipantsCtrl = TextEditingController();
  final typeStream = BehaviorSubject<MeetingRequirement?>();
  final allTypesStream = BehaviorSubject.seeded(<MeetingRequirement>[]);
  final dateCtrl = TextEditingController();
  final startTimeCtrl = TextEditingController();
  final endTimeCtrl = TextEditingController();
  final dateStream = BehaviorSubject<DateTime?>();
  final startTimeStream = BehaviorSubject.seeded(
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0));
  @override
  void initState() {
    getRequirements();
    if (!weekend.contains(DateTime.now().weekday)) {
      dateStream.add(DateTime.now());
    }
    dateStream.listen((value) {
      if (value != null) {
        dateCtrl.text = lang.formatDateDate(value);
      }
    });
    startTimeStream.listen((value) {
      startTimeCtrl.text = lang.formatTimeOfDay(value);
      endTimeCtrl.text = lang.formatTimeOfDay(
          TimeOfDay(hour: value.hour + 1, minute: value.minute));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.wrapRoute(
      (context, type) => Scaffold(
        appBar: AppBar(
          title: Text(lang.meeting),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
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
                  controller: nbParticipantsCtrl,
                  decoration: getDecoration(lang.nbParticipants, true),
                  validator: (value) => Validations.intValidator(
                    value,
                    context,
                    required: true,
                    minValue: 1,
                  ),
                ),
                Gap(16),
                StreamBuilder<List<MeetingRequirement>>(
                    stream: allTypesStream,
                    builder: (context, snapshot) {
                      return DropdownButtonFormField<MeetingRequirement>(
                        decoration: getDecoration(lang.type, true),
                        value: typeStream.valueOrNull,
                        items: snapshot.data == null
                            ? null
                            : snapshot.data!
                                .map(
                                  (e) => DropdownMenuItem<MeetingRequirement>(
                                    child: Text(lang.meetingTypeName(e.type)),
                                    value: e,
                                  ),
                                )
                                .toList(),
                        onChanged: (e) {
                          typeStream.add(e);
                        },
                        validator: (value) => Validations.requiredField(
                            value == null ? null : "$value", context),
                      );
                    }),
                Gap(16),
                InkWell(
                  onTap: () async {
                    var date = await selectDate(context,
                        firstDate: dateStream.valueOrNull,
                        initialValue: dateStream.valueOrNull);
                    if (date != null) {
                      dateStream.add(date);
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: dateCtrl,
                      decoration: getDecoration(
                        lang.date,
                        true,
                      ),
                      validator: (value) => Validations.requiredField(
                          value == null ? null : "$value", context),
                    ),
                  ),
                ),
                Gap(16),
                InkWell(
                  onTap: () async {
                    TimeOfDay? startTime = await selectTime(
                      context,
                      initialValue: startTimeStream.valueOrNull,
                      minHour: startHour.toDouble(),
                      maxHour: endHour - 1,
                    );
                    if (startTime != null) {
                      startTimeStream.add(startTime);
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: startTimeCtrl,
                      decoration: getDecoration(
                        lang.startTime,
                        true,
                      ),
                      validator: (value) => Validations.requiredField(
                          value == null ? null : "$value", context),
                    ),
                  ),
                ),
                Gap(16),
                IgnorePointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: endTimeCtrl,
                    decoration: getDecoration(
                      lang.endTime,
                      true,
                    ),
                    validator: (value) => Validations.requiredField(
                        value == null ? null : "$value", context),
                  ),
                ),
              ],
            ),
          ),
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
        typeStream.valueOrNull != null &&
        dateStream.valueOrNull != null) {
      progressSubject.add(true);
      var date = dateStream.value!;
      var startTime = startTimeStream.value;
      var startDate = DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      );
      var endDate = startDate.add(Duration(hours: 1));
      MeetingInput input = MeetingInput(
        name: nameCtrl.text,
        nbParticipants: int.tryParse(nbParticipantsCtrl.text) ?? 1,
        typeId: typeStream.valueOrNull!.id,
        endDate: endDate.millisecondsSinceEpoch,
        startDate: startDate.millisecondsSinceEpoch,
      );
      Booking? res;
      try {
        res = await bookingService.createBooking(input);

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

  Future getRequirements() async {
    progressSubject.add(true);
    try {
      var res =
          await meetingRequirementService.getAllMeetingRequirements(0, 100);
      allTypesStream.add(res);
    } catch (error, stacktrace) {
      print(stacktrace);
      showServerError(context, error: error);
    } finally {
      progressSubject.add(false);
    }
  }
}
