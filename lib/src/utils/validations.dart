import 'package:flutter/material.dart';
import 'package:meeting_planner/src/settings/lang.dart';

class Validations {
  static String? requiredField(String? text, BuildContext context) {
    return (text?.isEmpty ?? true) ? getLang(context).requiredField : null;
  }

  static String? requiredobject(Object? text, BuildContext context) {
    return (text != null) ? getLang(context).requiredField : null;
  }

  static String? intValidator(
    String? text,
    BuildContext context, {
    required = false,
    int? minValue,
    int? maxValue,
  }) {
    if (text != null && text.isNotEmpty) {
      try {
        int i = int.parse(text);

        if (minValue != null && i < minValue) {
          return getLang(context).minValue(minValue);
        }
        if (maxValue != null && i > maxValue) {
          return getLang(context).maxValue(maxValue);
        }
      } catch (error) {
        return getLang(context).invalidValue;
      }
    }
    return required ? requiredField(text, context) : null;
  }

  static String? doubleValidator(
    String? text,
    BuildContext context, {
    required = false,
    double? minValue,
    double? maxValue,
  }) {
    if (text != null && text.isNotEmpty) {
      try {
        double i = double.parse(text);

        if (minValue != null && i < minValue) {
          return getLang(context).minValue(minValue);
        }
        if (maxValue != null && i > maxValue) {
          return getLang(context).maxValue(maxValue);
        }
      } catch (error) {
        return getLang(context).invalidValue;
      }
    }
    return required ? requiredField(text, context) : null;
  }
}
