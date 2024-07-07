import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_planner/main.dart';
import 'package:meeting_planner/src/model/enums/meeting_type.dart';
import 'package:meeting_planner/src/settings/lang.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:rxdart/rxdart.dart';

abstract class BasicState<T extends StatefulWidget> extends State<T>
    with LangMixin {
  @override
  void dispose() {
    for (var element in subjects) {
      element.close();
    }
    for (var element in notifiers) {
      element.dispose();
    }

    super.dispose();
  }

  List<Subject> get subjects => [];

  List<ChangeNotifier> get notifiers => [];
}

extension AppLocalizationsExt on AppLocalizations {
  static final DateFormat _dateFormat = DateFormat("dd/MM/yyyy");

  static final DateFormat _timeFormat = DateFormat("HH:mm");

  static final DateFormat _dateTimeFormat = DateFormat("dd/MM/yyyy HH:mm");
  static final DateFormat _dateTimeFormat2 = DateFormat("dd-MM-yyyy_HH-mm-ss");
  static final DateFormat _dayFormat = DateFormat("E dd");
  static final DateFormat _monthFormat =
      DateFormat("MMMM", "${settingsController.locale}");
  static final DateFormat _dayNameFormat =
      DateFormat("EEEE", "${settingsController.locale}");
  static final DateFormat _monthYearFormat = DateFormat("MM/yyyy");
  String formatDateDate(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }

  String formatDayName(dateTime) {
    return _dayNameFormat.format(dateTime);
  }

  String formatMonth(DateTime dateTime) {
    return _monthFormat.format(dateTime);
  }

  String formatDateMillis(int date) {
    return formatDateDate(DateTime.fromMillisecondsSinceEpoch(date));
  }

  String formatMonthYear(DateTime dateTime) {
    return _monthYearFormat.format(dateTime);
  }

  String formatMonthYearMillis(int dateTimeMillis) {
    return formatMonthYear(DateTime.fromMillisecondsSinceEpoch(dateTimeMillis));
  }

  String formatDate(int date) {
    return _dateFormat.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  String formatTime(int date) {
    return _timeFormat.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    return formatTime(DateTime(0, 1, 1, timeOfDay.hour, timeOfDay.minute)
        .millisecondsSinceEpoch);
  }

  String formatDateTime(int date) {
    return _dateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  String formatDateTime2(DateTime date) {
    return _dateTimeFormat2.format(date);
  }

  int timeOfDayToInt(TimeOfDay timeOfDay) {
    return DateTime(0, 1, 1, timeOfDay.hour, timeOfDay.minute)
        .millisecondsSinceEpoch;
  }

  String formatDay(int date) {
    return _dayFormat.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  String monthName(int date) {
    return DateFormat('MMMM').format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  String meetingTypeName(MeetingType meetingType) {
    switch (meetingType) {
      case MeetingType.VC:
        return videoconferences;
      case MeetingType.RC:
        return pairedMeetings;
      case MeetingType.RS:
        return simpleMeetings;
      case MeetingType.SPEC:
        return sharingSessions;
    }
  }
}
